//
//  ReactAugmentManager.h
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <AugmentPlayerSDK/AugmentPlayerSDK.h>
#import "AugmentReactPlayerView.h"

// Events names

static NSString* AUGMENT_EVENT_LOADING_PROGRESS = @"augmentEventLoadingProgress";
static NSString* AUGMENT_EVENT_LOADING_OVER     = @"augmentEventLoadingOver";

// Arguments keys

static NSString* ARG_APP_ID      = @"id";
static NSString* ARG_APP_KEY     = @"key";
static NSString* ARG_VUFORIA_KEY = @"vuforia";
static NSString* ARG_IDENTIFIER  = @"identifier";
static NSString* ARG_BRAND       = @"brand";
static NSString* ARG_NAME        = @"name";
static NSString* ARG_EAN         = @"ean";

// Results keys

static NSString* ARG_ERROR        = @"error";
static NSString* ARG_SUCCESS      = @"success";
static NSString* ARG_MODEL_NUMBER = @"model_number";

@interface ReactAugmentManager : RCTEventEmitter <RCTBridgeModule>

@property (class, readonly) AGTAugmentSDK* augmentSDK;;

@property (nonatomic, copy) RCTPromiseRejectBlock  startErrorPromise;
@property (nonatomic, copy) RCTPromiseResolveBlock startSuccessPromise;
@property (nonatomic, copy) RCTPromiseRejectBlock  productErrorPromise;
@property (nonatomic, copy) RCTPromiseResolveBlock productSuccessPromise;

- (void) init:(NSDictionary*) data;
- (void) isARKitAvailable:(RCTResponseSenderBlock) callback;
- (void) checkIfModelDoesExistForUserProduct: (NSDictionary*) product resolver: (RCTPromiseResolveBlock) resolver rejecter:(RCTPromiseRejectBlock) rejecter;
- (void) start: (RCTPromiseResolveBlock) resolver rejecter: (RCTPromiseRejectBlock) rejecter;
- (void) addProductToAugmentPlayer: (NSDictionary*) product resolver: (RCTPromiseResolveBlock) resolver rejecter:(RCTPromiseRejectBlock) rejecter;
- (void) recenterProducts: (RCTPromiseResolveBlock) resolver rejecter: (RCTPromiseRejectBlock) rejecter;

@end
