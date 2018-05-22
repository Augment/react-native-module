//
//  AugmentReactPlayerView.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "AugmentReactPlayerView.h"

@implementation AugmentReactPlayerView

- (void) willMoveToSuperview:(UIView *)newSuperview {
  NSLog(@"will move to super view %@", newSuperview);
}

- (void) didMoveToSuperview {
    if (self.superview != NULL) {
        [self.augmentReactPlayerViewDelegate onInstantiationDone:self];
    } else {
//        [self.augmentReactPlayerViewDelegate onInstantiationDone:NULL];
//        [self.augmentPlayer pause];
    }
}

@end
