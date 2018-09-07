//
//  AugmentReactConstants.h
//  ReactAugment
//
//  Created by Stephane Garagnani on 06/09/2018.
//  Copyright © 2018 Augment. All rights reserved.
//

#import <Foundation/Foundation.h>

// Credentials dictionary keys

extern NSString* const kRNAppID;
extern NSString* const kRNAppKey;

// Product dictionary keys

extern NSString* const kRNProductIdentifierKey;
extern NSString* const kRNProductBrandKey;
extern NSString* const kRNProductNameKey;
extern NSString* const kRNProductEANKey;

// Model gesture names

typedef NS_ENUM(NSInteger, RNModelGestureEvent) {
    RNModelGestureEventAdded = 1,
    RNModelGestureEventTranslated = 2,
    RNModelGestureEventRotated = 3
};

