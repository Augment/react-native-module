//
//  AugmentPlayer.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "RNAugmentPlayer.h"
#import "RNAugmentPlayerSDK.h"
#import "RNAugmentReactConstants.h"
#import <AVKit/AVKit.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>

@interface RNAugmentPlayer () <AGTAugmentPlayerModelGestureDelegate, AGTTrackingStatusDelegate>
@property (nonatomic, weak) RCTBridge *bridge;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@property (retain, nonatomic) id<AGTAugmentPlayer> augmentPlayer;
@property (nonatomic, weak) AGTView *arView;
@end

@implementation RNAugmentPlayer

- (instancetype)initWithBridge:(RCTBridge *)bridge {
    if ((self = [super init])) {
        self.bridge = bridge;
        self.sessionQueue = dispatch_queue_create("sessionQueue", DISPATCH_QUEUE_SERIAL);
        self.augmentPlayer = [RNAugmentPlayerSDK.augmentSDK createAugmentPlayer];
        AGTView *arView = [AGTView new];
        arView.augmentPlayer = self.augmentPlayer;
        self.augmentPlayer.modelGestureDelegate = self;
        self.augmentPlayer.trackingStatusDelegate = self;
        self.arView = arView;
        [self addSubview:arView];
        [arView setTranslatesAutoresizingMaskIntoConstraints:false];
        NSDictionary* viewsDict = @{@"view": arView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:viewsDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:viewsDict]];
    }
    return self;
}

- (void) didMoveToSuperview {
    if (self.superview) {
        [self startSession];
    }
}

- (void)removeFromSuperview {
    _bridge = nil;
    _augmentPlayer = nil;
    [super removeFromSuperview];
}

- (void)startSession {
    dispatch_async(self.sessionQueue, ^{
        /**
         * We need to grant camera permission before starting AugmentPlayerSDK
         * otherwise we will have an error during initialization: "Cannot access the camera"
         * Also we must update our Info.plist to allow camera access on the App level, key: NSCameraUsageDescription
         */
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        NSString* errorMessage = @"Augment Player need access to your camera to work.\nGo to Setting and allow access for this App.";
        __weak typeof(self) weakSelf = self;
        if (authStatus == AVAuthorizationStatusAuthorized) {
            [weakSelf startPlayer];
        } else if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType: AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                if (granted) {
                    [self startPlayer];
                }
                else {
                    [weakSelf onInitializationError:nil];
                }
            }];
        } else {
            [weakSelf onInitializationError:nil];
        }
    });
}

- (void)startPlayer {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        [_augmentPlayer resume:&error];
        dispatch_async(self.sessionQueue, ^{
            if (error) {
                RCTLogError(@"An error occured while starting augmented reality: %@", error.localizedDescription);
                [weakSelf onInitializationError:nil];
            } else {
                [weakSelf onReady:nil];
            }
        });
    });
}

/**
 * This method corresponds to `AugmentReact.addProductToAugmentPlayer`
 * data is a Map object that represent a product
 * it has "identifier" "brand" "name" and "ean" keys
 * This method needs to be called after the success of `AugmentReact.start`
 */
- (void) addProduct:(NSDictionary*)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    [self getProduct:product resolver:resolver rejecter:rejecter];
}

/**
 * This method corresponds to `AugmentReact.recenterProducts`
 * This method needs to be called after the success of `AugmentReact.start`
 */
- (void) recenterProducts:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    [self.augmentPlayer recenterProducts];
    resolver(nil);
}

- (void) takeScreenshot:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    [self.augmentPlayer takeScreenshotWithCompletion:^(UIImage * _Nullable screenshotImage) {
        if (screenshotImage != NULL) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *fileName = [NSString stringWithFormat:@"%@%f.jpg", @"AGT_screenshot_", CFAbsoluteTimeGetCurrent()];
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent: fileName];
            NSData *photoData = UIImageJPEGRepresentation(screenshotImage, 1);
            NSError* error;
            if ([photoData writeToFile:filePath options:NSDataWritingAtomic error:&error]) {
                resolver(filePath);
            } else {
                rejecter(@"savingScreenshot", [error localizedFailureReason], error);
            }
        } else {
            rejecter(@"ReactAugmentManager", @"Error while taking screenshot", nil);
        }
    }];
}

#pragma mark - AR implementation

/**
 * It will get the product from Augment (or from the cache if available)
 */
- (void) getProduct:(NSDictionary*)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {

    [self onLoadingProgress: 0];

    // Check if the product is already in cache
    id<AGTProduct> cachedProduct = [RNAugmentPlayerSDK.augmentSDK.productsDataController productForIdentifier: product[@"identifier"]];
    if (cachedProduct != nil) {
        // Add the product to the AR view
        [self addToARView:cachedProduct resolver:resolver rejecter:rejecter];
    } else {
        // Query Augment Product Database
        [self queryAugmentDatabase:product resolver:resolver rejecter:rejecter];
    }
}

