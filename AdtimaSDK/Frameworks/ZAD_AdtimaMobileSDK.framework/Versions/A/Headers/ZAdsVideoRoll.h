//
//  ZAdsVideoRoll.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 8/31/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZAD_AdtimaMobileSDK/ZAdsVideoRollListener.h>

FOUNDATION_EXPORT NSString *TOTAL_DURATION_IN_SECS;
FOUNDATION_EXPORT NSString *MAX_DURATION_PER_ITEM_IN_SECS;
FOUNDATION_EXPORT NSString *MAX_ITEM_NON_SKIP;
FOUNDATION_EXPORT NSString *MAX_ITEM;
FOUNDATION_EXPORT NSString *TOTAL_SKIP_AFTER_DURATION_IN_SECS;

@interface ZAdsVideoRoll : NSObject
- (instancetype)initWithZoneId:(NSString *)strZoneId;
- (void)setAdsPreRollSetting:(NSString *)setting value:(int)value;
- (void)setAdsMidRollSetting:(NSString *)setting value:(int)value;
- (void)setAdsPostRollSetting:(NSString *)setting value:(int)value;
- (void)addAdsTargeting:(NSString *)key value:(NSString *)value;
- (void)setAdsTargeting:(NSDictionary *)data;
- (NSDictionary *)getAdsTargeting;
- (void)setAdsContentId:(NSString *)contentId;
- (NSString *)getAdsContentId;
- (void)loadAds;
- (BOOL)isAdsLoaded;

//-------------------------------------------------------------------------
// request ad inventory before show ad
- (void)haveAdsInventory;

@property (nonatomic, weak) id<ZAdsVideoRollListener>listener;
@end
