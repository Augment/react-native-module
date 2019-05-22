package com.augment.reactplugin;

import com.ar.augment.arplayer.sdk.AugmentSDK;
import com.ar.augment.arplayer.services.payloads.ProductQuery;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import javax.annotation.Nonnull;

import kotlin.Unit;

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
    public void checkIfModelDoesExistForUserProduct(ReadableMap productMap, Promise promise) {
        AugmentSDK.getInstance()
                .getProductsDataController()
                .checkIfModelDoesExistForUserProductQuery(
                        new ProductQuery(
                                productMap.getString(RNAugmentPlayerProductKeys.IDENTIFIER),
                                productMap.getString(RNAugmentPlayerProductKeys.BRAND),
                                productMap.getString(RNAugmentPlayerProductKeys.NAME)),
                        (product, error) -> {
                            if (error != null || product == null) {
                                promise.reject("500", error == null ? "Product doesn't exist" : error.getMessage());
                            } else {
                                WritableMap map = Arguments.createMap();
                                map.putString(RNAugmentPlayerProductKeys.IDENTIFIER, product.getIdentifier());
                                map.putString(RNAugmentPlayerProductKeys.BRAND, product.getBrand());
                                map.putString(RNAugmentPlayerProductKeys.NAME, product.getName());
                                map.putString(RNAugmentPlayerProductKeys.EAN, product.getEan());
                                promise.resolve(map);
                            }
                            return Unit.INSTANCE;
                        });
    }
}
