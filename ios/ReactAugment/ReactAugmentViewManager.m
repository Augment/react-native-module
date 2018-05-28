//
//  ReactAugmentViewManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentViewManager.h"
#import "ReactAugmentManager.h"

@implementation ReactAugmentViewManager

RCT_EXPORT_MODULE(AugmentReactPlayerNative)

RCT_EXPORT_VIEW_PROPERTY(onPlayerReady, RCTDirectEventBlock)

- (UIView*) view {
    NSLog(@"GET newView");
    AugmentReactPlayerView* view = [AugmentReactPlayerView new];
    view.augmentReactPlayerViewDelegate = self;
    return view;
}

- (void)onInstantiationDone:(AugmentReactPlayerView *)augmentView {
    NSLog(@"instat DONE");
    if (augmentView == NULL) {
      [ReactAugmentManager.augmentSDK.augmentPlayer unloadAll];
        NSLog(@"instat DONE Pausing");
      return;
    }

    //    augmentView.augmentPlayer = ReactAugmentManager.augmentSDK.augmentPlayer;
    //    [augmentView.augmentPlayer resume];
    augmentView.augmentPlayer = ReactAugmentManager.augmentSDK.augmentPlayer;
    [ReactAugmentManager.augmentSDK.augmentPlayer resume];
    [self onPlayerReady:augmentView];
    NSLog(@"instat DONE - exit");
}

- (void)onPlayerReady:(AugmentReactPlayerView *)augmentView {
    if (!augmentView.onPlayerReady) {
        return;
    }
    augmentView.onPlayerReady(NULL);
}

@end
