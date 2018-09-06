//
//  ReactAugmentViewManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentViewManager.h"
#import "ReactAugmentManager.h"
#import "AugmentReactConstants.h"

@import AugmentPlayerSDK;

@interface ReactAugmentViewManager ()
@property (nonatomic, retain) id<AGTAugmentPlayer> augmentPlayer;
@property (nonatomic, weak) AugmentReactPlayerView *containerView;
@end

@implementation ReactAugmentViewManager

RCT_EXPORT_MODULE(AugmentReactPlayerNative)

RCT_EXPORT_VIEW_PROPERTY(onPlayerReady, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingProgressDidChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingDidFinish, RCTBubblingEventBlock)

- (UIView*) view {
    AugmentReactPlayerView* view = [AugmentReactPlayerView new];
    _containerView = view;
    view.augmentReactPlayerViewDelegate = self;
    return view;
}

- (void)onInstantiationDone:(AugmentReactPlayerView *)augmentView {
    _augmentPlayer = [ReactAugmentManager.augmentSDK createAugmentPlayer];
    AGTView *arView = [AGTView new];
    augmentView.arView = arView;
    augmentView.arView.augmentPlayer = _augmentPlayer;
    NSError *error;
    [_augmentPlayer resume:&error];
    if (error) {
        RCTLogError(@"An error occured while starting augmented reality: %@", error.localizedDescription);
    }
    [self onPlayerReady:augmentView];
}

- (void)onPlayerReady:(AugmentReactPlayerView *)augmentView {
    if (!augmentView.onPlayerReady) {
        return;
    }
    augmentView.onPlayerReady(NULL);
}

/**
 * This method corresponds to `AugmentReact.start`
 * It is a little tricky as it register for a broadcast receiver that will be triggered by the AugmentReactPlayerView
 * It is to be able to execute the Javascript callback when the ARView is ready to get commands
 */
RCT_EXPORT_METHOD(start:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    self.startErrorPromise   = rejecter;
    self.startSuccessPromise = resolver;
}

/**
 * AugmentReactPlayerViewDelegate
 * This method is called when the Augment View has been added to the view hierarchy
 */
- (void) instantiationDone: (AugmentReactPlayerView*) augmentView {

    //#if AGT_AR_AVAILABLE
    //  self.augmentView.augmentPlayer = augmentSDK.augmentPlayer;
    //#endif

    [self startARSession];
}

/**
 * This method corresponds to `AugmentReact.addProductToAugmentPlayer`
 * data is a Map object that represent a product
 * it has "identifier" "brand" "name" and "ean" keys
 * This method needs to be called after the success of `AugmentReact.start`
 */
RCT_EXPORT_METHOD(addProduct:(NSDictionary *)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    //  if (self.augmentView == nil) {
    //      [self useRejecter:rejecter withErrorMessage:@"addProductToAugmentPlayer must be used after a success call to start()"];
    //      return;
    //  }

    // Because adding a product to the ARView is a multi step operation
    // We save the callbacks so we can access it latter when the operation
    // has succeeded or failed
    self.productErrorPromise   = rejecter;
    self.productSuccessPromise = resolver;

    [self getProduct: product];
}

/**
 * This method corresponds to `AugmentReact.recenterProducts`
 * This method needs to be called after the success of `AugmentReact.start`
 */
RCT_EXPORT_METHOD(recenterProducts:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    [_augmentPlayer recenterProducts];
}

RCT_EXPORT_METHOD(takeScreenshot:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    [_augmentPlayer takeScreenshotWithCompletion:^(UIImage * _Nullable screenshotImage) {
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
            [self useRejecter:rejecter withErrorMessage:@"Error while taking screenshot"];
        }
    }];
}


#pragma mark - AR implementation

- (void) startSuccess {
    if (self.startSuccessPromise) {
        self.startSuccessPromise([self getResultWithSuccess:nil]);
        self.startSuccessPromise = nil;
        self.startErrorPromise   = nil;
    }
}

- (void) startError: (NSString*) message {
    NSLog(@"Start Error: %@", message);
    if (self.startErrorPromise != nil) {
        [self useRejecter:self.startErrorPromise withErrorMessage:message];
        self.startErrorPromise   = nil;
        self.startSuccessPromise = nil;
    }
}

- (void) startARSession {

    /**
     * We need to grant camera permission before starting AugmentPlayerSDK
     * otherwise we will have an error during initialization: "Cannot access the camera"
     * Also we must update our Info.plist to allow camera access on the App level, key: NSCameraUsageDescription
     */
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
    NSString* errorMessage = @"Augment Player need access to your camera to work.\nGo to Setting and allow access for this App.";
    if (authStatus == AVAuthorizationStatusAuthorized) {
        [self startSuccess];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        __weak typeof(self) weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType: AVMediaTypeVideo completionHandler: ^(BOOL granted) {
            if (granted) {
                [weakSelf startSuccess];
            }
            else {
                [weakSelf startError: errorMessage];
            }
        }];
    }
    else {
        [self startError: errorMessage];
    }
}

