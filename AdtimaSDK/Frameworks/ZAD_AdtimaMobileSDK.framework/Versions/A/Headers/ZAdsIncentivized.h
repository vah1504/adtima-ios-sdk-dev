//
//  ZAdsIncentivized.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 2/20/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZAdsIncentivizedDelegate;

@interface ZAdsIncentivized : UIViewController
@property (nonatomic, weak) id<ZAdsIncentivizedDelegate> _Nullable delegate;
@property (nonatomic, readonly) BOOL isIncentivizedAdsLoaded;
//video rewards
@property (nonatomic, strong) id _Nonnull adsRewardExtras;

//-------------------------------------------------------------------------
// require
- (void)loadAdsIncentivized;
//-------------------------------------------------------------------------
// request ad inventory before show ad
- (void)haveAdsInventory;
- (void)show:(nonnull UIViewController *)rootViewController;
- (void)setZoneId:(nonnull NSString *)zoneId;
- (nullable NSString *)getZoneID;

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
// optional
- (void)addAdsFacebookDevice:(nonnull NSString *)hashedID;
- (void)addAdsTargeting:(nonnull NSString *)strKey value:(nonnull NSString *)strValue;
- (void)setAdsContentUrl:(nonnull NSString *)strValue;
- (nullable NSString *)getAdsContentUrl;
@end

@protocol ZAdsIncentivizedDelegate <NSObject>
@optional
/*
 */
- (void)onIncentivizedAdsLoadFinished:(nullable NSString *)type;

/*
 */
- (void)onIncentivizedAdsLoadFailed:(NSInteger)errorCode;

/*
 */
- (void)onIncentivizedAdsOpened;

/*
 */
- (void)onIncentivizedAdsClosed;

/*
 */
- (void)onIncentivizedAdsInteracted;

/*
 */
- (void)onIncentivizedAdsVideoStage:(ZAdsVideoStage)stage;

/*
 */
- (void)onIncentivizedMuteVideo:(BOOL)isMute;

/*
 */
- (void)onIncentivizedAdsRewarded:(nullable id)extras token:(nullable NSString*)token;
@end
