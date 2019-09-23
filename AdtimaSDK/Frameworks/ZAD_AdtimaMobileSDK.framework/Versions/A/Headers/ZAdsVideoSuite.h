//
//  ZAdsVideoSuite.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Khiem Nguyen on 7/13/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * _Nonnull TOTAL_DURATION_IN_SECS;
FOUNDATION_EXPORT NSString * _Nonnull MAX_DURATION_PER_ITEM_IN_SECS;
FOUNDATION_EXPORT NSString * _Nonnull MAX_ITEM_NON_SKIP;
FOUNDATION_EXPORT NSString * _Nonnull TOTAL_SKIP_DURATION_IN_SECS;
FOUNDATION_EXPORT NSString * _Nonnull MAX_ITEM;

#import "ZAdsRollListener.h"

@protocol ZAdsVideoSuiteDelegate <NSObject>

- (void)onAdsLoadFinished;
- (void)onAdsLoadFailed:(NSInteger)errorCode;

@end

@interface ZAdsVideoSuite : NSObject
@property (nonatomic, readonly) BOOL isAdsLoaded;
@property (nonatomic, readonly) BOOL isAdsPreRollReady;
@property (nonatomic, readonly) BOOL isAdsMidRollReady;
@property (nonatomic, readonly) BOOL isAdsPostRollReady;
@property (nonatomic, weak) id<ZAdsRollListener> _Nullable delegateRoll;
@property (nonatomic, weak) id<ZAdsVideoSuiteDelegate> _Nullable delegate;

- (nullable id)initWithZoneId:(nonnull NSString*)zoneId;

- (void)setAdsPreRollSetting:(nonnull NSString*)settings value:(int)value;
- (void)setAdsMidRollSetting:(nonnull NSString*)settings value:(int)value;
- (void)setAdsPostRollSetting:(nonnull NSString*)settings value:(int)value;

- (void)loadAds;

//-------------------------------------------------------------------------
// request ad inventory before show ad
- (void)haveAdsInventory;

- (void)showAdsPreRoll:(nonnull UIView*)rootView;
- (void)showAdsMidRoll:(nonnull UIView*)rootView;
- (void)showAdsPostRoll:(nonnull UIView*)rootView;

- (void)dismissAdsPreRoll;
- (void)dismissAdsMidRoll;
- (void)dismissAdsPostRoll;

- (void)addAdsTargeting:(nonnull NSString *)strKey value:(nonnull NSString *)strValue;

//-------------------------------------------------------------------------
// pause/ resume ad
- (void)pauseAds;
- (void)resumeAds;

/**
 Pass content id to serve content ad similar to content app
 */
- (void)setContentId:(nonnull NSString *)contentId;

/**
 setting show number ad per roll view, should call this function before load ad
 */
- (void)setAdsServingNumPerPosition:(int)numAd;
@end
