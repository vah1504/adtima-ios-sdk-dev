//
//  AccordionHeaderView.m
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 6/7/15.
//  Copyright (c) 2015 Fuzz Productions, LLC. All rights reserved.
//

#import "AccordionHeaderView.h"

@implementation AccordionHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.cornerRadius = 7.f;
}
@end
