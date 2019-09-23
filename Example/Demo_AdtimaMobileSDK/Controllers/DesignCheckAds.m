//
//  DesignCheckAds.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 9/18/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import "DesignCheckAds.h"

#import "FieldEntity.h"
#import "DemoEntity.h"

#import "BannerDemo.h"
#import "InterstitialScreen.h"
#import "VideoSuiteDemo.h"
#import "WelcomeAdsScreen.h"

#import "FZAccordionTableView.h"
#import "AccordionHeaderView.h"

#import "Toast+UIView.h"

#define kImageCollapse @"icon_collapse"
#define kImageExpand @"icon_expand"

extern const NSString * kTableViewCellReuseIdentifier;
extern const NSString * kAccordionHeaderViewReuseIdentifier;

@interface DesignCheckAds ()
{
    NSMutableArray *arrList;
    NSIndexPath * indexPathSelect;
    InterstitialScreen *interstitial;
}
@property (nonatomic, strong) BannerDemo *viewBanner;
@property (weak, nonatomic) IBOutlet FZAccordionTableView *tbvList;
@property (nonatomic, strong) WelcomeAdsScreen *welcomeScreen;
@end

@implementation DesignCheckAds
@synthesize welcomeScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tbvList.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:242/255.f alpha:1];
    self.tbvList.tableFooterView = [[UIView alloc] init];
    self.tbvList.allowMultipleSectionsOpen = YES;
    
    [self.tbvList registerNib:[UINib nibWithNibName:@"AccordionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kAccordionHeaderViewReuseIdentifier];
    
    [self createListAds];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)createListAds{
    arrList = [[NSMutableArray alloc] init];
#pragma mark - Welcome Ad zones
    FieldEntity *field = [[FieldEntity alloc] init];
    field.strName = @"Welcome Ad";
    field.adType = FieldAdTypeWelcome;
    DemoEntity *item = [DemoEntity
                        initWithName:@"Banner FullPage Graphic"
                        zoneId:@"2443968825813070075"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Banner Fullpage Video"
            zoneId:@"1901188962231742706"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Banner FullPage Html5"
            zoneId:@"2469235697508643060"];
    [field.arrZones addObject:item];
    
    [arrList addObject:field];
#pragma mark - Interstitial zones
    field = [[FieldEntity alloc] init];
    field.adType = FieldAdTypeInterstitial;
    field.strName = @"Interstitial";
    
    item = [DemoEntity
            initWithName:@"Interstitial Graphic"
            zoneId:@"197184443007856892"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Interstitial Video"
            zoneId:@"222451314703429833"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Interstitial Audio"
            zoneId:@"790480474974154955"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Interstitial HTML5"
            zoneId:@"1358445846390599885"];
    [field.arrZones addObject:item];
    
    [arrList addObject:field];
#pragma mark - Masthead zones
    field = [[FieldEntity alloc] init];
    field.strName = @"Masthead";
    field.adType = FieldAdTypeMasthead;
    
    item = [DemoEntity
            initWithName:@"Masthead graphic"
            zoneId:@"1875939682722214137"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Masthead HTML5"
            zoneId:@"247702106041446594"];
    [field.arrZones addObject:item];
    
    [arrList addObject:field];
#pragma mark - Overlay Player
    field = [[FieldEntity alloc] init];
    field.strName = @"Overlay Player";
    field.adType = FieldAdTypeMediumBanner;
    
    item = [DemoEntity
            initWithName:@"Banner 300x250 Graphic"
            zoneId:@"765196011092537598"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Banner 300x250 HTML5"
            zoneId:@"815746659474960580"];
    [field.arrZones addObject:item];
    
    item = [DemoEntity
            initWithName:@"Banner 300x250 Video"
            zoneId:@"1384268383775060166"];
    [field.arrZones addObject:item];
    
    [arrList addObject:field];
}

#pragma mark - tableview delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AccordionHeaderView * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kAccordionHeaderViewReuseIdentifier];
    FieldEntity *field = [arrList objectAtIndex:section];
    UILabel *lbName = [cell viewWithTag:11];
    lbName.text = field.strName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return arrList.count;
    NSInteger rows = 0;
    FieldEntity *field = [arrList objectAtIndex:section];
    if (field) {
        rows = field.arrZones.count;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell-list" forIndexPath:indexPath];
    UILabel *lblName = (UILabel *)[cell viewWithTag:10];
    UILabel *lblZoneId = (UILabel *)[cell viewWithTag:11];
    
    DemoEntity *item = nil;
    
    FieldEntity *field = [arrList objectAtIndex:indexPath.section];
    if (field) {
        item = (DemoEntity *)[field.arrZones objectAtIndex:indexPath.row];
        lblName.text = item.strName;
        lblZoneId.text = item.strZoneId;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    indexPathSelect = indexPath;
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update UI
        FieldEntity *field = nil;
        if (indexPath.section >= 0 &&
            indexPath.section < arrList.count) {
            field = [arrList objectAtIndex:indexPath.section];
            DemoEntity *item = [field.arrZones objectAtIndex:indexPath.row];
            switch (field.adType) {
                case FieldAdTypeWelcome:
                {
                    [self showWelcomeAd:item.strZoneId];
                }
                    break;
                case FieldAdTypeInterstitial:
                {
                    [self showInterstitial:item.strZoneId];
                }
                    break;
                case FieldAdTypeMasthead:
                {
                    [self showBannerAdsWithZone:item.strZoneId
                                     typeAdSize:@"5"];
                }
                    break;
                case FieldAdTypeMediumBanner:
                {
                    [self showBannerAdsWithZone:item.strZoneId
                                     typeAdSize:@"2"];
                }
                    break;
                default:
                    break;
            }
        } else {
            return;
        }
    });
}

