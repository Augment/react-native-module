//
//  AugmentReactPlayerView.h
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AugmentPlayerSDK/AugmentPlayerSDK.h>

@class AugmentReactPlayerView;

/**
 * This is a Protocol for a static delegate that will be called when the view has been inserted in the hierarchy
 * We need that to know when the AGTView is available because we don't know when React will instanciate/add it
 */
@protocol AugmentReactPlayerViewDelegate <NSObject>

- (void) instantiationDone: (AugmentReactPlayerView*) augmentView;

@end

static id<AugmentReactPlayerViewDelegate> InstantiationDelegate;

@interface AugmentReactPlayerView : AGTView

+ (void) SetInstantiationDelegate: (id<AugmentReactPlayerViewDelegate>) delegate;

@end
