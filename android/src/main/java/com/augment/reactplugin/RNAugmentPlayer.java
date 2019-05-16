package com.augment.reactplugin;

import android.content.Context;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatTextView;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;

public class RNAugmentPlayer extends AppCompatTextView {
    public RNAugmentPlayer(Context context) {
        super(context);
        onDidiFinish();
    }

    public RNAugmentPlayer(Context context, AttributeSet attrs) {
        super(context, attrs);
        onDidiFinish();
    }

    public RNAugmentPlayer(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        onDidiFinish();
    }

    private void onDidiFinish() {
        setOnClickListener(v -> onReceiveNativeEvent());
    }

    public void onReceiveNativeEvent() {
//        WritableMap event = Arguments.createMap();
//        event.putString("message", "MyMessage");
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                "onLoadingDidFinish",
                null // event
        );
    }
}
