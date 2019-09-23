//
//  ZAdsFeedback.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 7/27/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZAdsFeedbackData;

@protocol ZAdsFeedbackDelegate<NSObject>
- (void)onAdsFeedbackFetchSuccess:(ZAdsFeedbackData *)data;
- (void)onAdsFeedbackFetchFail:(NSInteger)errorCode;
@end

@interface ZAdsFeedback : NSObject
+ (ZAdsFeedback *)sharedInstance;
- (void)fetchAdsFeedback;
@property (nonatomic, weak) id<ZAdsFeedbackDelegate> delegate;
@end
