//
//  ReactAugmentViewManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentViewManager.h"
#import "ReactAugmentManager.h"

@implementation ReactAugmentViewManager

RCT_EXPORT_MODULE(AugmentReactPlayerNative)

- (UIView*) view {
    NSLog(@"GET newVIew");
    AugmentReactPlayerView* view = [AugmentReactPlayerView new];
    view.augmentReactPlayerViewDelegate = self;
    return view;
}

- (void)onInstantiationDone:(AugmentReactPlayerView *)augmentView {
    NSLog(@"instat DONE");
    if (augmentView == NULL) {
//      [self.augmentSDK.augmentPlayer pause];
        NSLog(@"instat DONE Pausing");
      return;
    }

    augmentView.augmentPlayer = ReactAugmentManager.augmentSDK.augmentPlayer;
    [augmentView.augmentPlayer resume];

    NSLog(@"instat DONE - exit");
}

@end
