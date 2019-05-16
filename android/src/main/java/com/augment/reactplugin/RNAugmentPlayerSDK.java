package com.augment.reactplugin;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import javax.annotation.Nonnull;

public class RNAugmentPlayerSDK extends ReactContextBaseJavaModule {
    public RNAugmentPlayerSDK(@Nonnull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Nonnull
    @Override
    public String getName() {
        return RNAugmentPlayerSDK.class.getSimpleName();
    }

    @ReactMethod
    public void init(ReadableMap product) {

    }

    @ReactMethod
    public void isARKitAvailable(Callback callback) {
        callback.invoke(true);
    }

    /**
     * This method corresponds to `AugmentReact.checkIfModelDoesExistForUserProduct`
     * product is a Map object that represent a product
     * it has "identifier" "brand" "name" and "ean" keys
     * This method returns an augmentProduct through the React promise mechanism
     */
    @ReactMethod
    public void checkIfModelDoesExistForUserProduct(ReadableMap product, Promise promise) {
        promise.reject("500", "TODO");
    }
}