#pragma mark - <FZAccordionTableViewDelegate> -

- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    UIImageView *icon = [header viewWithTag:10];
    if (icon) {
        icon.image = [UIImage imageNamed:kImageExpand];
    }
}

- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
}

- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    UIImageView *icon = [header viewWithTag:10];
    if (icon) {
        icon.image = [UIImage imageNamed:kImageCollapse];
    }
}

- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    
}

- (void)showBannerAdsWithZone:(NSString *)strZoneId
                   typeAdSize:(NSString *)strType{
    BannerDemo *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerDemo"];
    banner.zoneId = strZoneId;
    banner.strType = strType;
    [self.navigationController pushViewController:banner animated:YES];
}

- (void)showInterstitial:(NSString *)zoneId {
    @try {
        if (!interstitial ||
            interstitial == nil) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            interstitial = [sb instantiateViewControllerWithIdentifier:@"InterstitialScreen"];
        }
        interstitial.strZoneId = zoneId;
        
        [self.navigationController pushViewController:interstitial animated:YES];
    } @catch (NSException *exception) {
        
    }
}

- (void)showWelcomeAd:(NSString *)zoneId{
    @try{
        if (!welcomeScreen) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            welcomeScreen = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([WelcomeAdsScreen class])];
            welcomeScreen.zoneId = zoneId;
            __weak DesignCheckAds *weakSelf = self;
            __weak WelcomeAdsScreen *weakVC = welcomeScreen;
            [self.view makeToast:@"Loading Welcome Ads"];
            [welcomeScreen loadWelcomeAdAndShow:^{
                if (weakSelf &&
                    weakVC) {
                    [weakVC showAd];
                    [weakSelf presentViewController:welcomeScreen animated:NO completion:nil];
                }
            } dismiss:^{
                weakSelf.welcomeScreen = nil;
            } fail:^{
                [weakSelf.view makeToast:@"Show welcome ad fail"];
                weakSelf.welcomeScreen = nil;
            }];
        }
    } @catch (...){}
}
@end
