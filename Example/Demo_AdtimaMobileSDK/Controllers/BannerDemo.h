//
//  BannerDemo.h
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Nguyen Tuan Anh on 4/23/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZAD_AdtimaMobileSDK/Adtima.h>

@interface BannerDemo : UIViewController<ZAdsBannerDelegate>
{
    __weak IBOutlet UIButton *btnDismiss;
    __weak IBOutlet UIButton *btnResume;
    __weak IBOutlet UIButton *btnScrollView;
    __weak IBOutlet UIButton *btnTableView;
    __weak IBOutlet UIButton *btnRefresh;
    ZAdsBanner *banner;
    UIView *viewFullpage;
}
@property (nonatomic, strong) NSString *strType;
@property (nonatomic, strong) NSString *zoneId;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *viewContent;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bannerWidth;
- (IBAction)dismissBanner:(id)sender;
- (IBAction)resumeBanner:(id)sender;

@end
