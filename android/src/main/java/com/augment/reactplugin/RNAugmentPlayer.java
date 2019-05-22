package com.augment.reactplugin;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.fragment.app.FragmentManager;

import com.ar.augment.arplayer.model.ComputedDimension;
import com.ar.augment.arplayer.model.DisplayConfiguration;
import com.ar.augment.arplayer.model.Model3D;
import com.ar.augment.arplayer.model.Model3DFile;
import com.ar.augment.arplayer.model.Thumbnail;
import com.ar.augment.arplayer.sdk.AugmentPlayerFragment;
import com.facebook.react.ReactActivity;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import kotlin.Unit;

public class RNAugmentPlayer extends FrameLayout {
    public static int generateViewId = View.generateViewId();
    private static final String AUGMENT_FRAGMENT_TAG = "AUGMENT_FRAGMENT_TAG";

    public RNAugmentPlayer(Context context) {
        super(context);
        setUpListener();
    }

    public RNAugmentPlayer(Context context, AttributeSet attrs) {
        super(context, attrs);
        setUpListener();
    }

    public RNAugmentPlayer(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        setUpListener();
    }

    /// TEST FOR EVENTS
    private void setUpListener() {
        setOnClickListener(v -> onReceiveNativeEvent());
        setId(generateViewId);
    }

    public void onReceiveNativeEvent() {
        ReactContext reactContext = (ReactContext) getContext();
        RCTEventEmitter eventEmitter = reactContext.getJSModule(RCTEventEmitter.class);
        eventEmitter.receiveEvent(
                getId(),
                RNAugmentPlayerEvent.onLoadingDidFinish.toString(),
                null);
        eventEmitter.receiveEvent(
                getId(),
                RNAugmentPlayerEvent.onPlayerReady.toString(),
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
}
