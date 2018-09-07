//
//  AugmentReactPlayerView.h
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AugmentPlayerSDK/AugmentPlayerSDK.h>
#import <React/RCTView.h>
#import <React/RCTBridgeModule.h>

@class RNAugmentPlayer;

@interface RNAugmentPlayer : UIView
@property (nonatomic, copy) RCTBubblingEventBlock onPlayerReady;
@property (nonatomic, copy) RCTBubblingEventBlock onInitializationFailed;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadingProgressDidChange;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadingDidFinish;
@property (nonatomic, copy) RCTBubblingEventBlock onModelGesture;
@property (nonatomic, copy) RCTBubblingEventBlock onTrackingStatusChanged;

- (instancetype)initWithBridge:(RCTBridge *)bridge;
- (void) addProduct:(NSDictionary*)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
- (void) recenterProducts:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
- (void) takeScreenshot:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
@end
