package com.augment.reactplugin;

import android.content.Context;
import android.opengl.GLSurfaceView;
import android.util.AttributeSet;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;


@SuppressWarnings("unused")
public class AugmentReactPlayerView extends GLSurfaceView {

    /**
     * This is an Interface for a static callback that will be called when the view has finished its instantiation
     * We need that because this is a GLSurfaceView and the render has to be defined before the view is added to the layout
     * We don't know when React will push it in the view group and the renderer is setup by Augment SDK
     * that way we give a chance to anyone to setup the render as soon as possible
     */
    interface InstantiationCallback {
        void instantiationDone(AugmentReactPlayerView playerView);
        void playerAttachedToWindow();
    }

    private static InstantiationCallback instantiationCallback = null;

    /**
     * Define the instantiation callback @see InstantiationCallback for details
     * @param instantiationCallback the callback to be executed
     */
    public static void SetInstantiationCallback(InstantiationCallback instantiationCallback) {
        AugmentReactPlayerView.instantiationCallback = instantiationCallback;
    }

    public AugmentReactPlayerView(Context context) {
        super(context);
        init();
    }

    public AugmentReactPlayerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void dispatchOnPlayerReady() {
        WritableMap event = Arguments.createMap();
        event.putNull("playerReady");
        ReactContext reactContext = (ReactContext)getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                "onPlayerReady",
                event);
    }

    void init() {
        if (instantiationCallback != null) {
            instantiationCallback.instantiationDone(this);
        }
    }

    /**
     * This is used by AugmentReact to know when the Player has been added to the view hierarchy
     * from that point it will give access to `player` in the javascript code
     */
    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        if (instantiationCallback != null) {
            instantiationCallback.playerAttachedToWindow();
            dispatchOnPlayerReady();
        }
    }
}
