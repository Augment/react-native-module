package com.augment.reactplugin;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

public class RNAugmentPlayerManager extends ViewGroupManager<RNAugmentPlayer> {
    private static final int COMMAND_CREATE = 12;
    private RNAugmentPlayer rnAugmentPlayer;

    @Nonnull
    @Override
    public String getName() {
        return "RNAugmentPlayer";
    }

    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
    }

    @Nonnull
    @Override
    protected RNAugmentPlayer createViewInstance(@Nonnull ThemedReactContext reactContext) {
        rnAugmentPlayer = new RNAugmentPlayer(reactContext);
        return rnAugmentPlayer;
    }

    @Override
    public void onDropViewInstance(@Nonnull RNAugmentPlayer view) {
        super.onDropViewInstance(view);
        rnAugmentPlayer.removeFragment(view);
    }

    @Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
        return MapBuilder.of(
                "create", COMMAND_CREATE
        );
    }

    @Override
    public void receiveCommand(@Nonnull RNAugmentPlayer root, int commandId, @Nullable ReadableArray args) {
        switch (commandId) {
            case COMMAND_CREATE:
                rnAugmentPlayer.createFragment((ReactContext) root.getContext());
                break;
        }
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
