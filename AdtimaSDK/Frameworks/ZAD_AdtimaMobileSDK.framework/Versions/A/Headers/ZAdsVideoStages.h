//
//  ZAdsVideoStages.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 11/2/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#ifndef ZAdsVideoStages_h
#define ZAdsVideoStages_h

typedef NS_ENUM(int, ZAdsVideoStage) {
    OPENED = 0,
    STARTED,
    PAUSED,
    RESUMED,
    COMPLETED,
    CLOSED,
    CONVERSION,
    ERROR,
    CLICK_TO_PLAY,
    AUTO_PLAY,
    SKIPPED
};

#endif /* ZAdsVideoStages_h */
