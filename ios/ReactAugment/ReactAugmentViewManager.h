//
//  ReactAugmentViewManager.h
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import "AugmentReactPlayerView.h"

@interface ReactAugmentViewManager : RCTViewManager <AugmentReactPlayerViewDelegate>
@property (nonatomic, copy) RCTPromiseRejectBlock  startErrorPromise;
@property (nonatomic, copy) RCTPromiseResolveBlock startSuccessPromise;
@property (nonatomic, copy) RCTPromiseRejectBlock  productErrorPromise;
@property (nonatomic, copy) RCTPromiseResolveBlock productSuccessPromise;

- (void) start: (RCTPromiseResolveBlock) resolver rejecter: (RCTPromiseRejectBlock) rejecter;
- (void) addProduct:(NSDictionary*)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
- (void) recenterProducts:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
- (void) takeScreenshot:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter;
@end
