package com.augment.reactplugin;

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import com.ar.augment.arplayer.AugmentPlayer;
import com.ar.augment.arplayer.AugmentPlayerException;
import com.ar.augment.arplayer.AugmentPlayerSDK;
import com.ar.augment.arplayer.InitializationListener;
import com.ar.augment.arplayer.LoaderCallback;
import com.ar.augment.arplayer.Product;
import com.ar.augment.arplayer.ProductDataController;
import com.ar.augment.arplayer.ProductQuery;
import com.ar.augment.arplayer.WebserviceException;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Map;

@SuppressWarnings({"unused", "WeakerAccess"})
public class AugmentReact extends ReactContextBaseJavaModule implements LifecycleEventListener, AugmentReactPlayerView.InstantiationCallback {

    static final String REACT_CLASS = "AugmentReact";
    static final String LOGTAG = AugmentReactPlayerView.class.getCanonicalName();

    // Events names

    static final String AUGMENT_EVENT_LOADING_PROGRESS = "augmentEventLoadingProgress";
    static final String AUGMENT_EVENT_LOADING_OVER     = "augmentEventLoadingOver";

    // Arguments keys

    static final String ARG_APP_ID      = "id";
    static final String ARG_APP_KEY     = "key";
    static final String ARG_VUFORIA_KEY = "vuforia";
    static final String ARG_IDENTIFIER  = "identifier";
    static final String ARG_BRAND       = "brand";
    static final String ARG_NAME        = "name";
    static final String ARG_EAN         = "ean";

    // Results keys

    static final String ARG_ERROR        = "error";
    static final String ARG_SUCCESS      = "success";
    static final String ARG_MODEL_NUMBER = "model_number";

    // Internals

    AugmentReactPlayerView augmentReactPlayerView = null;
    AugmentPlayerSDK augmentPlayerSDK;
    Promise startPromise;
    Promise productPromise;

