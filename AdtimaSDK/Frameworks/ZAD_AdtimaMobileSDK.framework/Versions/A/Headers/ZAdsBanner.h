//
//  ZAdsBanner.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Nguyen Tuan Anh on 4/20/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAdsBannerSize.h"
#import "ZAdsVideoStages.h"
#import "ZAdsAudioStages.h"

@protocol ZAdsBannerDelegate;

@interface ZAdsBanner : UIView

@property (nonatomic, weak) UIViewController * _Nullable parentView;
@property (nonatomic, weak) id<ZAdsBannerDelegate> _Nullable delegate;
@property (nonatomic, strong) NSString * _Nullable adsTag;
@property (nonatomic, readonly) BOOL isBannerAdsLoaded;

//-------------------------------------------------------------------------
// require
- (id _Nullable )initWithParentViewController:(nullable UIViewController *)parentView;
/**
 Must set superview & frame banner before load ads
 */
- (void)loadAdsBanner;
- (void)loadAdsBanner:(nonnull NSString *)loadTag;

- (void)bannerViewWillAppear;
- (void)bannerViewWillDisAppear;

- (void)setZoneId:(nonnull NSString *)zoneId;
- (void)loadBannerWithYOrigin:(float)origin;

- (void)setSize:(BannerSize)sizeBanner;
- (BannerSize)getSize;
/**
 Pass content id to serve content ad similar to content app
 */
- (void)setContentId:(nonnull NSString *)contentId;

//-------------------------------------------------------------------------
// request ad inventory before show ad
- (void)haveAdsInventory;

- (void)show;

- (void)pauseAds;

/**
 clean up ad
 */
- (void)dismiss;

/**
 refresh new ad
 */
- (void)refreshAds;

- (nullable NSString *)getZoneID;

- (void)setAdsAutoRefresh:(BOOL)autoRefresh;
- (BOOL)getAdsAutoRefresh;

- (void)addAdsTargeting:(nonnull NSString *)strKey value:(nonnull NSString *)strValue;
- (void)setAdsContentUrl:(nonnull NSString *)strValue;
- (nullable NSString *)getAdsContentUrl;
/**
 send feedback ads
 */
- (void)feedbackAds:(NSArray<NSNumber *>*_Nonnull)ids;
//-------------------------------------------------------------------------
// video
- (void)setAdsVideoAutoPlayPrefer:(BOOL)isAuto;
- (BOOL)isAdsVideoAutoPlayPrefer;

- (void)setAdsVideoSoundOnPrefer:(BOOL)isSound;
- (BOOL)isAdsVideoSoundOnPrefer;

- (void)setOnSound:(BOOL)isOn;
//-------------------------------------------------------------------------
// audio
- (void)setAdsAudioAutoPlayPrefer:(BOOL)isAuto;
- (BOOL)isAdsAudioAutoPlayPrefer;
//-------------------------------------------------------------------------
// optional
- (void)addAdsFacebookDevice:(nonnull NSString *)hashedID;
- (void)setAdsBorderEnable:(BOOL)isEnable;
- (BOOL)isAdsBorderEnable;
-(void)setAdsBackgroundColor:(nonnull UIColor *)color;
//-------------------------------------------------------------------------
// if have ads contain in scrollview. Please implement.
- (void)didAttachToParent;
- (void)willRemoveFromParent;
- (void)setScrollViewContainer:(nullable UIScrollView *)scrollView;
@end

@protocol ZAdsBannerDelegate <NSObject>
@optional

/*
 */
- (void)onBannerAdsLoadFinished:(nullable NSString *)tag kind:(nullable NSString *)type;

/*
 */
- (void)onBannerAdsLoadFailed:(nullable NSString *)tag error:(NSInteger)errorCode;

/*
 callback when ads receive interact from user, NOT redirect to landing page
 */
- (void)onBannerAdsInteracted:(nullable NSString *)tag;

/*
 callback when ads will redirect to landing page
 */
- (void)onBannerAdsClicked:(nullable NSString *)tag;

/*
 */
- (void)onBannerAdsClosed:(nullable NSString *)tag;

/*
 */
- (void)onBannerAdsOpened:(nullable NSString *)tag;

/*
 */
- (void)onBannerClickPlayVideo:(nullable NSString *)tag;

/*
 */
- (void)onBannerFinishPlayVideo:(nullable NSString *)tag;

/*
 */
- (void)onBannerPauseVideo:(nullable NSString *)tag;
/*
 */
- (void)onBannerAdsVideoStage:(ZAdsVideoStage)stage;
/**
 */
- (void)onBannerAdsAudioStage:(ZAdsAudioStage)stage;
/**
 Return status isMute of video Ad
 If isMute = YES, sound video Ad is OFF
 If isMute = NO, sound video Ad is ON
 */
- (void)onBannerMuteVideo:(nullable NSString *)tag
                    sound:(BOOL)isMute;

/*
 */
- (void)onBannerWillEnterBackground;

/*
 */
- (void)onBannerWillBecomeActive;

/*
 */
- (void)onBannerHtmlSoundOn;

/*
 */
- (void)onBannerHtmlSoundOff;

/*
 */
- (BOOL)onBannerAdsContentHandler:(nullable NSString *)tag
                          content:(nullable NSString *)content;

/*
 call app  to handle info control center after ad playback html5 video
 */
- (void)onBannerAdsLeaveVideoFullscreen;

@end
