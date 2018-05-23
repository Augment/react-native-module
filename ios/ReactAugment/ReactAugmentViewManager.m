//
//  ReactAugmentViewManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentViewManager.h"
#import "ReactAugmentManager.h"

@implementation ReactAugmentViewManager

RCT_EXPORT_MODULE(AugmentReactPlayerNative)

RCT_EXPORT_VIEW_PROPERTY(onViewLoaded, RCTDirectEventBlock)

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
    [self onViewLoaded:augmentView];
    NSLog(@"instat DONE - exit");
}

- (void)onViewLoaded:(AugmentReactPlayerView *)augmentView {
    if (!augmentView.onViewLoaded) {
        return;
    }
    augmentView.onViewLoaded(NULL);
}

@end
