package com.augment.reactplugin;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;

public class RNAugmentPlayer extends FrameLayout {
    public static int generateViewId = View.generateViewId();

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
//        setBackgroundColor(Color.TRANSPARENT);
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
}
