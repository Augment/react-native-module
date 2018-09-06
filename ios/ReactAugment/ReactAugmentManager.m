//
//  ReactAugmentManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentManager.h"
#import "AugmentReactConstants.h"
#import "AugmentReactPlayerView.h"
#import <ARKit/ARKit.h>

@implementation ReactAugmentManager

static AGTAugmentSDK *augmentSDK;

RCT_EXPORT_MODULE(AugmentReact);

- (NSDictionary*) constantsToExport {
    return @{
             @"AUGMENT_EVENT_LOADING_PROGRESS": AUGMENT_EVENT_LOADING_PROGRESS,
             @"AUGMENT_EVENT_LOADING_OVER":     AUGMENT_EVENT_LOADING_OVER
             };
}

+ (AGTAugmentSDK*) augmentSDK {
    return augmentSDK;
}

/**
 * This method corresponds to `AugmentReact.init`
 * data is a Map object with "id" "key" "vuforia" keys
 */
RCT_EXPORT_METHOD(init: (NSDictionary*) data) {

  // Define a delegate for when a player will be instantiated
  // From that point we will start the AR session
  // @see AugmentReactPlayerView for more information
//  [AugmentReactPlayerView setInstantiationDelegate: self];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        augmentSDK = [[AGTAugmentSDK alloc] initWithClientID:data[ARG_APP_ID] clientSecret:data[ARG_APP_KEY]];
    });
}

/**
 * This method corresponds to `AugmentReact.checkIfModelDoesExistForUserProduct`
 * product is a Map object that represent a product
 * it has "identifier" "brand" "name" and "ean" keys
 * This method returns an augmentProduct through the React callback mechanism
 */
RCT_EXPORT_METHOD(checkIfModelDoesExistForUserProduct:(NSDictionary *)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  [ReactAugmentManager.augmentSDK.productsDataController checkIfModelDoesExistForProductIdentifier: product[ARG_IDENTIFIER] brand: product[ARG_BRAND] name: product[ARG_NAME] EAN: product[ARG_EAN] completion: ^(id<AGTProduct> _Nullable augmentProduct, NSError* _Nullable error) {

    if (error != nil) {
        [self useRejecter:rejecter withErrorMessage:error.localizedDescription];
        return;
    }

    if (augmentProduct != nil){
        resolver([self getDictionaryForProduct: augmentProduct]);
    }
  }];
}

RCT_EXPORT_METHOD(isARKitAvailable:(RCTResponseSenderBlock)callback) {
    BOOL isARKitAvailable = NO;
    if (@available(iOS 11.0, *)) {
        if ([ARWorldTrackingConfiguration isSupported]) {
            isARKitAvailable = YES;
        }
    }
    callback(@[[NSNull null], @(isARKitAvailable)]);
}

RCT_EXPORT_METHOD(registerView:(AugmentReactPlayerView*)callback) {

}

#pragma mark - Events

- (NSArray<NSString*>*) supportedEvents {
    return @[AUGMENT_EVENT_LOADING_OVER, AUGMENT_EVENT_LOADING_PROGRESS];
}

#pragma mark - Helpers

- (void) useRejecter: (RCTPromiseRejectBlock) rejecter withErrorMessage: (NSString*) message {
    NSError *error = [NSError errorWithDomain:@"ReactAugmentManager" code:1 userInfo: @{NSLocalizedDescriptionKey: message}];
    rejecter(@"ReactAugmentManager", message, error);
}

/**
 * Convert an AGTProduct object to a NSDictionary
 */
- (NSDictionary*) getDictionaryForProduct: (id<AGTProduct>) product {
  return @{
    ARG_IDENTIFIER: product.identifier,
    ARG_BRAND:      product.brand,
    ARG_NAME:       product.name,
    ARG_EAN:        product.ean ? : @""
  };
}

@end
