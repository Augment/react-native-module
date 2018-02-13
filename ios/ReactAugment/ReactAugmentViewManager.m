//
//  ReactAugmentViewManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentViewManager.h"

@implementation ReactAugmentViewManager

RCT_EXPORT_MODULE(AugmentReactPlayerNative)

- (UIView*) view {
  return [AugmentReactPlayerView new];
}

@end
