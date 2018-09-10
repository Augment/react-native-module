//
//  ReactAugmentManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "RNAugmentPlayerSDK.h"
#import "RNAugmentPlayer.h"
#import "RNAugmentReactConstants.h"
#import <ARKit/ARKit.h>

@implementation RNAugmentPlayerSDK

static AGTAugmentSDK *augmentSDK;

RCT_EXPORT_MODULE(RNAugmentPlayerSDK);

- (NSDictionary*) constantsToExport {
    return @{
             @"AppID":      kRNAppID,
             @"AppKey":     kRNAppKey,
             @"Identifier": kRNProductIdentifierKey,
             @"Brand":      kRNProductBrandKey,
             @"Name":       kRNProductNameKey,
             @"EAN":        kRNProductEANKey
             };
}

- (NSArray<NSString *> *)supportedEvents {
    return @[];
}

+ (AGTAugmentSDK*) augmentSDK {
    return augmentSDK;
}

+ (BOOL)requiresMainQueueSetup { return YES; }

/**
 * This method corresponds to `AugmentReact.init`
 * data is a Map object with "id" "key" "vuforia" keys
 */
RCT_EXPORT_METHOD(init: (NSDictionary*) data) {

    // Define a delegate for when a player will be instantiated
    // From that point we will start the AR session
    // @see AugmentPlayer for more information
    //  [AugmentPlayer setInstantiationDelegate: self];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        augmentSDK = [[AGTAugmentSDK alloc] initWithClientID:data[kRNAppID] clientSecret:data[kRNAppKey]];
    });
}

/**
 * This method corresponds to `AugmentReact.checkIfModelDoesExistForUserProduct`
 * product is a Map object that represent a product
 * it has "identifier" "brand" "name" and "ean" keys
 * This method returns an augmentProduct through the React callback mechanism
 */
RCT_EXPORT_METHOD(checkIfModelDoesExistForUserProduct:(NSDictionary *)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    [RNAugmentPlayerSDK.augmentSDK.productsDataController checkIfModelDoesExistForProductIdentifier: product[kRNProductIdentifierKey] brand: product[kRNProductBrandKey] name: product[kRNProductNameKey] EAN: product[kRNProductEANKey] completion: ^(id<AGTProduct> _Nullable augmentProduct, NSError* _Nullable error) {

        if (error != nil) {
            rejecter(@"ReactAugmentManager", error.localizedDescription, error);
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

#pragma mark - Helpers

/**
 * Convert an AGTProduct object to a NSDictionary
 */
- (NSDictionary*) getDictionaryForProduct: (id<AGTProduct>) product {
    return @{
             kRNProductIdentifierKey: product.identifier,
             kRNProductBrandKey:      product.brand,
             kRNProductNameKey:       product.name,
             kRNProductEANKey:        product.ean ? : @""
             };
}

@end