- (void) productSuccess {
    if (self.productSuccessPromise != nil) {
        self.productSuccessPromise([self getResultWithSuccess: nil]);
        self.productSuccessPromise = nil;
        self.productErrorPromise   = nil;
    }
}

- (void) productError: (NSString*) message {
    NSLog(@"Product Error: %@", message);
    if (self.productErrorPromise != nil) {
        [self useRejecter:self.productErrorPromise withErrorMessage:message];
        self.productErrorPromise   = nil;
        self.productSuccessPromise = nil;
    }
}

/**
 * It will get the product from Augment (or from the cache if available)
 */
- (void) getProduct: (NSDictionary*) product {

    [self sendEventLoadingProgress: 0];

    // Check if the product is already in cache
    id<AGTProduct> cachedProduct = [ReactAugmentManager.augmentSDK.productsDataController productForIdentifier: product[@"identifier"]];
    if (cachedProduct != nil) {
        // Add the product to the AR view
        [self addToARView: cachedProduct];
    }
    else {
        // Query Augment Product Database
        [self queryAugmentDatabase: product];
    }
}

- (void) queryAugmentDatabase: (NSDictionary*) product {
    __weak typeof(self) weakSelf = self;
    [ReactAugmentManager.augmentSDK.productsDataController checkIfModelDoesExistForProductIdentifier: product[@"identifier"] brand: product[@"brand"] name: product[@"name"] EAN: product[@"ean"] completion: ^(id<AGTProduct> _Nullable augmentProduct, NSError* _Nullable error) {

        // Check if an error occured
        if (error != nil) {
            [weakSelf sendEventLoadingOver];
            [weakSelf productError: error.localizedDescription];
            return;
        }

        // Check if the product is found
        if (augmentProduct != nil) {
            [weakSelf addToARView: augmentProduct];
        }
        else {
            [weakSelf sendEventLoadingOver];
            [weakSelf productError: @"This product is not available yet"];
        }
    }];
}

/**
 * Add the Augment-product to the AR View
 * In this process the 3D model will be downloaded from the network
 * @param augmentProduct AGTProduct The Augment product from the API call
 */
- (void) addToARView: (id<AGTProduct>) augmentProduct {
    __weak typeof(self) weakSelf = self;
    /**
     * This is used to throttle the number of event sent to React native otherwise it become overloaded
     */
    __block int lastProgress = 0;
    [ReactAugmentManager.augmentSDK addProduct:augmentProduct toAugmentPlayer:_augmentPlayer progress:^(NSProgress* _Nonnull progress) {
        // Progress callback
        dispatch_async(dispatch_get_main_queue(), ^{
            int p = (int) round(progress.fractionCompleted * 100);
            if (p <= lastProgress) return; // Throttling
            lastProgress = p;
            [weakSelf sendEventLoadingProgress: p];
        });
    } completion:^(NSUUID* _Nullable itemIdentifier, NSArray<NSError*>* _Nullable errors) {
        // Check for errors
        if (errors != nil) {
            NSMutableString* errorString = [NSMutableString new];
            [errors enumerateObjectsUsingBlock: ^(NSError* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
                [errorString appendString: obj.localizedDescription];
                [errorString appendString: @" "];
            }];

            [weakSelf sendEventLoadingOver];
            [weakSelf productError: errorString];
            return;
        }

        // If everything is ok we start rendering the model
        if (itemIdentifier != nil) {

            //      [augmentSDK.augmentPlayer resume];

            [weakSelf sendEventLoadingOver];
            [weakSelf productSuccess];
        }
        else {
            [weakSelf sendEventLoadingOver];
            [weakSelf productError: @"Impossible to show this product yet"];
        }
    }];
}

#pragma mark - Events

- (void) sendEventLoadingProgress: (int) progress {
    if (!_containerView.onLoadingProgressDidChange) {
        return;
    }
    _containerView.onLoadingProgressDidChange(@{@"progress": @(progress)});
}

- (void) sendEventLoadingOver {
    if (!_containerView.onLoadingDidFinish) {
        return;
    }
    _containerView.onLoadingDidFinish(nil);
}

#pragma mark - Helpers

- (void) useRejecter: (RCTPromiseRejectBlock) rejecter withErrorMessage: (NSString*) message {
    NSError *error = [NSError errorWithDomain:@"ReactAugmentManager" code:1 userInfo: @{NSLocalizedDescriptionKey: message}];
    rejecter(@"ReactAugmentManager", message, error);
}

- (NSArray<NSDictionary*>*) getResultWithSuccess: (NSDictionary*) data {

    if (data == nil) {
        data = @{ARG_SUCCESS: @"ok"};
    }

    return @[data];
}
@end
