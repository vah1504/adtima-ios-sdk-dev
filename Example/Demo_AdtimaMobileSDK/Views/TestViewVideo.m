//
//  TestViewVideo.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 8/28/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import "TestViewVideo.h"

@implementation TestView

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    @try {
        if (_layerPlayer) {
            _layerPlayer.frame = self.bounds;
        }
    } @catch (NSException *exception) {
        
    }
}

@end
