//
//  ZaloAdsBannerScreen.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 8/27/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import "ZaloAdsBannerScreen.h"
#import "Masonry.h"
#import <ZAD_AdtimaMobileSDK/Adtima.h>

#define STATUS_LOADING @"LOADING"
#define STATUS_LOAD_SUCCESS @"LOAD SUCCESS"
#define STATUS_LOAD_FAIL @"LOAD FAIL"

@import UIKit;
@interface ZaloAdsBannerScreen ()<ZAdsBannerDelegate, ZAdsNativeDelegate>{
    ZAdsBanner *banner;
    UIView *viewNativeAd;
    ZAdsNative *native;
}
@property (nonatomic, weak) IBOutlet UILabel *lbStatus;
@property (nonatomic, weak) IBOutlet UILabel *lbDescription;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ZaloAdsBannerScreen

- (void)dealloc{
    if (banner) {
        [banner dismiss];
        banner = nil;
    }
    if (native) {
        [native dismiss];
        native = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    if (banner) {
        [banner bannerViewWillAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    if (banner) {
        if ([self isMovingFromParentViewController]){
            banner.delegate = nil;
            [banner dismiss];
            [banner removeFromSuperview];
            banner = nil;
        } else {
            [banner bannerViewWillDisAppear];
        }
    }
    
    if (native) {
        if ([self isMovingFromParentViewController]){
            native.delegate = nil;
            [native dismiss];
            [viewNativeAd.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [viewNativeAd removeFromSuperview];
            native = nil;
            viewNativeAd = nil;
        } else {
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setUpView{
    self.lbDescription.text = @"Scroll down to view ad";
    [self updateStatus:STATUS_LOADING];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbStatus.mas_bottom).offset(10);
        make.left.right.equalTo(self.lbStatus);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    [self performSelector:@selector(addZaloAdTest) withObject:nil afterDelay:0.4];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height * 2);
}

- (void)updateStatus:(NSString *)status{
    if (status) {
        if ([status isEqualToString:STATUS_LOADING]) {
            self.lbStatus.textColor = [UIColor darkTextColor];
        } else if ([status isEqualToString:STATUS_LOAD_SUCCESS]){
            self.lbStatus.textColor = [UIColor greenColor];
        } else {
            self.lbStatus.textColor = [UIColor redColor];
        }
        self.lbStatus.text = status;
    }
}

- (void)addZaloAdTest{
    if (self.kindAd == KIND_AD_BANNER) {
        [self addBannerZaloAds];
    } else if (self.kindAd == KIND_AD_NATIVE){
        [self addZaloNativeAds];
    }
}

- (void)addZaloNativeAds{
    native = [[ZAdsNative alloc] initWithParentViewController:self];
    [native setZoneId:self.zoneId];
    [native setContentId:@"adtima_zaloads"];
    [native setAdsImpressionManualHandle:YES];
    native.delegate = self;
    [native loadAdsNative];
}

- (void)addBannerZaloAds{
    banner = [[ZAdsBanner alloc] initWithParentViewController:self];
    [banner setSize:MEDIUM_RECTANGLE];
    [banner setZoneId:self.zoneId];
    [banner setContentId:@"adtima_zaloads"];
    [banner setAdsAutoRefresh:NO];
    [banner setAdsVideoSoundOnPrefer:NO];
    [banner setAdsVideoAutoPlayPrefer:YES];
    [banner setAdsAudioAutoPlayPrefer:NO];
    [banner setAdsBorderEnable:NO];
    banner.delegate = self;
    
    [self.scrollView addSubview:banner];
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.scrollView.bounds.size.height + 10));
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@300);
        make.height.equalTo(@250);
    }];
    [banner loadAdsBanner];
}

#pragma mark - banner delegate
- (void)onBannerAdsLoadFinished:(NSString *)tag kind:(NSString *)type{
    [self updateStatus:STATUS_LOAD_SUCCESS];
    if (banner &&
        banner.isBannerAdsLoaded) {
        [banner bannerViewWillAppear];
        [banner show];
    }
}

- (void)onBannerAdsLoadFailed:(NSString *)tag error:(NSInteger)errorCode{
    NSString *strMessage = [NSString stringWithFormat:@"%@: %d",STATUS_LOAD_FAIL, (int)errorCode];
    [self updateStatus:strMessage];
}

#pragma mark - native delegate
- (void)onNativeAdsLoadFailed:(NSString *)tag error:(NSInteger)errorCode{
    NSString *strMessage = [NSString stringWithFormat:@"%@: %d",STATUS_LOAD_FAIL, (int)errorCode];
    [self updateStatus:strMessage];
}

- (void)onNativeAdsLoadFinished:(NSString *)tag{
    @try{
        [self updateStatus:STATUS_LOAD_SUCCESS];
        if (native &&
            native.isNativeAdsLoaded) {
            viewNativeAd = [[UIView alloc] init];
            [self.scrollView addSubview:viewNativeAd];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickViewNativeAd)];
            [viewNativeAd addGestureRecognizer:tap];
            [viewNativeAd mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(self.scrollView.bounds.size.height + 10));
                make.centerX.equalTo(self.scrollView);
                make.left.equalTo(self.scrollView);
                make.right.equalTo(self.scrollView);
            }];
            
            UIImageView *imgViewLogo = [[UIImageView alloc] init];
            imgViewLogo.contentMode = UIViewContentModeScaleAspectFit;
            imgViewLogo.clipsToBounds = YES;
            [viewNativeAd addSubview:imgViewLogo];
            CGFloat heightImg = self.scrollView.bounds.size.width * 9/16;
            [imgViewLogo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(viewNativeAd);
                make.left.right.equalTo(viewNativeAd);
                make.height.equalTo(@(heightImg));
            }];
            __weak UIImageView *weakImgView = imgViewLogo;
            __weak ZAdsNative *weakNative = native;
            dispatch_queue_t queue = dispatch_queue_create("loadImage", nil);
            dispatch_async(queue, ^{
                NSString *strImgUrl = weakNative.getLogo;
                if (strImgUrl) {
                    NSURL *url = [NSURL URLWithString:strImgUrl];
                    NSData *imgData = [NSData dataWithContentsOfURL:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (imgData &&
                            weakImgView) {
                            weakImgView.image = [UIImage imageWithData:imgData];
                        }
                    });
                }
            });
            
            UILabel *lbTitle = [[UILabel alloc] init];
            lbTitle.font = [UIFont boldSystemFontOfSize:13];
            lbTitle.text = native.getTitle;
            [viewNativeAd addSubview:lbTitle];
            [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgViewLogo.mas_bottom).offset(10);
                make.left.equalTo(viewNativeAd).offset(10);
                make.right.equalTo(viewNativeAd).offset(10);
            }];
            
            UILabel *lbDesc = [[UILabel alloc] init];
            lbDesc.font = [UIFont systemFontOfSize:12];
            lbDesc.text = native.getPromotion;
            [viewNativeAd addSubview:lbDesc];
            [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbTitle.mas_bottom).offset(2);
                make.left.equalTo(viewNativeAd).offset(10);
                make.right.equalTo(viewNativeAd).offset(10);
                make.bottom.equalTo(viewNativeAd);
            }];
            
            [native registerAdsInteraction:viewNativeAd];
            [native displayAds];
        }
    }@catch (...){}
}

- (void)onClickViewNativeAd{
    if (native) {
        [native registerAdsClick];
    }
}
@end
