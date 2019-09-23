//
//  WelcomeAdsScreen.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Khiem Nguyen on 12/13/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import "WelcomeAdsScreen.h"

#import <ZAD_AdtimaMobileSDK/Adtima.h>
#import "Masonry.h"
#import "SVProgressHUD.h"

#define kHEIGHT_BOTTOM_BAR 98

@interface UIColor (HexColor)
+ (UIColor *)hexColor:(NSString *)hexString;
@end

@implementation UIColor (HexColor)
+ (UIColor *)hexColor:(NSString *)hexString{
    UIColor *result = nil;
    @try {
        do {
            NSString *cString = [hexString stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([cString hasPrefix:@"#"]) {
                cString = [cString substringFromIndex:1];
            }
            if (cString.length != 6) {
                result = UIColor.grayColor;
                break;
            }
            unsigned int rgbValue = 0;
            NSScanner *scanner = [NSScanner scannerWithString:cString];
            [scanner scanHexInt:&rgbValue];
            result = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) * 1.f / 255
                                     green:((rgbValue & 0x00FF00) >> 8) * 1.f / 255
                                      blue:(rgbValue & 0x0000FF) * 1.f / 255
                                     alpha:1.f];
        } while (false);
    } @catch (NSException *exception) {
        
    }
    return result;
}

@end

@interface WelcomeAdsScreen ()<ZAdsBannerDelegate>{
    ZAdsBanner *banner;
    UIView *viewContainer;
    UIView *viewCountdown;
    UIView *viewSkippable;
    BOOL isAdVideo;
    CGFloat timeAutoDismiss;
    CGFloat timeAutoDismissAfterCompleteVideo;
    NSTimer *timerSkipAdVideo;
}

@property (nonatomic, copy) void (^showBlock)(void);
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, copy) void (^failBlock)(void);
@property (nonatomic, strong) UILabel *lbCountdown;
@property (nonatomic) CGFloat timeOutShowSkipable;
@end

@implementation WelcomeAdsScreen

- (void)dealloc{
    self.showBlock = nil;
    self.dismissBlock = nil;
    self.failBlock = nil;
}

- (void)cleanUp{
    self.showBlock = nil;
    self.dismissBlock = nil;
    self.failBlock = nil;
    
    [banner dismiss];
    [banner removeFromSuperview];
    banner = nil;
}

- (void)loadWelcomeAdAndShow:(void (^)(void))onShow
                     dismiss:(void (^)(void))onDismiss
                        fail:(void (^)(void))onFail{
    self.showBlock = onShow;
    self.dismissBlock = onDismiss;
    self.failBlock = onFail;
    [self loadAdsBanner];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    do {
        @try {
        } @catch (NSException *exception) {
        }
    } while (false);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)showLoading{
    [SVProgressHUD show];
}

- (void)hideLoading{
    [SVProgressHUD dismiss];
}

- (void)loadAdsBanner{
    if (!banner) {
        banner = [[ZAdsBanner alloc] initWithParentViewController:self];
    }
    [banner setAdsBorderEnable:NO];
    [banner addAdsTargeting:@"mp3" value:@"vitoiconsong"];
    [banner loadBannerWithYOrigin:0];
    [banner setZoneId:self.zoneId];
    [banner setSize:FULL_PAGE];
    
    viewContainer = [[UIView alloc] init];
    viewContainer.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:viewContainer];
    [viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.left.and.right.equalTo(self.view.mas_safeAreaLayoutGuide);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-kHEIGHT_BOTTOM_BAR);
        } else {
            make.top.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kHEIGHT_BOTTOM_BAR);
        }
    }];
    
    [viewContainer addSubview:banner];
    [viewContainer setNeedsLayout];
    [viewContainer layoutIfNeeded];
    banner.frame = viewContainer.bounds;
    
    [banner setAdsVideoAutoPlayPrefer:YES];
    [banner setAdsVideoSoundOnPrefer:YES];
    
    [banner setDelegate:self];
    banner.parentView = self;
    
    
    [banner loadAdsBanner];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI functions
