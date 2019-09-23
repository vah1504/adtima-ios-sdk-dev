//
//  ZAdsVideoRollOneListener.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 4/3/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZAdsVideoRollOneDelegate <NSObject>
- (void)onAdsVideoRollOneLoadFailed:(NSInteger)errorCode;
- (void)onAdsVideoRollOneLoadFinished:(id)ad;
- (BOOL)onAdsVideoRollOneContentHandler:(NSString *)contentScheme;
@end

NS_ASSUME_NONNULL_END
