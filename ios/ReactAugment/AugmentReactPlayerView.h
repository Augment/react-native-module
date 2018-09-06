//
//  AugmentReactPlayerView.h
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AugmentPlayerSDK/AugmentPlayerSDK.h>
#import <React/RCTView.h>
#import <React/RCTBridgeModule.h>
#import "ReactAugmentManager.h"

@class AugmentReactPlayerView;

/**
 * This is a Protocol for a static delegate that will be called when the view has been inserted in the hierarchy
 * We need that to know when the AGTView is available because we don't know when React will instanciate/add it
 */
@protocol AugmentReactPlayerViewDelegate <NSObject>

- (void) onInstantiationDone: (AugmentReactPlayerView* _Nullable) augmentView;

@end

@interface AugmentReactPlayerView : UIView
@property (nonatomic, copy) RCTPromiseRejectBlock  startErrorPromise;
@property (nonatomic, copy) RCTPromiseResolveBlock startSuccessPromise;
@property (nonatomic, copy) RCTPromiseRejectBlock  productErrorPromise;
@property (nonatomic, copy) RCTPromiseResolveBlock productSuccessPromise;

@property (nonatomic, weak) ReactAugmentManager *manager;
@property (nonatomic, weak) AGTView *arView;
@property (nonatomic, copy) RCTDirectEventBlock onPlayerReady;
@property (nonatomic, weak) id<AugmentReactPlayerViewDelegate> augmentReactPlayerViewDelegate;

@property (nonatomic, copy) RCTBubblingEventBlock onLoadingProgressDidChange;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadingDidFinish;

- (void) start: (RCTPromiseResolveBlock) resolver rejecter: (RCTPromiseRejectBlock) rejecter;
- (void) addProduct:(NSDictionary*)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
- (void) recenterProducts:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
- (void) takeScreenshot:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
@end
