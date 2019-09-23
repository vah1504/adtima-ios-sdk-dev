//
//  VideoRollDemo.h
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 9/5/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoRollDemo : UIViewController
@property (copy, nonatomic) NSString *strZoneId;
@property (weak, nonatomic) IBOutlet UIButton *btnShow;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UILabel *lbProgress;
@property (weak, nonatomic) IBOutlet UITextView *txtLog;
@end
