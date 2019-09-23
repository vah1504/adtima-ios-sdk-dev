//
//  BannerDemo.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Nguyen Tuan Anh on 4/23/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import "BannerDemo.h"
#import "Toast+UIView.h"
#import "SVProgressHUD.h"
#include "TargetConditionals.h"

#define IOS_VERSION_LOWER_THAN_8 (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
#define paddingTop 64
#import "Masonry.h"
//NSString const *kFbTestDevice = @"1866550d9b5317763b632e66d111d626cfc64e50";
//NSString *kFbTestDevice = @"c4c3793768427083d6dae1928f8a9cf0d1739450";
//NSString *kFbTestDevice = @"9e60fa5da0d425b996204faa69a7d75be6bd883d";
//NSString *kFbTestDevice = @"25b973430728d44da69b3d97d272e655830d70f4"; //iphone 8plus
//NSString const *kFbTestDevice = @"f4858bff2c854edbac9026e2b0da8a1d5c68f52d"; // simulator iPhone XR
NSString const *kFbTestDevice = @"";
@implementation BannerDemo{
    NSTimer *timer;
    CGFloat duration;
    UIView *viewContaintBanner;
}
@synthesize strType;
@synthesize btnClose;

- (void)appWillBecomeActive:(NSNotificationCenter *)notification{
    if (banner) {
        [banner bannerViewWillAppear];
    }
}

- (void)appWillEnterBackground:(NSNotificationCenter *)notification{
    if (banner) {
        [banner bannerViewWillDisAppear];
    }
}

- (void)loadNewBanner{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.viewContent.backgroundColor = [UIColor grayColor];
        //Update UI
        [[ZAdsTracking sharedInstance] haveAdsInventoryForZoneId:_zoneId];
        if (banner) {
            [banner dismiss];
            banner = nil;
        }
        
        banner = [[ZAdsBanner alloc] init];
        banner.parentView = self;
        
        if ([strType integerValue] == 1) {
            [banner addAdsFacebookDevice:kFbTestDevice.copy];
            [banner loadBannerWithYOrigin:self.view.frame.size.height - 50];
            [banner setSize:STANDARD_BANNER];
            [banner setZoneId:self.zoneId];
            [banner setAdsTag:@"111"];
            self.title = @"Banner Standard 320x50";
        } else if ([strType integerValue] == 2) {
            [banner addAdsFacebookDevice:kFbTestDevice.copy];
            [banner loadBannerWithYOrigin:self.view.frame.size.height - (self.view.frame.size.width*250/300) - 100];
            [banner setSize:MEDIUM_RECTANGLE];
            [banner setZoneId:self.zoneId];
            [banner setAdsBorderEnable:YES];
            self.title = @"Banner Medium 300x250";
        } else if ([strType integerValue] == 3) {
            [banner setAdsBorderEnable:YES];
            [banner addAdsTargeting:@"mp3" value:@"vitoiconsong"];
            [banner addAdsFacebookDevice:kFbTestDevice.copy];
            [banner loadBannerWithYOrigin:50];
            [banner setZoneId:self.zoneId];
            [banner setSize:FULL_PAGE];
            self.bannerWidth.constant = self.view.bounds.size.width;
            self.title = @"Banner Fullpage 720x1280";
        } else if ([strType integerValue] == 5){
            [banner addAdsFacebookDevice:kFbTestDevice.copy];
            [banner loadBannerWithYOrigin:self.view.frame.size.height - (self.view.frame.size.width*900/1600) - 100];
            [banner setSize:R169_RECTANGLE];
            [banner setZoneId:self.zoneId];
            [banner setAdsBorderEnable:YES];
            self.title = @"Banner Medium R169";
        }
        else{
            [banner addAdsFacebookDevice:kFbTestDevice.copy];
            [banner loadBannerWithYOrigin:self.view.frame.size.height - (self.view.frame.size.width*100/300)];
            [banner setSize:R31_RECTANGLE];
            [banner setZoneId:self.zoneId];
            [banner setAdsBorderEnable:YES];
            [banner setAdsBorderEnable:YES];
            self.title = @"Banner Medium 300x100";
        }
        if ([strType integerValue] == 1) {
            btnScrollView.hidden = NO;
            btnTableView.hidden = NO;
        } else {
            btnScrollView.hidden = YES;
            btnTableView.hidden = YES;
        }
        
        [banner setAdsAutoRefresh:NO];
        [banner setAdsVideoAutoPlayPrefer:NO];
        [banner setAdsVideoSoundOnPrefer:NO];
        [banner setAdsAudioAutoPlayPrefer:YES];
        
        [banner addAdsTargeting:@"category_id" value:@"11111"];
        [banner addAdsTargeting:@"category_name" value:@"News Category"];
        [banner addAdsTargeting:@"song_id" value:@"22222"];
        [banner addAdsTargeting:@"song_name" value:@"Song Name"];
        [banner addAdsTargeting:@"album_id" value:@"33333"];
        [banner addAdsTargeting:@"album_name" value:@"Album Name"];
        
        [banner addAdsTargeting:@"artist_id" value:@"44444"];
        [banner addAdsTargeting:@"artist_name" value:@"Artist Name"];
        
        [banner setAdsContentUrl:@"http://www.baomoi.com/nhung-pha-xu-ly-an-tuong-cua-ronaldo-nam-2016/r/21129105.epi"];
        [banner addAdsFacebookDevice:kFbTestDevice];
        
        [banner setDelegate:self];
        banner.parentView = self;
        [banner setContentId:@"http://adtima.vn"];
        NSLog(@"[bannerdemo]start load banner");
        
        if (!banner.superview ||
            banner.superview == nil) {
            if (banner.getSize == FULL_PAGE) {
                [self.viewContent addSubview:banner];
            } else {
                viewContaintBanner = [[UIView alloc] init];
                viewContaintBanner.backgroundColor = UIColor.yellowColor;
                CGFloat originX = (self.view.bounds.size.width - 300)/2;
                if (banner.getSize == MEDIUM_RECTANGLE) {
                    viewContaintBanner.frame = CGRectMake(originX, 150, 300, 250);
                } else if (banner.getSize == R169_RECTANGLE){
                    viewContaintBanner.frame = CGRectMake(originX, 150, 320, 180);
                }
                [self.viewContent addSubview:viewContaintBanner];
                viewContaintBanner.clipsToBounds = YES;
                [viewContaintBanner mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.viewContent.mas_centerX);
                    make.width.equalTo(@(viewContaintBanner.bounds.size.width));
                    make.height.equalTo(@(viewContaintBanner.bounds.size.height));
                    make.top.equalTo(self.viewContent.mas_top).offset(100);
                }];
                
                UILabel *lbInfo = [[UILabel alloc] init];
                lbInfo.text = @"View Container Ads";
                lbInfo.font = [UIFont boldSystemFontOfSize:16];
                lbInfo.textColor = UIColor.darkTextColor;
                [viewContaintBanner addSubview:lbInfo];
                [lbInfo mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(viewContaintBanner);
                }];
                
                [viewContaintBanner addSubview:banner];
                [banner mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.equalTo(viewContaintBanner);
                }];
            }
        }
        
        [banner loadAdsBanner];
        [self showLoading];
        [self startTimer];
    });
}

