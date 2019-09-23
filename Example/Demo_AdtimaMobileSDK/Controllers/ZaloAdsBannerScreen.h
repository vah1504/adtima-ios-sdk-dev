//
//  ZaloAdsBannerScreen.h
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 8/27/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KIND_AD_BANNER 1
#define KIND_AD_NATIVE 2

NS_ASSUME_NONNULL_BEGIN

@interface ZaloAdsBannerScreen : UIViewController
@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic) NSInteger kindAd;
@end

NS_ASSUME_NONNULL_END
