//
//  ZAdsAudioStages.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Khiem Nguyen on 5/4/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#ifndef ZAdsAudioStages_h
#define ZAdsAudioStages_h
typedef NS_ENUM(int, ZAdsAudioStage) {
    AUDIO_OPENED = 0,
    AUDIO_STARTED,
    AUDIO_PAUSED,
    AUDIO_RESUMED,
    AUDIO_COMPLETED,
    AUDIO_CLOSED,
    AUDIO_CONVERSION,
    AUDIO_ERROR,
    AUDIO_SKIPPED,
    AUDIO_CLICK_TO_PLAY,
    AUDIO_AUTO_PLAY,
};

#endif /* ZAdsAudioStages_h */