- (BOOL) isiPhoneXFamily{
    BOOL result = NO;
    @try {
        if (@available(iOS 11.0, *)) {
            result = [UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20;
        }
    } @catch (NSException *exception) {
        
    }
    return result;
}

- (void)viewDidLoad {
    self.viewContent.frame = self.scrollView.bounds;
#if TARGET_OS_SIMULATOR
//    [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //================================================================================
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self hiddenButton:YES];
    [super viewDidLoad];
    
//    [self.viewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
//        do {
//            if (@available(iOS 11.0, *)) {
//                if ([self isiPhoneXFamily]) {
//                    make.top.equalTo(self.scrollView.mas_safeAreaLayoutGuideTop);
//                    make.bottom.equalTo(self.scrollView.mas_safeAreaLayoutGuideBottom);
//                    break;
//                }
//            }
//            make.top.equalTo(self.scrollView.mas_top);
//            make.bottom.equalTo(self.scrollView.mas_bottom);
//        } while (false);
//        make.left.equalTo(self.scrollView.mas_left);
//        make.right.equalTo(self.scrollView.mas_right);
//    }];
    
    [self loadNewBanner];
    if (self.navigationController == nil) {
        [self addButtonClose];
    }
}

- (void)viewWillLayoutSubviews {
    //    if ([strType integerValue] == 1) {
    //        [banner loadBannerWithYOrigin:self.view.frame.size.height - 50];
    //    } else if ([strType integerValue] == 2) {
    //        [banner loadBannerWithYOrigin:self.view.frame.size.height - (self.view.frame.size.width*250/300)];
    //    } else {
    //        if ([self getScreenOrientation] == 1) {
    //            viewFullpage.frame = CGRectMake(0, paddingTop, self.view.frame.size.width, self.view.frame.size.height - paddingTop );
    //        } else {
    //            if (IOS_VERSION_LOWER_THAN_8) {
    //                viewFullpage.frame = CGRectMake(0, 82, self.view.frame.size.width, self.view.frame.size.height - 82);
    //
    //            } else {
    //                viewFullpage.frame = CGRectMake(0, 62, self.view.frame.size.width, self.view.frame.size.height - 62);
    //            }
    //        }
    //        [banner loadBannerWithYOrigin:0];
    //    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height * 2);
}

