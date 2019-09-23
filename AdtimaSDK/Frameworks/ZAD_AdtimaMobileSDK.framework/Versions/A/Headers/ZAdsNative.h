//
//  ZAdsNative.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Nguyen Tuan Anh on 7/30/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZAdsNativeDelegate;

@interface ZAdsNative : NSObject

// require
@property (nonatomic, weak) id<ZAdsNativeDelegate> _Nullable delegate;
@property (nonatomic, strong) NSString * _Nullable adsTag;
@property (nonatomic, strong) UIViewController* _Nullable parentView;
- (id _Nullable )initWithParentViewController:(nullable UIViewController *)parentView;
- (void)setZoneId:(nonnull NSString *)zoneId;
- (void)loadAdsNative;

/**
 Pass content id to serve content ad similar to content app
 */
- (void)setContentId:(nonnull NSString *)contentId;

//lo_Nonnullad tag
- (void)loadAdsNative:(nonnull NSString *)loadTag;

- (void)registerAdsInteraction:(nonnull UIView *)rootView;
- (void)registerAdsClick;

/**
 send feedback ads
 */
- (void)feedbackAds:(nonnull NSArray<NSNumber *>*)ids;

// optional
- (void)addAdsTargeting:(nonnull NSString *)strKey value:(nonnull NSString *)strValue;
- (void)setAdsImpressionManualHandle:(BOOL)is; // default is NO (auto send impression)

//-------------------------------------------------------------------------
// request ad inventory before show ad
- (void)haveAdsInventory;

- (void)displayAds;
- (void)dismiss;
- (void)setAdsContentUrl:(nonnull NSString *)strValue;
- (nullable NSString *)getAdsContentUrl;

// return data
@property (nonatomic, readonly) BOOL isNativeAdsLoaded;
- (nullable NSString *)getZoneID;
- (nullable NSString *)getTitle;
- (nullable NSString *)getPromotion;
- (nullable NSString *)getAction;
- (nullable NSString *)getPortraitCover;
- (nullable NSString *)getLandscapeCover;
- (nullable NSString *)getLogo;
- (nullable NSString *)getContext;
- (nullable NSString *)getInfo;
- (nullable NSString *)getAppName;
- (nullable NSString *)getAppCaption;
- (nullable NSString *)getAppDescription;
- (nullable NSString *)getAppPackageName;
- (nullable NSString *)getMetaData;
- (float)getAppRating;
- (BOOL)isApp;

@end

@protocol ZAdsNativeDelegate <NSObject>
@optional

/*
 */
- (void)onNativeAdsLoadFinished:(nullable NSString *)tag;

/*
 */
- (void)onNativeAdsLoadFailed:(nullable NSString *)tag error:(NSInteger)errorCode;

/*
 */
- (void)onNativeAdsOpened:(nullable NSString *)tag;

/*
 */
- (void)onNativeAdsClosed:(nullable NSString *)tag;

/*
 */
- (void)onNativeAdsLeftApplication:(nullable NSString *)tag;

/*
 */
- (BOOL)onNativeAdsContentHandler:(nullable NSString *)tag
                          content:(nullable NSString *)content;

@end