- (void)initViewCountDown{
    @try{
        do {
            if (viewCountdown) {
                UILabel *lbAd = [[UILabel alloc] init];
                lbAd.text = @"Quảng cáo";
                lbAd.textColor = [UIColor hexColor:@"848484"];
                lbAd.font = [UIFont systemFontOfSize:26];
                [viewCountdown addSubview:lbAd];
                [lbAd mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(viewCountdown.mas_centerY);
                    make.left.equalTo(viewCountdown).offset(20);
                }];
                
                UIView *viewNumber = [[UIView alloc] init];
                viewNumber.backgroundColor = [UIColor hexColor:@"d8d8d8"];
                self.lbCountdown = [[UILabel alloc] init];
                self.lbCountdown.textColor = UIColor.whiteColor;
                self.lbCountdown.font = [UIFont systemFontOfSize:26];
                self.lbCountdown.text = @"0";
                self.lbCountdown.textAlignment = NSTextAlignmentCenter;
                self.lbCountdown.hidden = YES;
                [viewNumber addSubview:self.lbCountdown];
                CGFloat paddingInset = 10;
                UIEdgeInsets paddingInsets = UIEdgeInsetsMake(paddingInset, paddingInset, paddingInset, paddingInset);
                [self.lbCountdown mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(viewNumber).insets(paddingInsets);
                    make.width.equalTo(self.lbCountdown.mas_height);
                    make.width.equalTo(@35);
                }];
                [viewCountdown addSubview:viewNumber];
                [viewNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(viewCountdown.mas_centerY);
                    make.right.equalTo(self.view).offset(-20);
                }];
                [viewNumber setNeedsLayout];
                [viewNumber layoutIfNeeded];
                viewNumber.layer.masksToBounds = YES;
                viewNumber.layer.cornerRadius = viewNumber.bounds.size.height / 2;
            }
        } while (false);
    }@catch (...){}
}

- (void)initViewSkip{
    @try{
        if (viewSkippable) {
            UILabel *lbSkip = [[UILabel alloc] init];
            lbSkip.textColor = UIColor.whiteColor;
            lbSkip.text = @"Bỏ qua";
            lbSkip.font = [UIFont systemFontOfSize:26];
            lbSkip.textAlignment = NSTextAlignmentCenter;
            [viewSkippable addSubview:lbSkip];
            [lbSkip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(viewSkippable);
            }];
            
            UIImage *imageSkip = [UIImage imageNamed:@"iconNext"];
            UIImageView *iconSkip = [[UIImageView alloc] init];
            iconSkip.image = imageSkip;
            iconSkip.contentMode = UIViewContentModeScaleAspectFill;
            iconSkip.clipsToBounds = YES;
            [viewSkippable addSubview:iconSkip];
            [iconSkip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(viewSkippable).offset(-10);
                make.centerY.equalTo(viewSkippable);
                make.width.height.equalTo(@25);
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDismissAd)];
            [viewSkippable addGestureRecognizer:tap];
        }
    } @catch (...){}
}

- (void)initOrCheckViewCountdown{
    if (!viewCountdown) {
        viewCountdown = [[UIView alloc] init];
        viewCountdown.backgroundColor = [UIColor hexColor:@"f7f7f7"];
        [self.view addSubview:viewCountdown];
        [viewCountdown mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.left.right.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
            } else {
                make.left.right.bottom.equalTo(self.view);
            }
            make.height.equalTo(@(kHEIGHT_BOTTOM_BAR));
        }];
        [self initViewCountDown];
    }
    
    self.timeOutShowSkipable = 3;
    timeAutoDismiss = 10;
    timeAutoDismissAfterCompleteVideo = 2;
    self.lbCountdown.text = [NSString stringWithFormat:@"%.0f", self.timeOutShowSkipable];
    self.lbCountdown.hidden = NO;
    
    __weak WelcomeAdsScreen *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!isAdVideo) {
            [weakSelf runTimerAutoDismissAd];
        }
        [weakSelf runTimerShowButtonSkip];
    });
}

