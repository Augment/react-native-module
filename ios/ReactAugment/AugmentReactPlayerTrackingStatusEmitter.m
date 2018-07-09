//
//  ReactAugmentPlayerTrackingStatusEmitter.m
//  ReactAugment
//
//  Created by Stephane Garagnani on 09/07/2018.
//  Copyright © 2018 Augment. All rights reserved.
//

#import "AugmentReactPlayerTrackingStatusEmitter.h"
#import "ReactAugmentManager.h"

@interface AugmentReactPlayerTrackingStatusEmitter () <AGTAugmentPlayerTrackingStatusDelegate>
@end

@implementation AugmentReactPlayerTrackingStatusEmitter
RCT_EXPORT_MODULE(AugmentReactPlayerTrackingStatusEmitter);

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)startObserving {
    ReactAugmentManager.augmentSDK.augmentPlayer.trackingStatusDelegate = self;
}

- (void)stopObserving {
    ReactAugmentManager.augmentSDK.augmentPlayer.trackingStatusDelegate = self;
}

- (void)trackStatus:(AGTTrackingStatus)status withErrorMessage:(NSString * _Nullable)errorMessage {
    [self sendEventWithName:[self.class trackingStatusName:status] body:(errorMessage ?: @"")];
}

- (NSArray<NSString *> *)supportedEvents
{
    return [[self.class trackingStatusNames] allValues];
}

+ (NSString*)trackingStatusName:(AGTTrackingStatus)status {
    return [self trackingStatusNames][@(status)];
}

+ (NSDictionary*)trackingStatusNames {
    return @{
             @(AGTTrackingStatusError) : @"Error",
             @(AGTTrackingStatusFeaturesDetected): @"FeaturesDetected",
             @(AGTTrackingStatusInitializing): @"Initializing",
             @(AGTTrackingStatusLimitedExcessiveMotion): @"LimitedExcessiveMotion",
             @(AGTTrackingStatusLimitedInsufficientFeatures): @"LimitedInsufficientFeatures",
             @(AGTTrackingStatusLimitedRelocalizing): @"LimitedRelocalizing",
             @(AGTTrackingStatusNormal): @"Normal",
             @(AGTTrackingStatusNotAvailable): @"NotAvailable",
             @(AGTTrackingStatusPlaneDetected): @"PlaneDetected",
             @(AGTTrackingStatusTrackerDetected): @"TrackerDetected"
             };
}

@end