- (void) queryAugmentDatabase:(NSDictionary*)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    __weak typeof(self) weakSelf = self;
    [RNAugmentPlayerSDK.augmentSDK.productsDataController checkIfModelDoesExistForProductIdentifier: product[@"identifier"] brand: product[@"brand"] name: product[@"name"] EAN: product[@"ean"] completion: ^(id<AGTProduct> _Nullable augmentProduct, NSError* _Nullable error) {

        // Check if an error occured
        if (error != nil) {
            [weakSelf onLoadingOver];
            rejecter(@"ReactAugmentManager", error.localizedDescription, error);
            return;
        }

        // Check if the product is found
        if (augmentProduct != nil) {
            [weakSelf addToARView:augmentProduct resolver:resolver rejecter:rejecter];
        } else {
            [weakSelf onLoadingOver];
            rejecter(@"ReactAugmentManager", @"This product is not available yet", nil);
        }
    }];
}

/**
 * Add the Augment-product to the AR View
 * In this process the 3D model will be downloaded from the network
 * @param augmentProduct AGTProduct The Augment product from the API call
 */
- (void) addToARView:(id<AGTProduct>)augmentProduct resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter {
    __weak typeof(self) weakSelf = self;

    /**
     * This is used to throttle the number of event sent to React native otherwise it become overloaded
     */
    __block int lastProgress = 0;
    [RNAugmentPlayerSDK.augmentSDK addProduct:augmentProduct toAugmentPlayer:self.augmentPlayer progress:^(NSProgress* _Nonnull progress) {
        // Progress callback
        int newProgress = (int) round(progress.fractionCompleted * 100);
        if (newProgress <= lastProgress) return; // Throttling
        lastProgress = newProgress;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf onLoadingProgress:newProgress];
        });
    } completion:^(NSUUID* _Nullable itemIdentifier, NSArray<NSError*>* _Nullable errors) {
        // Check for errors
        if (errors != nil && errors.count > 0) {
            NSMutableString* errorString = [NSMutableString new];
            [errors enumerateObjectsUsingBlock: ^(NSError* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
                [errorString appendString: obj.localizedDescription];
                [errorString appendString: @" "];
            }];

            [weakSelf onLoadingOver];
            rejecter(@"ReactAugmentManager", errorString, nil);
            return;
        }

        // If everything is ok we start rendering the model
        if (itemIdentifier != nil) {
            [weakSelf onLoadingOver];
            resolver(nil);
        } else {
            [weakSelf onLoadingOver];
            rejecter(@"ReactAugmentManager", @"Impossible to show this product yet", nil);
        }
    }];
}

#pragma mark - Events

- (void)onReady:(NSDictionary *)event {
    if (_onPlayerReady) {
        _onPlayerReady(event);
    }
}

- (void)onInitializationError:(NSDictionary *)event {
    if (_onInitializationFailed) {
        _onInitializationFailed(event);
    }
}

- (void) onLoadingProgress: (int) progress {
    if (!self.onLoadingProgressDidChange) {
        return;
    }
    self.onLoadingProgressDidChange(@{@"progress": @(progress)});
}

- (void) onLoadingOver {
    if (!self.onLoadingDidFinish) {
        return;
    }
    self.onLoadingDidFinish(nil);
}

#pragma mark - AGTTrackingStatusDelegate

- (void)trackStatus:(AGTTrackingStatus)status withErrorMessage:(NSString * _Nullable)errorMessage {
    if (_onTrackingStatusChanged) {
        _onTrackingStatusChanged(@{
                                   @"status": @(status),
                                   @"message": (errorMessage ?: @"")
                                   });
    }
}

#pragma mark - AGTAugmentPlayerModelGestureDelegate

- (void)onModelAdded:(NSString * _Nonnull)model3DUuid {
    if (_onModelGesture) {
        _onModelGesture(@{
                          @"gesture": @(RNModelGestureEventAdded),
                          @"model_uuid": model3DUuid
                          });
    }
}

- (void)onModelRotated:(NSString * _Nonnull)model3DUuid {
    if (_onModelGesture) {
        _onModelGesture(@{
                          @"gesture": @(RNModelGestureEventRotated),
                          @"model_uuid": model3DUuid
                          });
    }
}

- (void)onModelTranslated:(NSString * _Nonnull)model3DUuid {
    if (_onModelGesture) {
        _onModelGesture(@{
                          @"gesture": @(RNModelGestureEventTranslated),
                          @"model_uuid": model3DUuid
                          });
    }
}

@end