- (void)initOrCheckNilViewSkip{
    @try{
        if (!viewSkippable) {
            viewSkippable = [[UIView alloc] init];
            viewSkippable.backgroundColor = [UIColor hexColor:@"27baf4"];
            [self.view addSubview:viewSkippable];
            [viewSkippable mas_makeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.left.right.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
                } else {
                    make.left.right.bottom.equalTo(self.view);
                }
                make.height.equalTo(@(kHEIGHT_BOTTOM_BAR));
            }];
            
            viewSkippable.hidden = YES;
            [self initViewSkip];
        }
    } @catch (...){}
}

- (void)showAd{
    if (banner) {
        [self initOrCheckViewCountdown];
        [self initOrCheckNilViewSkip];
        
        if (banner.isBannerAdsLoaded) {
            banner.frame = viewContainer.bounds;
            [banner bannerViewWillAppear];
            [banner show];
        }
    }
}

-(void)onDismissAd{
    @try{
        if (self.dismissBlock) {
            self.dismissBlock();
        }
        [self cleanUp];
        [self dismissViewControllerAnimated:YES completion:nil];
    }@catch (...){}
}

#pragma mark - Timer functions
- (void)runTimerShowButtonSkip{
    __weak WelcomeAdsScreen *weakSelf = self;
    __weak UIView *viewSkip = viewSkippable;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (weakSelf.timeOutShowSkipable > 1) {
            weakSelf.timeOutShowSkipable -=1;
            if (weakSelf.lbCountdown) {
                weakSelf.lbCountdown.text = [NSString stringWithFormat:@"%.0f", weakSelf.timeOutShowSkipable];
                [weakSelf runTimerShowButtonSkip];
            }
        } else if (weakSelf.timeOutShowSkipable == 1){
            if (viewSkip) {
                viewSkip.hidden = NO;
            }
        }
    });
}

- (void)runTimerAutoDismissAd{
    __weak WelcomeAdsScreen *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeAutoDismiss * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (weakSelf) {
            [weakSelf onDismissAd];
        }
    });
}

- (void)runTimerAutoDismissVideoAd{
    dispatch_block_t block = ^{
        timerSkipAdVideo = [NSTimer scheduledTimerWithTimeInterval:timeAutoDismissAfterCompleteVideo target:self selector:@selector(onDismissAd) userInfo:nil repeats:NO];
    };
    if ([NSThread isMainThread]) {
        block();
    } else{
        dispatch_queue_t main = dispatch_get_main_queue();
        dispatch_sync(main, block);
    }
}

- (void)stopTimerIfVideoReplay{
    if (timerSkipAdVideo) {
        [timerSkipAdVideo invalidate];
    }
}

#pragma mark - Delegate Banner
//================Delegate Banner======================

- (void)onBannerAdsLoadFinished:(NSString *)tag kind:(NSString *)type{
    if (self.showBlock) {
        self.showBlock();
    }
//    [self hideLoading];
}

- (void)onBannerAdsLoadFailed:(NSString *)tag error:(NSInteger)errorCode {
    if (self.failBlock) {
        self.failBlock();
    }
    [self cleanUp];
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
    [self onDismissAd];
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
    NSLog(@"VIDEO : onBannerMuteVideo");
}

// default return NO
- (BOOL)onBannerAdsContentHandler:(NSString *)tag content:(NSString *)content{
    //NSLog(@"%@", content);
    if (content &&
        content.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:content]];
    }
    return TRUE;
}

- (void)onBannerAdsVideoStage:(ZAdsVideoStage)stage{
    if (!isAdVideo) {
        isAdVideo = YES;
    }
    NSString *strStage = nil;
    
    switch (stage) {
        case OPENED:
        {
            strStage = @"OPENED";
        }
            break;
        case STARTED:
        {
            strStage = @"STARTED";
            [self stopTimerIfVideoReplay];
        }
            break;
        case COMPLETED:
        {
            strStage = @"COMPLETED";
            [self runTimerAutoDismissVideoAd];
        }
            break;
        case CLOSED:
        {
            strStage = @"CLOSED";
        }
            break;
        case ERROR:
        {
            strStage = @"ERROR";
        }
            break;
        default:
            break;
    }
    
    if (strStage != nil) {
        NSLog(@"AdsVideoStage: %@",strStage);
    }
}

- (void)onBannerAdsLeaveVideoFullscreen{
    NSLog(@"onBannerAdsLeaveVideoFullscreen");
}

@end
