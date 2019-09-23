//
//  ZAdsInterstitial.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Nguyen Tuan Anh on 5/14/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZAdsInterstitialDelegate;

@interface ZAdsInterstitial : UIViewController

@property (nonatomic, weak) id<ZAdsInterstitialDelegate> _Nullable delegate;
@property (nonatomic, readonly) BOOL isInterstitialAdsLoaded;

//destroy object interstitial loaded
- (void)dismiss;

//-------------------------------------------------------------------------
// require
- (void)loadAdsInterstitial;

//-------------------------------------------------------------------------
// request ad inventory before show ad
- (void)haveAdsInventory;

- (void)show:(nonnull UIViewController *)rootViewController;
- (void)setZoneId:(nonnull NSString *)zoneId;
- (nullable NSString *)getZoneID;

//-------------------------------------------------------------------------
//
- (void)setAdsDismissOnCompletedPrefer:(BOOL)prefer;
- (void)setAdsDismissOnClickedPrefer:(BOOL)prefer;

/**
 Pass content id to serve content ad similar to content app
 */
- (void)setContentId:(nonnull NSString *)contentId;
//-------------------------------------------------------------------------
// video
- (void)setAdsVideoSoundOnPrefer:(BOOL)isSound;
- (void)setAdsVideoAutoPlayPrefer:(BOOL)isAuto;
- (BOOL)isAdsVideoAutoPlayPrefer;
- (BOOL)isAdsVideoSoundOnPrefer;
//-------------------------------------------------------------------------
// audio
- (void)setAdsAudioAutoPlayPrefer:(BOOL)isAuto;
- (BOOL)isAdsAudioAutoPlayPrefer;
//-------------------------------------------------------------------------
// optional
- (void)addAdsFacebookDevice:(nonnull NSString *)hashedID;
- (void)addAdsTargeting:(nonnull NSString *)strKey value:(nonnull NSString *)strValue;
- (void)setAdsContentUrl:(nonnull NSString *)strValue;
- (nullable NSString *)getAdsContentUrl;

@end

@protocol ZAdsInterstitialDelegate <NSObject>
@optional
/*
 */
- (void)onInterstitialAdsLoadFinished:(nullable NSString *)type;

/*
 */
- (void)onInterstitialAdsLoadFailed:(NSInteger)errorCode;

/*
 */
- (void)onInterstitialAdsOpened;

/*
 */
- (void)onInterstitialAdsClosed;

/*
 */
- (void)onInterstitialAdsClicked;

/*
 */
- (void)onInterstitialAdsInteracted;

/*
 */
- (void)onInterstitialClickPlayVideo;

/*
 */
- (void)onInterstitialFinishPlayVideo;
/*
 */
- (void)onInterstitialAdsVideoStage:(ZAdsVideoStage)stage;
/**
 */
- (void)onInterstitialAdsAudioStage:(ZAdsAudioStage)stage;
/*
 */
- (void)onInterstitialPauseVideo;

/**
 Return status isMute of video Ad
 If isMute = YES, sound video Ad is OFF
 If isMute = NO, sound video Ad is ON
 */
- (void)onInterstitialMuteVideo:(BOOL)isMute;

/*
 */
- (void)onInterstitialHtmlSoundOn;

/*
 */
- (void)onInterstitialHtmlSoundOff;
/*
 call app  to handle info control center after ad playback html5 video
 */
- (void)onInterstitialAdsLeaveVideoFullscreen;

/**
 */
- (BOOL)onInterstitialAdsContentHandler:(nullable NSString *)content;

@end
