//
//  ReactAugmentManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentManager.h"

@implementation ReactAugmentManager

RCT_EXPORT_MODULE(AugmentReact);

- (NSDictionary*) constantsToExport {
  return @{
    @"AUGMENT_EVENT_LOADING_PROGRESS": AUGMENT_EVENT_LOADING_PROGRESS,
    @"AUGMENT_EVENT_LOADING_OVER":     AUGMENT_EVENT_LOADING_OVER
  };
}

/**
 * This method corresponds to `AugmentReact.init`
 * data is a Map object with "id" "key" "vuforia" keys
 */
RCT_EXPORT_METHOD(init: (NSDictionary*) data) {

  // Define a delegate for when a player will be instantiated
  // From that point we will start the AR session
  // @see AugmentReactPlayerView for more information
  [AugmentReactPlayerView SetInstantiationDelegate: self];

  [AGTAugmentSDK setSharedClientID: data[ARG_APP_ID]
                sharedClientSecret: data[ARG_APP_KEY]
                  sharedVuforiaKey: data[ARG_VUFORIA_KEY]
  ];
  self.augmentSDK = [AGTAugmentSDK new];
}

/**
 * This method corresponds to `AugmentReact.checkIfModelDoesExistForUserProduct`
 * product is a Map object that represent a product
 * it has "identifier" "brand" "name" and "ean" keys
 * This method returns an augmentProduct through the React callback mechanism
 */
RCT_EXPORT_METHOD(checkIfModelDoesExistForUserProduct:(NSDictionary *)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  [self.augmentSDK.productsDataController checkIfModelDoesExistForProductIdentifier: product[ARG_IDENTIFIER] brand: product[ARG_BRAND] name: product[ARG_NAME] EAN: product[ARG_EAN] completion: ^(AGTProduct* _Nullable augmentProduct, NSError* _Nullable error) {

    if (error != nil) {
        [self useRejecter:rejecter withErrorMessage:error.localizedDescription];
        return;
    }

    if (augmentProduct != nil){
        resolver(@[[self getDictionaryForProduct: augmentProduct]]);
    }
  }];
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

RCT_EXPORT_METHOD(pause) {
    NSLog(@"calling pause");
    [self.augmentSDK.augmentPlayer pause];
    NSLog(@"ending pause!");
}

/**
 * AugmentReactPlayerViewDelegate
 * This method is called when the Augment View has been added to the view hierarchy
 */
- (void) instantiationDone: (AugmentReactPlayerView*) augmentView {
  self.augmentView = augmentView;

#if AGT_AR_AVAILABLE
  self.augmentView.augmentPlayer = self.augmentSDK.augmentPlayer;
#endif

  [self startARSession];
}

/**
 * This method corresponds to `AugmentReact.addProductToAugmentPlayer`
 * data is a Map object that represent a product
 * it has "identifier" "brand" "name" and "ean" keys
 * This method needs to be called after the success of `AugmentReact.start`
 */
RCT_EXPORT_METHOD(addProductToAugmentPlayer:(NSDictionary *)product resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  if (self.augmentView == nil) {
      [self useRejecter:rejecter withErrorMessage:@"addProductToAugmentPlayer must be used after a success call to start()"];
      return;
  }

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
  if (self.augmentView == nil) {
      [self useRejecter:rejecter withErrorMessage:@"recenterProducts must be used after a success call to start()"];
      return;
  }
    [self.augmentSDK.augmentPlayer recenterProducts];
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
    __weak ReactAugmentManager* weakSelf = self;
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

// TODO PAUSE !!! [self.augmentSDK.augmentPlayer pause];

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
  AGTProduct* cachedProduct = [self.augmentSDK.productsDataController productForIdentifier: product[@"identifier"]];
  if (cachedProduct != nil) {

    // No product found in Augment Product Database
    if (cachedProduct == AGTProduct.unfoundProduct) {
      [self sendEventLoadingOver];
      [self productError: @"This product is not available yet"];
      return;
    }

    // Add the product to the AR view
    [self addToARView: cachedProduct];
  }
  else {
    // Query Augment Product Database
    [self queryAugmentDatabase: product];
  }
}

- (void) queryAugmentDatabase: (NSDictionary*) product {
  __weak ReactAugmentManager* weakSelf = self;
  [self.augmentSDK.productsDataController checkIfModelDoesExistForProductIdentifier: product[@"identifier"] brand: product[@"brand"] name: product[@"name"] EAN: product[@"ean"] completion: ^(AGTProduct* _Nullable augmentProduct, NSError* _Nullable error) {

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
 * This is used to throttle the number of event sent to React native otherwise it become overloaded
 */
int lastProgress = 0;

/**
 * Add the Augment-product to the AR View
 * In this process the 3D model will be downloaded from the network
 * @param augmentProduct AGTProduct The Augment product from the API call
 */
- (void) addToARView: (AGTProduct*) augmentProduct {
  __weak ReactAugmentManager* weakSelf = self;

  [self.augmentSDK addProductToAugmentPlayer: augmentProduct downloadProgress:^(NSProgress* _Nonnull progress) {
    // Progress callback
    dispatch_async(dispatch_get_main_queue(), ^{
      int p = (int) round(progress.fractionCompleted * 100);
      if (p <= lastProgress) return; // Throttling
      lastProgress = p;
      [weakSelf sendEventLoadingProgress: p];
    });
  } operationCompletionWithModelIdentifier:^(NSUUID* _Nullable itemIdentifier, NSArray<NSError*>* _Nullable errors) {
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

      [weakSelf.augmentSDK.augmentPlayer resume];

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

- (NSArray<NSString*>*) supportedEvents {
  return @[AUGMENT_EVENT_LOADING_OVER, AUGMENT_EVENT_LOADING_PROGRESS];
}

- (void) sendEventLoadingProgress: (int) progress {
  [self sendEventWithName:AUGMENT_EVENT_LOADING_PROGRESS body:@{@"progress": @(progress)}];
}

- (void) sendEventLoadingOver {
  [self sendEventWithName:AUGMENT_EVENT_LOADING_OVER body:nil];
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

/**
 * Convert an AGTProduct object to a NSDictionary
 */
- (NSDictionary*) getDictionaryForProduct: (AGTProduct*) product {
  return @{
    ARG_IDENTIFIER: product.identifier,
    ARG_BRAND:      product.brand,
    ARG_NAME:       product.name,
    ARG_EAN:        product.ean ? : @""
  };
}

@end
