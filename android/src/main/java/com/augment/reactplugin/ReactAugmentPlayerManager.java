package com.augment.reactplugin;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

@SuppressWarnings("WeakerAccess")
public class ReactAugmentPlayerManager extends SimpleViewManager<AugmentReactPlayerView> {

    static final String REACT_CLASS = "AugmentReactPlayerNative";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected AugmentReactPlayerView createViewInstance(ThemedReactContext reactContext) {
        return new AugmentReactPlayerView(reactContext);
    }
}
