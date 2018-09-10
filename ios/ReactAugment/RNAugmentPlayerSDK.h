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

@interface RNAugmentPlayerSDK : RCTEventEmitter <RCTBridgeModule>
@property (class, readonly) AGTAugmentSDK* augmentSDK;

- (void) init:(NSDictionary*) data;
- (void) isARKitAvailable:(RCTResponseSenderBlock) callback;
- (void) checkIfModelDoesExistForUserProduct: (NSDictionary*) product resolver: (RCTPromiseResolveBlock) resolver rejecter:(RCTPromiseRejectBlock) rejecter;
@end
