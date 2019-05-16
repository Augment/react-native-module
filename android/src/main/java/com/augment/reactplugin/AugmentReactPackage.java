package com.augment.reactplugin;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nonnull;

public class AugmentReactPackage implements ReactPackage {

    private RNAugmentPlayerManager rnAugmentPlayerManager = new RNAugmentPlayerManager();

    @Nonnull
    @Override
    public List<NativeModule> createNativeModules(@Nonnull final ReactApplicationContext reactContext) {
        return new ArrayList<NativeModule>() {{
            add(new RNAugmentPlayerSDK(reactContext));
            add(rnAugmentPlayerManager);
        }};
    }

    @Nonnull
    @Override
    public List<ViewManager> createViewManagers(@Nonnull ReactApplicationContext reactContext) {
        return new ArrayList<ViewManager>() {{
            add(rnAugmentPlayerManager);
        }};
    }
}
