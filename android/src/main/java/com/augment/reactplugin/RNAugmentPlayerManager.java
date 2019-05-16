package com.augment.reactplugin;

import android.view.ViewGroup;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

public class RNAugmentPlayerManager extends SimpleViewManager<RNAugmentPlayer> {
    @Nonnull
    @Override
    public String getName() {
        return "RNAugmentPlayer";
    }

    @Nonnull
    @Override
    protected RNAugmentPlayer createViewInstance(@Nonnull ThemedReactContext reactContext) {
        RNAugmentPlayer view = new RNAugmentPlayer(reactContext);
        view.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        view.setText("Hello AR");
        return view;
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return new HashMap<String, Object>(){{
            put("ModelGesture", "");
            put("TrackingStatus", "");
        }};
    }

    @Override
    public void receiveCommand(@Nonnull RNAugmentPlayer root, int commandId, @Nullable ReadableArray args) {
        super.receiveCommand(root, commandId, args);
    }
}
