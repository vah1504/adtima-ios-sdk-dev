//
//  ZAdsVideoRollOne.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 4/3/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZAD_AdtimaMobileSDK/ZAdsVideoRollOneDelegate.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZAdsVideoRollOne : NSObject
- (instancetype)initWithZoneId:(NSString *)strZoneId;
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

@property (nonatomic, weak) id<ZAdsVideoRollOneDelegate>listener;
@end

NS_ASSUME_NONNULL_END
