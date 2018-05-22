//
//  ReactAugmentViewManager.m
//
//  Copyright © 2017 - Present Augment. All rights reserved.
//

#import "ReactAugmentViewManager.h"
#import "ReactAugmentManager.h"

@implementation ReactAugmentViewManager

RCT_EXPORT_MODULE(AugmentReactPlayerNative)

- (UIView*) view {
    NSLog(@"GET newVIew");
    AugmentReactPlayerView* view = [AugmentReactPlayerView new];
    view.augmentReactPlayerViewDelegate = self;
    return view;
}

- (void)onInstantiationDone:(AugmentReactPlayerView *)augmentView {
    NSLog(@"instat DONE");
    if (augmentView == NULL) {
//      [self.augmentSDK.augmentPlayer pause];
        NSLog(@"instat DONE Pausing");
      return;
    }

//    [AGTAugmentSDK setSharedClientID: @"357fee36746668573ceb2f5957c4869ee1a62a112639bac9b0fae43c7c431692"
//                  sharedClientSecret: @"80ae1420e164e0440d5329067bcdd953e9fa6c63b75c001c06d169a4f11268c5"
//                    sharedVuforiaKey: @"ATQqCM7/////AAAAGXLs+GRi0UwXh0X+/qQL49dbZGym8kKo+iRtgC95tbJoCWjXXZihDl5pzxoca2JxLcYxBJ2pIeIE4dNcK0etMeb1746L7lq6vSFen43cS7P1P/HXjwHtUouV5Xus2U0F7WHUTKuO629jKFO13fBQczuY52UJcSEhsu9jHPMaupo5CpqQT3TFTQjlhzHhVXiVMEqq7RI+Edwh8TCSfGAbNRdbIELTfK+8YDYqwEHDbp62mFrs68YnCEQZDrpcLyC8WzFCVZtnUq3Cj3YBUfQ6gNnENYiuLf06gAAF/FcaF65VYveGRBbp3hpkqolX28bxPiUYNVknCSFXICPHciVntxF+rcHW5rrX7Cg/IVFGdNRF"
//     ];
//    augmentSDK = [AGTAugmentSDK new];

//    augmentView.augmentPlayer = self.augmentSDK.augmentPlayer;
    augmentView.augmentPlayer = ReactAugmentManager.augmentSDK.augmentPlayer;
    [augmentView.augmentPlayer resume];
    NSLog(@"instat DONE - exit");
}

@end
