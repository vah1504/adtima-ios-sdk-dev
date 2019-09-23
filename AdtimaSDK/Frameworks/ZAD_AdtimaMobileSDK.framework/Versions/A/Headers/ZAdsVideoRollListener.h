//
//  ZAdsVideoRollListener.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 8/31/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZAD_AdtimaMobileSDK/ZAdsVideoRollPosition.h>

@protocol ZAdsVideoRollListener <NSObject>
- (void)onAdsVideoRollLoadFailed:(NSInteger)errorCode;
- (void)onAdsVideoRollLoadFinished:(ZAdsVideoRollPosition)position ads:(NSArray *)ads;
- (BOOL)onAdsVideoRollContentHandler:(NSString *)contentScheme;
@end
