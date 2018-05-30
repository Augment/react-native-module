//
//  AugmentReactPlayerView.h
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AugmentPlayerSDK/AugmentPlayerSDK.h>
#import <React/RCTView.h>

@class AugmentReactPlayerView;

/**
 * This is a Protocol for a static delegate that will be called when the view has been inserted in the hierarchy
 * We need that to know when the AGTView is available because we don't know when React will instanciate/add it
 */
@protocol AugmentReactPlayerViewDelegate <NSObject>

- (void) onInstantiationDone: (AugmentReactPlayerView* _Nullable) augmentView;

@end

@interface AugmentReactPlayerView : AGTView

@property (nonatomic, copy) RCTDirectEventBlock onPlayerReady;
@property (nonatomic, weak) id<AugmentReactPlayerViewDelegate> augmentReactPlayerViewDelegate;

@end
