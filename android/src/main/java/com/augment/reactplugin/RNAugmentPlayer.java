package com.augment.reactplugin;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.fragment.app.FragmentManager;

import com.ar.augment.arplayer.model.Product;
import com.ar.augment.arplayer.sdk.AugmentPlayer;
import com.ar.augment.arplayer.sdk.AugmentPlayerFragment;
import com.ar.augment.arplayer.sdk.AugmentSDK;
import com.facebook.react.ReactActivity;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import kotlin.Unit;

public class RNAugmentPlayer extends FrameLayout {
    private static final String AUGMENT_FRAGMENT_TAG = "AUGMENT_FRAGMENT_TAG";
    private AugmentPlayer augmentPlayer;

    public RNAugmentPlayer(Context context) {
        super(context);
    }

    public RNAugmentPlayer(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public RNAugmentPlayer(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void onReceiveNativeEvent(RNAugmentPlayerEvent event) {
        ReactContext reactContext = (ReactContext) getContext();
        RCTEventEmitter eventEmitter = reactContext.getJSModule(RCTEventEmitter.class);
        eventEmitter.receiveEvent(
                getId(),
                event.toString(),
                null);
    }

    void createFragment(ReactContext context) {
        AugmentPlayerFragment fragment = new AugmentPlayerFragment();
        ReactActivity activity = (ReactActivity) context.getCurrentActivity();
        activity.getSupportFragmentManager()
                .beginTransaction()
                .add(fragment, AUGMENT_FRAGMENT_TAG)
                .commitNow();
        addView(fragment.getView(), 0);
        augmentPlayer = fragment.getAugmentPlayer();
        augmentPlayer.getViews().createLiveViewer(() -> {
            onReceiveNativeEvent(RNAugmentPlayerEvent.onPlayerReady);
            onReceiveNativeEvent(RNAugmentPlayerEvent.onLoadingDidFinish);
            ViewGroup view = (ViewGroup) fragment.getView();
            for (int i = 0; i < view.getChildCount(); i++) {
                View child = view.getChildAt(i);
                child.measure(
                        View.MeasureSpec.makeMeasureSpec(getMeasuredWidth(), View.MeasureSpec.EXACTLY),
                        View.MeasureSpec.makeMeasureSpec(getMeasuredHeight(), View.MeasureSpec.EXACTLY));
                child.layout(0, 0, child.getMeasuredWidth(), child.getMeasuredHeight());
            }
            return Unit.INSTANCE;
        });
    }

    void removeFragment(RNAugmentPlayer view) {
        ReactActivity activity = (ReactActivity) ((ReactContext) getContext()).getCurrentActivity();
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

    public void addProduct(ReadableMap productMap, Promise promise) {
        Product product = AugmentSDK.getInstance().getProductsDataController().getProduct(productMap.getString(RNAugmentPlayerProductKeys.IDENTIFIER));
        if (augmentPlayer != null) {
            ((ReactContext) getContext()).getCurrentActivity().runOnUiThread(() ->
                    augmentPlayer.getContent().add(product.getModel3D(), (model3DInstance, error) -> {
                        if (error != null) {
                            promise.reject("500", error.getMessage());
                        }
                        if (model3DInstance != null) {
                            promise.resolve(null);
                        }
                        return Unit.INSTANCE;
                    }));
        }
    }
}
