//
//  ZAdsTracking.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 5/3/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAdsTracking : NSObject
+ (ZAdsTracking *)sharedInstance;
- (void)haveAdsInventoryForZoneId:(NSString *)zoneId;
- (void)haveAdsInventoryForZonedIds:(NSArray<NSString *> *)zoneIds;
@end

NS_ASSUME_NONNULL_END
