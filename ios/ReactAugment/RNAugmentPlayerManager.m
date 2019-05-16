//
//  ReactAugmentViewManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "RNAugmentPlayerManager.h"
#import "RNAugmentPlayer.h"
#import "RNAugmentReactConstants.h"
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>

@import AugmentPlayerSDK;

@implementation RNAugmentPlayerManager

RCT_EXPORT_MODULE(RNAugmentPlayer)

RCT_EXPORT_VIEW_PROPERTY(onPlayerReady, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onInitializationFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingProgressDidChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingDidFinish, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onModelGesture, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTrackingStatusChanged, RCTBubblingEventBlock)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (UIView*) view
{
    return [[RNAugmentPlayer alloc] initWithBridge:self.bridge];
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[
             @"onPlayerReady",
             @"onInitializationFailed",
             @"onLoadingProgressDidChange",
             @"onLoadingDidFinish",
             @"onModelGesture",
             @"onTrackingStatusChanged"
             ];
}

- (NSDictionary*) constantsToExport {
    return @{
         @"ModelGesture": @{
             @"added":      @(RNModelGestureEventAdded),
             @"translated": @(RNModelGestureEventTranslated),
             @"rotated":    @(RNModelGestureEventRotated)
         },
         @"TrackingStatus": @{
             @"error": @(AGTTrackingStatusError),
             @"featuresDetected": @(AGTTrackingStatusFeaturesDetected),
             @"initializing": @(AGTTrackingStatusInitializing),
             @"limitedExcessiveMotion": @(AGTTrackingStatusLimitedExcessiveMotion),
             @"limitedInsufficientFeatures": @(AGTTrackingStatusLimitedInsufficientFeatures),
             @"limitedRelocalizing": @(AGTTrackingStatusLimitedRelocalizing),
             @"normal": @(AGTTrackingStatusNormal),
             @"notAvailable": @(AGTTrackingStatusNotAvailable),
             @"planeDetected": @(AGTTrackingStatusPlaneDetected),
             @"trackerDetected": @(AGTTrackingStatusTrackerDetected)
         }
     };
}


RCT_REMAP_METHOD(addProduct,
                 product:(NSDictionary *)product
                 reactTag:(nonnull NSNumber *)reactTag
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNAugmentPlayer *> *viewRegistry) {
        RNAugmentPlayer *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RNAugmentPlayer class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting AugmentPlayer, got: %@", view);
        } else {
            [view addProduct:product resolver:resolve rejecter:reject];
        }
    }];
}

RCT_REMAP_METHOD(recenterProducts,
                 recenterProducts:(nonnull NSNumber *)reactTag
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNAugmentPlayer *> *viewRegistry) {
        RNAugmentPlayer *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RNAugmentPlayer class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting AugmentPlayer, got: %@", view);
        } else {
            [view recenterProducts:resolve rejecter:reject];
        }
    }];
}


RCT_REMAP_METHOD(takeScreenshot,
                 takeScreenshot:(nonnull NSNumber *)reactTag
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNAugmentPlayer *> *viewRegistry) {
        RNAugmentPlayer *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RNAugmentPlayer class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting AugmentPlayer, got: %@", view);
        } else {
            [view takeScreenshot:resolve rejecter:reject];
        }
    }];
}

@end
