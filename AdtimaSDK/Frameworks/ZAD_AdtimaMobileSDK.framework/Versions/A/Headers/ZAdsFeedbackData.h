//
//  ZAdsFeedbackData.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 7/27/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZAdsFeedbackEntity;
@interface ZAdsFeedbackData : NSObject
@property (nonatomic, strong) NSArray<ZAdsFeedbackEntity*>* listFeedbacks;
@property (nonatomic, strong) NSNumber* maxChoose;
@property (nonatomic, readonly) NSNumber* expiredTime;
@end