    public AugmentReact(ReactApplicationContext reactContext) {
        super(reactContext);

        // Listen for lifecycle event, we need that for Augment SDK
        reactContext.addLifecycleEventListener(this);

        // Define a callback when a player will be instantiated
        AugmentReactPlayerView.SetInstantiationCallback(this);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @javax.annotation.Nullable
    @Override
    public Map<String, Object> getConstants() {
        HashMap<String, Object> constants = new HashMap<>();
        constants.put("AUGMENT_EVENT_LOADING_PROGRESS", AUGMENT_EVENT_LOADING_PROGRESS);
        constants.put("AUGMENT_EVENT_LOADING_OVER",     AUGMENT_EVENT_LOADING_OVER);
        return constants;
    }

    /**
     * This method corresponds to `AugmentReact.init`
     * data is a Map object with "id" "key" "vuforia" keys
     */
    @ReactMethod
    public void init(ReadableMap data) {
        augmentPlayerSDK = new AugmentPlayerSDK(
                getReactApplicationContext(),
                data.getString(ARG_APP_ID),
                data.getString(ARG_APP_KEY),
                data.getString(ARG_VUFORIA_KEY)
        );
    }

    /**
     * This method corresponds to `AugmentReact.checkIfModelDoesExistForUserProduct`
     * product is a Map object that represent a product
     * it has "identifier" "brand" "name" and "ean" keys
     * This method returns an augmentProduct through the React promise mechanism
     */
    @ReactMethod
    public void checkIfModelDoesExistForUserProduct(final ReadableMap product, final Promise promise) {
        ProductQuery query = BuildProductQueryFromProductHashMap(product);
        augmentPlayerSDK.getProductDataController().checkIfModelDoesExistForUserProductQuery(query, new ProductDataController.ProductQueryListener() {
            @Override
            public void onResponse(@Nullable Product product) {
                promise.resolve(getMapForProduct(product));
            }

            @Override
            public void onError(WebserviceException e) {
                promise.reject(e);
            }
        });
    }

    /**
     * This method corresponds to `AugmentReact.start`
     * It is a little tricky as it register for a broadcast receiver that will be triggered by the AugmentReactPlayerView
     * It is to be able to execute the Javascript promise when the ARView is ready to get commands
     */
    @ReactMethod
    public void start(Promise promise) {
        final Activity activity = getCurrentActivity();
        if (activity == null) {
            promise.reject(new Exception("Error: Activity is null."));
            return;
        }

        startPromise = promise;
    }

    @Override
    public void instantiationDone(AugmentReactPlayerView playerView) {
        augmentReactPlayerView = playerView;
        startARSession();
    }

    @Override
    public void playerAttachedToWindow() {
        startSuccess();
    }

    /**
     * This method corresponds to `AugmentReact.addProductToAugmentPlayer`
     * data is a Map object that represent a product
     * it has "identifier" "brand" "name" and "ean" keys
     * This method needs to be called after the success of `AugmentReact.start`
     */
    @ReactMethod
    public void addProductToAugmentPlayer(ReadableMap product, Promise promise) {
        if (augmentReactPlayerView == null) {
            promise.reject(new Exception("addProductToAugmentPlayer() must be used after a success call to start()"));
            return;
        }

        // Because adding a product to the ARView is a multi step operation
        // We save the promise so we can access it latter when the operation
        // has succeeded or failed
        productPromise = promise;

        getProduct(product);
    }

    /**
     * This method corresponds to `AugmentReact.recenterProducts`
     * This method needs to be called after the success of `AugmentReact.start`
     */
    @ReactMethod
    public void recenterProducts(Promise promise) {
        if (augmentReactPlayerView == null) {
            promise.reject(new Exception("recenterProducts() must be used after a success call to start()"));
            return;
        }

        if (augmentPlayerSDK == null) {
            promise.reject(new Exception("Error: AugmentReactPlayerView is not present in this Activity."));
            return;
        }

        augmentPlayerSDK.getAugmentPlayer().recenterProducts();
        promise.resolve(getMapForSuccess(null));
    }

    // AR Logic

    void startSuccess() {
        if (startPromise != null) {
            startPromise.resolve(getMapForSuccess(null));
            startPromise = null;
        }
    }

    void startError(String message) {
        Log.d(LOGTAG, "Start Error: " + message);
        if (startPromise != null) {
            startPromise.reject(new Exception(message));
            startPromise = null;
        }
    }

    /**
     * Init the AR view itself
     */
    void startARSession() {
        final Activity activity = getCurrentActivity();
        if (activity == null) {
            startError("Activity is null.");
            return;
        }

        if (augmentReactPlayerView == null) {
            startError("AugmentReactPlayerView is not present in this Activity.");
            return;
        }

        final AugmentPlayer augmentPlayer = augmentPlayerSDK.getAugmentPlayer();
        augmentPlayer.initAR(activity, augmentReactPlayerView, new InitializationListener() {

            @Override
            public void onInitARDone(GLSurfaceView glSurfaceView, AugmentPlayerException e) {
                // Check if there is no error
                if (e != null) {
                    sendEventLoadingOver();
                    startError(e.getLocalizedMessage());
                    return;
                }

                // For now it is the responsibility of the developer to start this asynchronously,
                // this will evolve in the future
                (new AsyncTask<Void, Void, Void>() {
                    @Override
                    protected Void doInBackground(Void... voids) {
                        try {
                            augmentPlayer.start();
                            augmentPlayer.resume();
                            startSuccess();
                        } catch (final AugmentPlayerException e) {
                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    sendEventLoadingOver();
                                    startError(e.getLocalizedMessage());
                                }
                            });
                        }
                        return null;
                    }
                }).execute();
            }
        });
    }

    void productSuccess() {
        if (productPromise != null) {
            productPromise.resolve(getMapForSuccess(null));
            productPromise = null;
        }
    }

    void productError(String message) {
        Log.d(LOGTAG, "Product Error: " + message);
        if (productPromise != null) {
            productPromise.reject(new Exception(message));
            productPromise = null;
        }
    }

    void getProduct(ReadableMap product) {

        ProductQuery query = AugmentReact.BuildProductQueryFromProductHashMap(product);
        augmentPlayerSDK.getProductDataController().checkIfModelDoesExistForUserProductQuery(query, new ProductDataController.ProductQueryListener() {
            @Override
            public void onResponse(@Nullable com.ar.augment.arplayer.Product augmentProduct) {
                if (augmentProduct == null) {
                    sendEventLoadingOver();
                    productError("This product is not available yet");
                    return;
                }

                addToARView(augmentProduct);
            }

            @Override
            public void onError(WebserviceException error) {
                sendEventLoadingOver();
                productError("This product is not available yet");
            }
        });
    }

    /**
     * This is used to throttle the number of event sent to React native otherwise it become overloaded
     */
    private int lastProgress = 0;

    void addToARView(@NonNull com.ar.augment.arplayer.Product product) {
        augmentPlayerSDK.addModel3DToAugmentPlayerWithProduct(product, new LoaderCallback() {
            @Override
            public void onSuccess(String modelIdentifier) {
                sendEventLoadingOver();
                productSuccess();
            }

            @Override
            public void onPreparingModel() {
                lastProgress = 0;
                sendEventLoadingProgress(0);
            }

            @Override
            public void onError(WebserviceException error) {
                sendEventLoadingOver();
                productError(error.getLocalizedMessage());
            }

            @Override
            public void onDownloadProgressUpdate(final Long aLong) {
                int progress = Math.min(100, aLong.intValue());
                if (progress <= lastProgress) return; // Throttling
                lastProgress = progress;
                sendEventLoadingProgress(progress);
            }
        });
    }

    // Activity lifecycle

    @Override
    public void onHostResume() {
        if (augmentPlayerSDK != null) {
            try {
                augmentPlayerSDK.getAugmentPlayer().resume();
            } catch (Exception e) {
                Log.e(LOGTAG, "EXCEPTION: " + e.getLocalizedMessage(), e);
            }
        }
    }

    @Override
    public void onHostPause() {
        if (augmentPlayerSDK != null) {
            try {
                augmentPlayerSDK.getAugmentPlayer().pause();
            } catch (Exception e) {
                Log.e(LOGTAG, "EXCEPTION: " + e.getLocalizedMessage(), e);
            }
        }
    }

    @Override
    public void onHostDestroy() {
        if (augmentPlayerSDK != null) {
            try {
                augmentPlayerSDK.getAugmentPlayer().stop();
            } catch (Exception e) {
                Log.e(LOGTAG, "EXCEPTION: " + e.getLocalizedMessage(), e);
            }
        }
    }

    // Events

    void sendEvent(String eventName, @Nullable WritableMap params) {
        getReactApplicationContext()
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    protected void sendEventLoadingProgress(int value) {
        WritableMap params = Arguments.createMap();
        params.putInt("progress", value);
        sendEvent(AUGMENT_EVENT_LOADING_PROGRESS, params);
    }

    protected void sendEventLoadingOver() {
        sendEvent(AUGMENT_EVENT_LOADING_OVER, null);
    }

    // Helpers

    protected WritableMap getMapForProduct(@Nullable Product product) {
        WritableMap result = Arguments.createMap();
        if (product == null) {
            return result;
        }

        result.putString(ARG_IDENTIFIER,  product.getIdentifier());
        result.putString(ARG_EAN,         product.getEan());
        result.putString(ARG_BRAND,       product.getBrand());
        result.putString(ARG_NAME,        product.getName());
        result.putString(ARG_MODEL_NUMBER, product.getModelNumber());
        return result;
    }

    protected WritableMap getMapForErrorMessage(String message) {
        WritableMap result = Arguments.createMap();
        result.putString(ARG_ERROR, message);
        return result;
    }

    protected WritableMap getMapForSuccess(@Nullable String message) {
        if (message == null) {
            message = "ok";
        }

        WritableMap result = Arguments.createMap();
        result.putString(ARG_SUCCESS, message);
        return result;
    }

    public static ProductQuery BuildProductQueryFromProductHashMap(ReadableMap product) {
        ProductQuery.Builder builder = new ProductQuery.Builder(
                product.getString(ARG_IDENTIFIER),
                product.getString(ARG_BRAND),
                product.getString(ARG_NAME)
        );

        if (product.hasKey(ARG_EAN) && !product.getString(ARG_EAN).isEmpty()) {
            builder.setEan(product.getString(ARG_EAN));
        }
        return builder.build();
    }
}
