//
//  AugmentReactPlayerView.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "AugmentReactPlayerView.h"

@implementation AugmentReactPlayerView

+ (void) setInstantiationDelegate: (id<AugmentReactPlayerViewDelegate>) delegate {
  InstantiationDelegate = delegate;
}

- (void) willMoveToSuperview:(UIView *)newSuperview {
  NSLog(@"will move to super view %@", newSuperview);
}

- (void) didMoveToSuperview {
  if (InstantiationDelegate != nil) {
    [InstantiationDelegate instantiationDone:self];
    InstantiationDelegate = nil;
  }
}

@end
