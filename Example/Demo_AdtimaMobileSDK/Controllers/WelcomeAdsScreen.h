//
//  WelcomeAdsScreen.h
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Khiem Nguyen on 12/13/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeAdsScreen : UIViewController
@property (nonatomic, strong) NSString *zoneId;
- (void)loadWelcomeAdAndShow:(void (^)(void))onShow
                     dismiss:(void (^)(void))onDismiss
                     fail:(void (^)(void))onFail;
- (void)showAd;
@end
