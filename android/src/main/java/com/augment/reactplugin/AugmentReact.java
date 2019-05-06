package com.augment.reactplugin;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import java.util.HashMap;
import java.util.Map;

@SuppressWarnings({"unused", "WeakerAccess"})
public class AugmentReact extends ReactContextBaseJavaModule {

    static final String REACT_CLASS = "AugmentReact";

    public AugmentReact(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @javax.annotation.Nullable
    @Override
    public Map<String, Object> getConstants() {
        HashMap<String, Object> constants = new HashMap<>();
        return constants;
    }

    /**
     * This method corresponds to `AugmentReact.init`
     * data is a Map object with "id" "key" "vuforia" keys
     */
    @ReactMethod
    public void init(ReadableMap data) {
    }

    /**
     * This method corresponds to `AugmentReact.checkIfModelDoesExistForUserProduct`
     * product is a Map object that represent a product
     * it has "identifier" "brand" "name" and "ean" keys
     * This method returns an augmentProduct through the React promise mechanism
     */
    @ReactMethod
    public void checkIfModelDoesExistForUserProduct(final ReadableMap product, final Promise promise) {
        promise.reject(new Exception("Error: SDK is not available on Android."));
    }

    /**
     * This method corresponds to `AugmentReact.start`
     * It is a little tricky as it register for a broadcast receiver that will be triggered by the AugmentReactPlayerView
     * It is to be able to execute the Javascript promise when the ARView is ready to get commands
     */
    @ReactMethod
    public void start(Promise promise) {
        promise.reject(new Exception("Error: SDK is not available on Android."));
    }

    /**
     * This method corresponds to `AugmentReact.addProductToAugmentPlayer`
     * data is a Map object that represent a product
     * it has "identifier" "brand" "name" and "ean" keys
     * This method needs to be called after the success of `AugmentReact.start`
     */
    @ReactMethod
    public void addProductToAugmentPlayer(ReadableMap product, Promise promise) {
        promise.reject(new Exception("Error: SDK is not available on Android."));
    }

    /**
     * This method corresponds to `AugmentReact.recenterProducts`
     * This method needs to be called after the success of `AugmentReact.start`
     */
    @ReactMethod
    public void recenterProducts(Promise promise) {
        promise.reject(new Exception("Error: SDK is not available on Android."));
    }

    @ReactMethod
    public void takeScreenshot(@NonNull final Promise promise){
        promise.reject(new Exception("Error: SDK is not available on Android."));
    }
}
