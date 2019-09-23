//
//  ZAdsVideo.h
//  ZAD_AdtimaMobileSDK
//
//  Created by anhnt5 on 3/7/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZAdsVideoDelegate;

@interface ZAdsVideo : NSObject

@property (nonatomic, weak) id<ZAdsVideoDelegate> _Nullable delegate;
@property (nonatomic, readonly) BOOL isVideoAdsLoaded;
@property (nonatomic, strong) NSString * _Nullable adsTag;
@property (nonatomic, strong) UIScrollView * _Nullable scrollAbleView;

- (void)setZoneId:(nonnull NSString *)zoneId;
- (nullable NSString *)getZoneID;

- (void)loadAdsVideo;

- (BOOL)isAdsAllowSkip;
- (long)getAdsSkipAfter;
- (BOOL)isAdsAutoPlayPrefer;
- (BOOL)isAdsSoundOnPrefer;

//-------------------------------------------------------------------------
// request ad inventory before show ad
- (void)haveAdsInventory;

/**
 Pass content id to serve content ad similar to content app
 */
- (void)setContentId:(nonnull NSString *)contentId;

/**
 Register view content video to tracking viewability of ads
 */
- (void)registerAdsInteraction:(nonnull UIView *)rootView;

//optional
- (void)addAdsTargeting:(nonnull NSString *)strKey value:(nonnull NSString *)strValue;
- (void)setAdsContentUrl:(nonnull NSString *)strValue;
- (nullable NSString *)getAdsContentUrl;

//return data
- (nullable NSString *)getAdsRawData;
- (nullable NSString *)getAdsMediaUrl;
- (nullable NSString *)getAdsPortraitCoverUrl;
- (nullable NSString *)getAdsLandscapeCoverUrl;
- (nullable NSString *)getAdsLogoUrl;
- (nullable NSString *)getAdsTitle;
- (nullable NSString *)getAdsDescription;
- (nullable NSString *)getMetaData;
- (nullable NSString *)getAction;

- (void)doAdsDisplay:(nonnull NSString *)mediaUrl;
- (void)doAdsStart:(nonnull NSString *)mediaUrl;
- (void)doAdsProgressByTimeWithUrl:(nonnull NSString *)mediaUrl withSecond:(NSInteger)second withDuration:(NSInteger)duration;
- (void)doAdsPause:(nonnull NSString *)mediaUrl;
- (void)doAdsResume:(nonnull NSString *)mediaUrl;
- (void)doAdsComplete:(nonnull NSString *)mediaUrl;
- (void)doAdsClose:(nonnull NSString *)mediaUrl;
- (void)doAdsClick:(nonnull NSString *)mediaUrl;
- (void)doAdsSkip;
- (void)dismissAds;
@end

@protocol ZAdsVideoDelegate <NSObject>
@optional

/*
 */
- (void)onVideoAdsLoadFinished:(nullable NSString *)tag;

/*
 */
- (void)onVideoAdsLoadFailed:(nullable NSString *)tag error:(NSInteger)errorCode;

/*
 */
- (void)onVideoAdsOpened:(nullable NSString *)tag;

/*
 */
- (void)onVideoAdsClosed:(nullable NSString *)tag;

/*
 */
- (void)onVideoAdsLeftApplication:(nullable NSString *)tag;
/*
 */
- (BOOL)onVideoAdsContentHandler:(nullable NSString *)tag
                         content:(nullable NSString *)content;
@end
