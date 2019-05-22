package com.augment.reactplugin;

import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentManager;

import com.ar.augment.arplayer.model.ComputedDimension;
import com.ar.augment.arplayer.model.DisplayConfiguration;
import com.ar.augment.arplayer.model.Model3D;
import com.ar.augment.arplayer.model.Model3DFile;
import com.ar.augment.arplayer.model.Thumbnail;
import com.ar.augment.arplayer.sdk.AugmentPlayerFragment;
import com.facebook.react.ReactActivity;
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

import kotlin.Unit;

public class RNAugmentPlayerManager extends ViewGroupManager<RNAugmentPlayer> {
    private static final int COMMAND_CREATE = 12;
    private static final String AUGMENT_FRAGMENT_TAG = "AUGMENT_FRAGMENT_TAG";
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
        rnAugmentPlayer.setLayoutParams(new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        return rnAugmentPlayer;
    }

    @Override
    public void onDropViewInstance(@Nonnull RNAugmentPlayer view) {
        super.onDropViewInstance(view);
        ReactActivity activity = (ReactActivity) ((ReactContext) view.getContext()).getCurrentActivity();
        FragmentManager supportFragmentManager = activity.getSupportFragmentManager();
        view.removeAllViews();

        AugmentPlayerFragment fragment = (AugmentPlayerFragment) supportFragmentManager.findFragmentByTag(AUGMENT_FRAGMENT_TAG);
        fragment.getAugmentPlayer().getViews().destroyCurrentViewer();
        supportFragmentManager
                .beginTransaction()
                .detach(fragment)
                .remove(fragment)
                .commit();
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
                createFragment((ReactContext) root.getContext());
                break;
        }
    }

    private void createFragment(ReactContext context) {
        AugmentPlayerFragment fragment = new AugmentPlayerFragment();
        ReactActivity activity = (ReactActivity) context.getCurrentActivity();
        activity.getSupportFragmentManager()
                .beginTransaction()
                .add(fragment, AUGMENT_FRAGMENT_TAG)
                .commitNow();
        rnAugmentPlayer.addView(fragment.getView(), 0);
        fragment.getAugmentPlayer().getViews().createLiveViewer(() -> {
            fragment.getAugmentPlayer().getContent().add(new Model3D("",
                            "",
                            new ComputedDimension(0.0, 0.0, 0.0, 0.0, ""),
                            "",
                            "",
                            new DisplayConfiguration(),
                            false,
                            false,
                            new Thumbnail("", 0, 0),
                            new Thumbnail("", 0, 0),
                            new Model3DFile("", "", ""),
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            new Thumbnail("", 0, 0),
                            "",
                            "",
                            "66b4630e-688f-49e0-a0b9-a3f23443f4f1",
                            "",
                            "")

                    , (model3DInstance, error) -> Unit.INSTANCE);
            ViewGroup view = (ViewGroup) fragment.getView();
            for (int i = 0; i < view.getChildCount(); i++) {
                View child = view.getChildAt(i);
                child.measure(
                        View.MeasureSpec.makeMeasureSpec(rnAugmentPlayer.getMeasuredWidth(), View.MeasureSpec.EXACTLY),
                        View.MeasureSpec.makeMeasureSpec(rnAugmentPlayer.getMeasuredHeight(), View.MeasureSpec.EXACTLY));
                child.layout(0, 0, child.getMeasuredWidth(), child.getMeasuredHeight());
            }
            return Unit.INSTANCE;
        });
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
