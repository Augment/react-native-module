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

    //    - (void) init:(NSDictionary*) data;
    @ReactMethod
    public void init(ReadableMap product) {

    }

    //- (void) isARKitAvailable:(RCTResponseSenderBlock) callback;
    @ReactMethod
    public void isARKitAvailable(Callback callback) {
        callback.invoke(true);
    }

    //- (void) checkIfModelDoesExistForUserProduct: (NSDictionary*) product
    // resolver: (RCTPromiseResolveBlock) resolver
    // rejecter:(RCTPromiseRejectBlock) rejecter;
    @ReactMethod
    public void checkIfModelDoesExistForUserProduct(ReadableMap product, Promise promise) {
        promise.resolve(true);
    }
}