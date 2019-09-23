//
//  QCCheckZaloAds.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 8/27/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import "QCCheckZaloAds.h"
#import "DemoEntity.h"
#import "Masonry.h"
#import "ZaloAdsBannerScreen.h"

#define CELL_IDENTIFIER @"CELL"

@interface QCCheckZaloAds ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *listZones;
    NSMutableArray *arrItems;
}
@end

@implementation QCCheckZaloAds

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"iOS Adtima SDK Demo";
    arrItems = [NSMutableArray arrayWithArray:@[
                                                [DemoEntity initWithName:@"[Zalo Ads] ad Medium Banner"
                                                                  zoneId:@"1800754450549665926"],
                                                [DemoEntity initWithName:@"[Zalo Ads] ad Native"
//                                                                  zoneId:@"689982191617667231"
                                                                  zoneId:@"569803857009787493"
                                                 ]
                                                ]
                ];
    listZones = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:listZones];
    [listZones mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    listZones.delegate = self;
    listZones.dataSource = self;
    listZones.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    if (cell) {
        NSInteger indexRow = indexPath.row;
        if (indexRow >= 0 &&
            indexRow < arrItems.count) {
            id item = [arrItems objectAtIndex:indexRow];
            if ([item isKindOfClass:[DemoEntity class]]) {
                DemoEntity *zone = item;
                cell.textLabel.text = zone.strName;
                cell.detailTextLabel.text = zone.strZoneId;
            }
        }
    }
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger indexRow = indexPath.row;
    do {
        id item = [arrItems objectAtIndex:indexRow];
        DemoEntity *zone = nil;
        if ([item isKindOfClass:[DemoEntity class]]) {
            zone = item;
        } else {
            break;
        }
        if (indexRow < 0 &&
            indexRow >= arrItems.count) {
            break;
        }
        if (indexRow == 0) {
            ZaloAdsBannerScreen *banner = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ZaloAdsBannerScreen class])];
            banner.zoneId = zone.strZoneId;
            banner.kindAd = KIND_AD_BANNER;
            [self.navigationController pushViewController:banner animated:YES];
        } else if (indexRow == 1){
            ZaloAdsBannerScreen *banner = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ZaloAdsBannerScreen class])];
            banner.zoneId = zone.strZoneId;
            banner.kindAd = KIND_AD_NATIVE;
            [self.navigationController pushViewController:banner animated:YES];
        }
    } while (false);
}
@end
