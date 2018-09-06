//
//  AugmentReactPlayerModelGestureEmitter.m
//  ReactAugment
//
//  Created by Stephane Garagnani on 09/07/2018.
//  Copyright © 2018 Augment. All rights reserved.
//

#import "AugmentReactPlayerModelGestureEmitter.h"
#import "ReactAugmentManager.h"
@import AugmentPlayerSDK;

@interface AugmentReactPlayerModelGestureEmitter () <AGTAugmentPlayerModelGestureDelegate>
@property (nonatomic, weak) id<AGTAugmentPlayer> augmentPlayer;
@end

@implementation AugmentReactPlayerModelGestureEmitter {
  bool hasListeners;
}
RCT_EXPORT_MODULE(AugmentReactPlayerModelGestureEmitter);

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)startObserving {
    hasListeners = YES;
    _augmentPlayer.modelGestureDelegate = self;
}

- (void)stopObserving {
    hasListeners = NO;
    _augmentPlayer.modelGestureDelegate = nil;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[
             @"ModelAdded",
             @"ModelTranslated",
             @"ModelRotated",
             ];
}


- (void)onModelAdded:(NSString * _Nonnull)model3DUuid {
    if (hasListeners) {
      [self sendEventWithName:@"ModelAdded" body:model3DUuid];
    }
}

- (void)onModelRotated:(NSString * _Nonnull)model3DUuid {
  if (hasListeners) {
    [self sendEventWithName:@"ModelRotated" body:model3DUuid];
  }
}

- (void)onModelTranslated:(NSString * _Nonnull)model3DUuid {
  if (hasListeners) {
    [self sendEventWithName:@"ModelTranslated" body:model3DUuid];
  }
}

@end
