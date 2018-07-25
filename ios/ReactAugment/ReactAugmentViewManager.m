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
    AugmentReactPlayerView* view = [AugmentReactPlayerView new];
    view.augmentReactPlayerViewDelegate = self;
    return view;
}

- (void)onInstantiationDone:(AugmentReactPlayerView *)augmentView {
    if (augmentView == NULL) {
      [ReactAugmentManager.augmentSDK.augmentPlayer pause];
      [ReactAugmentManager.augmentSDK.augmentPlayer unloadAll];
      return;
    }

    augmentView.augmentPlayer = ReactAugmentManager.augmentSDK.augmentPlayer;
    [ReactAugmentManager.augmentSDK.augmentPlayer resume];
    [self onPlayerReady:augmentView];
}

- (void)onPlayerReady:(AugmentReactPlayerView *)augmentView {
    if (!augmentView.onPlayerReady) {
        return;
    }
    augmentView.onPlayerReady(NULL);
}

@end