//======================================================

- (void)viewWillAppear:(BOOL)animated {
    //================================================================================
    [super viewWillAppear:animated];
    if (banner){
        [banner bannerViewWillAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self loadNewBanner];
}

- (void)viewWillDisappear:(BOOL)animated {    
    //================================================================================
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        NSLog(@"View controller was popped");
        
        if (banner) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [banner removeFromSuperview];
            [banner dismiss];
            banner = nil;
            [viewContaintBanner removeFromSuperview];
            viewContaintBanner = nil;
        }
    }
    else
    {
        NSLog(@"New view controller was pushed");
        if (banner){
            [banner bannerViewWillDisAppear];
        }
    }
}

- (void)showLoading{
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:@"Loading"];
    }
}

- (void)hideLoading{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (void)startTimer{
    [self stopTimer];
    if ([NSThread isMainThread]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(countTimer) userInfo:nil repeats:NO];
    } else {
        [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:NO];
    }
}

- (void)countTimer{
    if (!banner.isBannerAdsLoaded) {
        [self stopTimer];
        [self hideLoading];
    }
}

- (void)stopTimer{
    if (duration != 0) {
        [self.view makeToast:[NSString stringWithFormat:@"Time load banner: %.2f",duration]];
    }
    duration = 0;
    [timer invalidate];
    timer = nil;
}

- (IBAction)onPressedBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Orientation handling

- (BOOL)shouldAutorotate
{
    NSArray *supportedOrientationsInPlist = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    BOOL isPortraitLeftSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortrait"];
    BOOL isPortraitRightSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortraitUpsideDown"];
    return isPortraitLeftSupported && isPortraitRightSupported;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return UIInterfaceOrientationIsPortrait(currentInterfaceOrientation) ? currentInterfaceOrientation : UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

#pragma mark Delegate Banner
//================Delegate Banner======================

- (void)onBannerAdsLoadFinished:(NSString *)tag kind:(NSString *)type{
    //NSLog(@"onBannerAdsLoadFinished - type = %@",type);
    [self hideLoading];
    [self stopTimer];
    if ([tag isEqualToString:banner.adsTag]) {
        if (banner.isBannerAdsLoaded) {
            [banner show];
        }
    }
    //NSLog(@"%@", [banner getZoneID]);
    [self.view makeToast:[NSString stringWithFormat:@"ad loaded finished size:%@", NSStringFromCGSize(banner.bounds.size)]];
}

- (void)onBannerAdsLoadFailed:(NSString *)tag error:(NSInteger)errorCode {
    NSString *strError = [NSString stringWithFormat:@"[bannerdemo]ad load failed with errorCode = %zi", errorCode];
    NSLog(@"[bannerdemo]%@",strError);
//    [self.view makeToast:strError];
    [self hideLoading];
    [self stopTimer];
    if ([strType integerValue] == 3) {
        [self.viewContent bringSubviewToFront:btnRefresh];
    }
    [self.view makeToast:strError];
}

- (void)onBannerAdsOpened:(NSString *)tag {
    NSLog(@"onBannerAdsOpened");
}

- (void)onBannerAdsClosed:(NSString *)tag {
    NSLog(@"onBannerAdsClosed");
}

- (void)onBannerAdsInteracted:(NSString *)tag {
    NSLog(@"onBannerAdsInteracted");
}

- (void)onBannerAdsClicked:(NSString *)tag{
    NSLog(@"onBannerAdsClicked");
    if (banner) {
//        [banner dismiss];
//        [self closeInterstitial];
    }
}

- (void)onBannerClickPlayVideo:(NSString *)tag {
    //NSLog(@"VIDEO : onBannerClickPlayVideo");
}

- (void)onBannerFinishPlayVideo:(NSString *)tag {
    //NSLog(@"VIDEO : onBannerFinishPlayVideo");
}

- (void)onBannerPauseVideo:(NSString *)tag {
    //NSLog(@"VIDEO : onBannerPauseVideo");
}

- (void)onBannerMuteVideo:(NSString *)tag sound:(BOOL)isMute {
    if (isMute) {
        NSLog(@"isMute: YES");
    } else{
        NSLog(@"isMute: NO");
    }
}

- (void)onBannerAdsAudioStage:(ZAdsAudioStage)stage{
    NSLog(@"onbanner Ads Audio Stage: %d",stage);
    switch (stage) {
        case AUDIO_SKIPPED:
            if (banner) {
                [banner removeFromSuperview];
                [banner dismiss];
                banner = nil;
            }
            break;
            
        default:
            break;
    }
}

// default return NO
//- (BOOL)onBannerAdsContentHandler:(NSString *)tag content:(NSString *)content{
//    //NSLog(@"%@", content);
//    return TRUE;
//}
//======================================================

- (BOOL)isiPhoneX{
    BOOL result = NO;
    @try{
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            
            switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                case 2436:
                    result = YES;
                    break;
                default:
                    result = NO;
            }
        }
    }@catch(...){
        
    }
    return result;
}

