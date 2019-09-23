//
//  ZAdsRollListener.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Khiem Nguyen on 7/20/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int EVENT_ERROR;
extern int EVENT_LOADED;
extern int EVENT_STARTED;
extern int EVENT_COMPLETED;

typedef NS_ENUM(NSInteger, VideoSuiteRoll) {
    PreRoll,
    MidRoll,
    PostRoll
};

@protocol ZAdsRollListener<NSObject>
- (void)onAdsRollEvent:(int)event viewRoll:(VideoSuiteRoll)rollView;
@end
