package com.augment.reactplugin;

import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.ar.augment.arplayer.sdk.AugmentPlayerFragment;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import kotlin.Unit;

public class RNAugmentPlayerManager extends ViewGroupManager<RNAugmentPlayer> {
    private RNAugmentPlayer rnAugmentPlayer;
    private int id = View.generateViewId();

    @Nonnull
    @Override
    public String getName() {
        return "RNAugmentPlayer";
    }

    @Nonnull
    @Override
    protected RNAugmentPlayer createViewInstance(@Nonnull ThemedReactContext reactContext) {
        rnAugmentPlayer = new RNAugmentPlayer(reactContext);
        rnAugmentPlayer.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
//        final FrameLayout view = new FrameLayout(reactContext);
        AugmentPlayerFragment fragment = new AugmentPlayerFragment();
        // Add the fragment into the FrameLayout
        AppCompatActivity activity = (AppCompatActivity) reactContext.getCurrentActivity();

//        activity.getWindow().getDecorView().<ViewGroup>findViewById(android.R.id.content)
//                .addView(
//                        new FrameLayout(reactContext) {
//                            {
//                                setId(id);
//                                setLayoutParams(new LayoutParams(
//                                        LayoutParams.MATCH_PARENT,
//                                        LayoutParams.MATCH_PARENT));
//                                setBackgroundColor(Color.CYAN);
//                            }
//                        });
        activity.getSupportFragmentManager()
                .beginTransaction()
                .replace(android.R.id.content, fragment, "My_TAG")
                .commitNow();
        // Execute the commit immediately or can use commitNow() instead
        activity.getSupportFragmentManager().executePendingTransactions();
        fragment.getAugmentPlayer().getViews().createLiveViewer(() -> Unit.INSTANCE);
        // This step is needed to in order for ReactNative to render your view
//        addView(rnAugmentPlayer, fragment.getView(), 0);
        return rnAugmentPlayer;
    }

    /**
     * This method corresponds to `AugmentReact.addProductToAugmentPlayer`
     * data is a Map object that represent a product
     * it has "identifier" "brand" "name" and "ean" keys
     * This method needs to be called after the success of `AugmentReact.start`
     */
    @ReactMethod
    public void addProduct(int reactTag, ReadableMap product, Promise promise) {
        promise.reject("500", "Error: SDK is not available on Android.");
    }

    /**
     * This method corresponds to `AugmentReact.recenterProducts`
     * This method needs to be called after the success of `AugmentReact.start`
     */
    @ReactMethod
    public void recenterProducts(int reactTag, Promise promise) {
        promise.reject("500", "Error: SDK is not available on Android.");
    }


    @ReactMethod
    public void takeScreenshot(int reactTag, @NonNull final Promise promise) {
        promise.reject("500", "Error: SDK is not available on Android.");
    }

    public Map<String, Object> getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.<String, Object>builder()
                .put(RNAugmentPlayerEvent.onPlayerReady.toString(), getBubbledEventMapFor(RNAugmentPlayerEvent.onPlayerReady.toString()))
                .put(RNAugmentPlayerEvent.onInitializationFailed.toString(), getBubbledEventMapFor(RNAugmentPlayerEvent.onInitializationFailed.toString()))
                .put(RNAugmentPlayerEvent.onLoadingProgressDidChange.toString(), getBubbledEventMapFor(RNAugmentPlayerEvent.onLoadingProgressDidChange.toString()))
                .put(RNAugmentPlayerEvent.onLoadingDidFinish.toString(), getBubbledEventMapFor(RNAugmentPlayerEvent.onLoadingDidFinish.toString()))
                .put(RNAugmentPlayerEvent.onTrackingStatusChanged.toString(), getBubbledEventMapFor(RNAugmentPlayerEvent.onTrackingStatusChanged.toString()))
                .put(RNAugmentPlayerEvent.onModelGesture.toString(), getBubbledEventMapFor(RNAugmentPlayerEvent.onModelGesture.toString()))
                .build();
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return new HashMap<String, Object>() {{
            put("ModelGesture", "");
            put("TrackingStatus", "");
        }};
    }

    @NotNull
    private Map<String, Map<String, String>> getBubbledEventMapFor(@Nonnull String event) {
        return MapBuilder.of(
                "phasedRegistrationNames",
                MapBuilder.of("bubbled", event));
    }
}