- (void)addButtonClose {
    if (btnClose) {
        [btnClose removeFromSuperview];
        btnClose = nil;
    }
    btnClose = [[UIButton alloc] init];
    btnClose.frame = CGRectMake(0, 0, 100, 100);
    [btnClose addTarget:self action:@selector(closeFullpage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    CGFloat top = 0.f;
    CGFloat left = 0.f;
    
    if ([self isiPhoneX]) {
        top = 15.f;
        left = 15.f;
    }
    
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(top);
        make.left.equalTo(self.view.mas_left).offset(left);
        make.width.and.height.equalTo(@100);
    }];
    
    UILabel *lbText = [[UILabel alloc] init];
    lbText.text = @"Close";
    [self.view addSubview:lbText];
    [lbText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btnClose.mas_centerX);
        make.centerY.equalTo(btnClose.mas_centerY);
        make.width.and.height.equalTo(@100);
    }];
}

- (void)closeFullpage{
    [self.view removeFromSuperview];
}

- (void)closeInterstitial {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)hiddenButton:(BOOL)isHidden {
    btnDismiss.hidden = isHidden;
    btnResume.hidden = !isHidden;
}

- (IBAction)dismissBanner:(id)sender {
    [self stopTimer];
    
    [banner dismiss];
    banner = nil;
    [viewContaintBanner removeFromSuperview];
    viewContaintBanner = nil;
}

- (IBAction)resumeBanner:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update UI
        [banner loadAdsBanner];
        [self showLoading];
        [self startTimer];
    });
}

- (IBAction)refreshBanner:(id)sender{
    if (banner != nil) {
        [banner setZoneId:self.zoneId];
        [banner refreshAds];
        [self showLoading];
        [self startTimer];
    } else {
        [self loadNewBanner];
        [self showLoading];
    }
}

- (IBAction)onFeedbackAds:(id)sender{
    if (banner) {
        [banner feedbackAds:@[@1,@2]];
    }
}

//- (void)sendFeedbackAds:(NSArray<NSNumber *> *)feedBackIds{
//    if (banner) {
//        [banner feedbackAds:feedBackIds];
//    }
//}

//======================================================

- (NSInteger)getScreenWidth {
    return (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.width);
}

- (NSInteger)getScreenHeight {
    return (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.height);
}

- (NSInteger)getScreenOrientation {
    BOOL isPortrait = [self getScreenWidth] < [self getScreenHeight];
    if (isPortrait) {
        return 1;
    } else {
        return 2;
    }
}

- (void)onBannerAdsVideoStage:(ZAdsVideoStage)stage{
    NSString *strStage = @"";
    switch (stage) {
        case OPENED:
        {
            strStage = @"OPENED";
        }
            break;
        case STARTED:
        {
            strStage = @"STARTED";
        }
            break;
        case PAUSED:
        {
            strStage = @"PAUSED";
        }
            break;
        case RESUMED:
        {
            strStage = @"RESUMED";
        }
            break;
        case COMPLETED:
        {
            strStage = @"COMPLETED";
        }
            break;
        case CLOSED:
        {
            strStage = @"CLOSED";
        }
            break;
        case CONVERSION:
        {
            strStage = @"CONVERSION";
        }
            break;
        case ERROR:
        {
            strStage = @"ERROR";
        }
            break;
        case CLICK_TO_PLAY:
        {
            strStage = @"CLICK_TO_PLAY";
        }
            break;
        case AUTO_PLAY:
        {
            strStage = @"AUTO_PLAY";
        }
            break;
    }
    NSLog(@"onbanner Ads Video Stage: %@",strStage);
}

- (IBAction)onPauseVideoAd:(id)sender {
    [banner pauseAds];
}
- (IBAction)onResumeVideoAd:(id)sender {
//    [banner resumeVideoAd];
}

- (void)onBannerAdsLeaveVideoFullscreen{
    NSLog(@"onBannerAdsLeaveVideoFullscreen");
}

- (void)dealloc {
    NSLog(@"run dealloc");
}
@end
