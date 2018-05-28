package com.augment.reactplugin;

import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

import javax.annotation.Nullable;
import java.util.Map;

public class ReactAugmentPlayerManager extends SimpleViewManager<AugmentReactPlayerView> {

    public static final String REACT_CLASS = "AugmentReactPlayerNative";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected AugmentReactPlayerView createViewInstance(ThemedReactContext reactContext) {
        return new AugmentReactPlayerView(reactContext);
    }

    @Nullable
    @Override
    public Map getExportedCustomDirectEventTypeConstants() {
        return MapBuilder.of("onPlayerReady", MapBuilder.of("registrationName","onPlayerReady"));
    }
}
