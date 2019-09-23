//
//  HomeViewController.m
//  Demo_AdtimaMobileSDK
//
//  Created by anhnt5 on 4/15/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import "HomeViewController.h"
#import "FieldEntity.h"
#import "DemoEntity.h"
#import "BannerDemo.h"
#import "VideoViewController.h"
#import "NativeSingleViewController.h"
#import "IncentivizedScreen.h"
#import "InterstitialScreen.h"
#import "VideoSuiteDemo.h"
#import "SVProgressHUD.h"
#import "FZAccordionTableView.h"
#import "AccordionHeaderView.h"
#import "VideoRollDemo.h"
#import "VideoRollOneDemo.h"
#import "DemoPauseAds.h"

extern NSString *kFbTestDevice;

#define kImageCollapse @"icon_collapse"
#define kImageExpand @"icon_expand"

NSString * kTableViewCellReuseIdentifier = @"cell-list";
NSString * kAccordionHeaderViewReuseIdentifier = @"AccordionHeaderViewReuseIdentifier";

@interface HomeViewController ()<UIActionSheetDelegate, ZAdsFeedbackDelegate>
{
    NSMutableArray *arrList;
    NSIndexPath * indexPathSelect;
    
    IncentivizedScreen *incentivized;
    InterstitialScreen *interstitial;
}
@property (nonatomic, strong) BannerDemo *viewBanner;
@property (weak, nonatomic) IBOutlet FZAccordionTableView *tbvList;
@end

@implementation HomeViewController

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (BOOL)schemeAvailable:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    return [application canOpenURL:URL];
}

- (void)viewDidLoad {
//    NSLog(@"%@", [self applicationDocumentsDirectory]);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tbvList.backgroundColor = [UIColor colorWithRed:241/255.f green:241/255.f blue:242/255.f alpha:1];
    self.tbvList.tableFooterView = [[UIView alloc] init];
//    self.tbvList.keepOneSectionOpen = YES;
    self.tbvList.allowMultipleSectionsOpen = YES;
    
    [self.tbvList registerNib:[UINib nibWithNibName:@"AccordionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kAccordionHeaderViewReuseIdentifier];
    
    [self createListAds];
    [self fetchFeedbackAds];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchFeedbackAds{
    ZAdsFeedback *feedback = [ZAdsFeedback sharedInstance];
    feedback.delegate = self;
    [feedback fetchAdsFeedback];
}

- (void)createListAds{
    arrList = [[NSMutableArray alloc] init];
    
    FieldEntity *field = [[FieldEntity alloc] init];
    field.strName = @"Bundle Demo";
    [field.arrZones addObject:[DemoEntity initWithName:@"BundleDemo" zoneId:@"2479550486671751272"]];
    [arrList addObject:field];
    
//    field = [[FieldEntity alloc] init];
//    field.strName = @"OM Review";
//    [field.arrZones addObject:[DemoEntity initWithName:@"OM-SDK_Banner_Dev"
//                                                zoneId:@"2782763237760267929"]];
//    [field.arrZones addObject:[DemoEntity initWithName:@"OM-OM-SDK_Interstitial_Dev"
//                                                zoneId:@"535981053978310298"]];
//    [field.arrZones addObject:[DemoEntity initWithName:@"OM-OM-SDK_Video_Dev"
//                                                zoneId:@"1104007998045910684"]];
//    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Pause Ads";
    field.showDemoPauseAd = YES;
    [field.arrZones addObject:[DemoEntity initWithName:@"Demo Pause Ads"
                                                zoneId:@"2782763237760267929"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Pop Up";
    [field.arrZones addObject:[DemoEntity initWithName:@"[Pop up] BaoMoi iOS" zoneId:@"2479550486671751272"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Pop up] ZMP3 iOS" zoneId:@"1911585098075437078"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Zalo Ads";
    [field.arrZones addObject:[DemoEntity initWithName:@"Zalo Post Promotion" zoneId:@"2363055223959142727"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Zalo App Promotion" zoneId:@"1795089852542697797"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Zalo Page Promotion" zoneId:@"116352205014384984"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Zalo Chat Promotion" zoneId:@"1315837704935013976"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Zalo Slider" zoneId:@"65799976083997042"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Adtima";
    
    [field.arrZones addObject:[DemoEntity initWithName:@"A/B Testing banner" zoneId:@"1749683183411490992"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima_HTML_Click_tag_1" zoneId:@"1705780865230389881"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima_HTML_Click_tag_2" zoneId:@"2796922881646752168"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima_HTML_Click_full_1" zoneId:@"550182479306650029"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima_HTML_Click_full_2" zoneId:@"1118220435670397359"]];
    
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima_HTML_MultiClick_1" zoneId:@"1705780865230389881"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima_HTML_MultiClick_2" zoneId:@"2796922881646752168"]];
    
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Endcard (Video)" zoneId:@"2657695344878908006"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video Roll" zoneId:@"2515931148886440792"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Audio" zoneId:@"1469322072109316189"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Audio DAAST Wrapper" zoneId:@"876681469332256379"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Audio Debug" zoneId:@"1710110432782940155"]];    
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Graphic / Native" zoneId:@"569803857009787493"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Html" zoneId:@"1705780865230389881"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video / Native Video" zoneId:@"1137769314325578343"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video / Native Video 2" zoneId:@"1567838279598293213"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video NONE Native" zoneId:@"1065150531270834669"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video Suite" zoneId:@"2515931148886440792"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Incentivized" zoneId:@"2251603300824087514"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Native Video Wrapper No Ad" zoneId:@"812564415126141311"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Video Suite Adtima only" zoneId:@"1039253106836601831"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video Roll One" zoneId:@"1938697104901239330"]];
    //1469322072109316189
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video Pre-Play" zoneId:@"1469322072109316189"]];
    //2658350155592855571
    [field.arrZones addObject:[DemoEntity initWithName:@"Adtima Video Interstitial" zoneId:@"2658350155592855571"]];
    [arrList addObject:field];
    
//    field = [[FieldEntity alloc] init];
//    field.strName = @"Vungle";
//    //    [field.arrZones addObject:[DemoEntity initWithName:@"Vungle Video Ads 4.x" zoneId:@"470556439928602591"]];
//    [field.arrZones addObject:[DemoEntity initWithName:@"Vungle Video Ads 5.x" zoneId:@"4882689693285343"]];
//    [arrList addObject:field];
//
    field = [[FieldEntity alloc] init];
    field.strName = @"Inmobi";
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Inmobi graphic banner" zoneId:@"901218643264109230"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Inmobi graphic interstitial" zoneId:@"2037213174951279266"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Inmobi native" zoneId:@"43085277034937045"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Inmobi Video Reward" zoneId:@"1733592144271604270"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Facebook";
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] FacebookBanner" zoneId:@"2299639159955341940"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] FacebookInterstitial" zoneId:@"620883920240984651"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] FacebookNative" zoneId:@"14711116759777644"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Facebook Instream" zoneId:@"1607264657741413369"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Facebook Outstream" zoneId:@"825509614060009592"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Facebook Video Reward" zoneId:@"622802224434084391"]];
    //1190848976890853945
    [field.arrZones addObject:[DemoEntity initWithName:@"[android] Facebook Video Reward" zoneId:@"1190848976890853945"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Facebook Graphic ORTB " zoneId:@"2429672790945134143"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Facebook Native ORTB " zoneId:@"1394730146719036951"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Facebook Inters ORTB" zoneId:@"851397623925929582"]];
    //851397623925929582
    //1394730146719036951
    [arrList addObject:field];
    
//    field = [[FieldEntity alloc] init];
//    field.strName = @"MobVista";
//    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Mobvista Native" zoneId:@"1188858104930320973"]];
//    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Mobvista / Video Rewarded" zoneId:@"1354049088369687902"]];
//    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"AdColony";
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] AdColony Video Reward" zoneId:@"2466616403113245039"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] AdColony Interstitial" zoneId:@"2467236029455103768"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Mobfox";
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] MobFox Native Banner" zoneId:@"2188169146418035915"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] MobFox Graphic Banner" zoneId:@"1293038910426281998"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Smaato";
    [field.arrZones addObject:[DemoEntity initWithName:@"[All]Ad Smaato banner" zoneId: @"108408134719468519"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[All]Ad Smaato interstitial" zoneId: @"676443874880091129"]];
    //2405100501360669640
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS]Ad Smaato banner" zoneId: @"1837135044044878838"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS]Ad Smaato interstitial" zoneId: @"2405100501360669640"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Google";
    [field.arrZones addObject:[DemoEntity initWithName:@"[Android] Admob Native Advance" zoneId:@"1820356724238270814"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Admob Native Banner" zoneId:@"166304719071297966"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] GoogleBanner" zoneId:@"27025642695901820"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google Fullpage" zoneId:@"1264098312684257964"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] GoogleInterstitial" zoneId:@"1163591920429515376"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google Mediation vs Facebook" zoneId:@"2730322924026690800"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google vs Facebook Mediation Interstitial" zoneId:@"1898020891275000688"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google IMA only" zoneId:@"1633111453101161458"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] DFP Banner" zoneId:@"1847468593625135978"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] DFP Interstitial" zoneId:@"168713353910778721"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google Video Reward" zoneId:@"1659000150161848824"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google Mediate InMobi" zoneId:@"131206860508723249"]];
    [arrList addObject:field];
    
    //2217212531317370950
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google Bidding Fill" zoneId:@"2217212531317370950"]];
    //2784608372890497112 - No fill
    [field.arrZones addObject:[DemoEntity initWithName:@"[iOS] Google Bidding NO Fill" zoneId:@"2784608372890497112"]];
    field = [[FieldEntity alloc] init];
    field.strName = @"Test Ads";
    
    //2076088182372792149
    [field.arrZones addObject:[DemoEntity initWithName:@"[Criteo]check ad criteo" zoneId:@"2076088182372792149"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[MP3]GG_300x250_IOS" zoneId:@"1258011334708523153"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[MP3]Test Banner" zoneId:@"1835884864964359712"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[MP3]Test Banner" zoneId:@"2403841388748174882"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[MP3]Test Banner" zoneId:@"599366761153263600"]];
    
    [field.arrZones addObject:[DemoEntity initWithName:@"Test Thumbnail Video Ad" zoneId:@"294420114587483581"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Operation check ad" zoneId:@"1279457025540455272"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Operation check ad 2" zoneId:@"118892334572599073"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"All Banner iOS" zoneId:@"2618194062506162593"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"All Interstitial iOS" zoneId:@"39977301260583289"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Mobile SDK] Test Video report" zoneId:@"1403870107707851166"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Home Zing MP3 iOS" zoneId:@"861162124699189737"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Adtima SDK] Test Video ads" zoneId:@"2396539284045852"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ICa] Incentivized Ad" zoneId:@"1102657093392366813"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Test Interstitial Video Ad 1" zoneId: @"456352815576990476"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"Test Interstitial Video Ad 2" zoneId: @"2247197746710137007"]];
    //1567838279598293213
    [field.arrZones addObject:[DemoEntity initWithName:@"[Android]Test banner" zoneId: @"1567838279598293213"]];
    //2037850393479182431
    [field.arrZones addObject:[DemoEntity initWithName:@"Banner Clickable" zoneId: @"2037850393479182431"]];
    //1369479217942066714
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZTV]Video Roll" zoneId: @"1369479217942066714"]];
    //1723064444989699812
    [field.arrZones addObject:[DemoEntity initWithName:@"[android]Ad Video" zoneId: @"1723064444989699812"]];

    //2541123614568578488
    [field.arrZones addObject:[DemoEntity initWithName:@"Ad  VideoSuite (test jumptarget)" zoneId: @"2541123614568578488"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[android]Ad VideoSuite" zoneId: @"1547606483963179112"]];
    //1345546277189284288
    [field.arrZones addObject:[DemoEntity initWithName:@"Test Audio Ad" zoneId: @"1345546277189284288"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Zone ZMP3";
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Interstitial Ads" zoneId:@"2247197746710137007"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Interstitial Ads" zoneId: @"2541123614568578488"]];
//    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Video Reward Ads" zoneId:@"534060550761970990"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Video Reward Ads DEV" zoneId:@"93641543234582740"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Test Ads" zoneId:@"1972595293198712230"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Video Ads" zoneId:@"1137769314325578343"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Welcome Ads" zoneId:@"2221931562209331282"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Player Ads" zoneId:@"1718658272400458569"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Test native slider" zoneId: @"1810616412720822231"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Mp3App_iOS_Dev_VideoPreroll" zoneId: @"30149011633044008"]];
    //1469322072109316189
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Test video interstitial" zoneId: @"1469322072109316189"]];
    //2645380818942783766
    [field.arrZones addObject:[DemoEntity initWithName:@"[Zing MP3]Test ad native" zoneId: @"2645380818942783766"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Zone BaoMoi";
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] PR Article Ad 1" zoneId:@"1087287385419891217"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] PR Article Ad 2" zoneId:@"1655263751952613907"]];
//    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] Unknown Article" zoneId:@"1150646704315777911"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] body ad 1" zoneId:@"1605344704280871437"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] body ad 2" zoneId:@"898129359187428082"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] body ad 3" zoneId:@"2465414516645002098"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] body ad 4" zoneId:@"1616466208561251680"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] body ad 5" zoneId:@"862453105969036200"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] adtima video ads" zoneId:@"420735420590422943"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] Welcome ads" zoneId:@"2541199532410501973"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] Native Ad Test" zoneId:@"888341253273909598"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Bao Moi] PR ad live" zoneId:@"2089022935946196574"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNEWS] Native Ad Test" zoneId:@"2631732447963215431"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[Android] Video Rollone" zoneId:@"802702573214069294"]];
    //802702573214069294
    
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Zone ZTV";
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZTV] zone video ads" zoneId:@"2515931148886440792"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZTV] zone zalo native" zoneId:@"1584491220719596975"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZTV] video roll" zoneId:@"1369479217942066714"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZTV] video roll android" zoneId:@"649356108849706950"]];
    //1313919400741914348
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZTV] masthead ad" zoneId:@"1313919400741914348"]];
    [arrList addObject:field];
    
    field = [[FieldEntity alloc] init];
    field.strName = @"Zone ZNEWS";
    //2278785676394067350
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNews] zone video ads" zoneId:@"1684918448137139611"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNews] zone welcome ads" zoneId:@"2278785676394067350"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNews] Android zone welcome ads" zoneId:@"1710749919053575572"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNews] iOS zone middle google" zoneId:@"978244079944431191"]];
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNews] iOS zone middle google 2" zoneId:@"2114282523377235627"]];
    //2115506451617641073
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNews] iOS zone video suite" zoneId:@"2115506451617641073"]];
    //651814771468235161
    [field.arrZones addObject:[DemoEntity initWithName:@"[ZNews_dev] iOS zone H5" zoneId:@"651814771468235161"]];
    [arrList addObject:field];
}

- (void)testGetVideoSuite{

}

#pragma mark - feedback delegates
- (void)onAdsFeedbackFetchSuccess:(ZAdsFeedbackData *)data{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)onAdsFeedbackFetchFail:(NSInteger)errorCode{
    NSLog(@"%s %d", __PRETTY_FUNCTION__, (int)errorCode);
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
            if (field.showDemoPauseAd) {
                [self showDemoPauseAd];
                return;
            }
        } else {
            return;
        }
        do {
            //check if zone video roll one
            DemoEntity *item = nil;
            if (field) {
                item = (DemoEntity *)[field.arrZones objectAtIndex:indexPath.row];
                if ([item.strZoneId isEqualToString:@"1938697104901239330"] ||
                    [item.strZoneId isEqualToString:@"802702573214069294"]) {
                    //show video roll one demo
                    [self showVideoRollOne:item.strZoneId];
                    break;
                }
            }
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Banner Standard 320x50", @"Banner Medium 300x250 ", @"Banner Fullpage 720x1280", @"Banner R31 300x100", @"Banner R169", @"Interstitial 720x1280 ", @"Incentivized Video", @"Video Native", @"Native Normal", @"Video Suite", @"Video Roll", nil];
            [actionSheet showInView:self.view];
            actionSheet = nil;
        } while (false);
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

#pragma mark - action sheet delegates
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DemoEntity *item = nil;
    FieldEntity *field = [arrList objectAtIndex:indexPathSelect.section];
    if (field) {
        item = [field.arrZones objectAtIndex:indexPathSelect.row];
    }
    
    switch (buttonIndex) {
        case 0:
        {
            BannerDemo *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerDemo"];
            banner.zoneId = item.strZoneId;
            banner.strType = @"1";
            [self.navigationController pushViewController:banner animated:YES];
            break;
        }
        case 1:
        {
            BannerDemo *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerDemo"];
            banner.zoneId = item.strZoneId;
            banner.strType = @"2";
            [self.navigationController pushViewController:banner animated:YES];
            break;
        }
        case 2:
        {
            BannerDemo *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerDemo"];
            banner.zoneId = item.strZoneId;
            banner.strType = @"3";
            [self.navigationController pushViewController:banner animated:YES];
            
//            [self.navigationController presentViewController:banner animated:NO completion:nil];
            
//            banner.view.frame = [UIScreen mainScreen].bounds;
//            self.viewBanner = banner;
//            [self.view addSubview:self.viewBanner.view];
            break;
        }
        case 3:
        {
            BannerDemo *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerDemo"];
            banner.zoneId = item.strZoneId;
            banner.strType = @"4";
            [self.navigationController pushViewController:banner animated:YES];
            break;
        }
        case 5:
        {
            [self showInterstitial:item.strZoneId];
            break;
        }
        case 7:
        {
            VideoViewController *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
            banner.zoneId = item.strZoneId;
            [self.navigationController pushViewController:banner animated:YES];
            break;
        }
            
        case 8:
        {
            NativeSingleViewController *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"NativeSingleViewController"];
            banner.zoneId = item.strZoneId;
            [self.navigationController pushViewController:banner animated:YES];
            break;
        }
        case 4:{
            BannerDemo *banner = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerDemo"];
            banner.zoneId = item.strZoneId;
            banner.strType = @"5";
            [self.navigationController pushViewController:banner animated:YES];
            break;
        }
        case 6:
        {
            [self showIncentivized:item.strZoneId];
            break;
        }
        case 9:
        {
            [self showVideoSuite:item.strZoneId];
            break;
        }
        case 10:
        {
            [self showVideoRoll:item.strZoneId];
            break;
        }
        default:
            break;
    }
}

- (void)showDemoPauseAd {
    @try {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DemoPauseAds *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([DemoPauseAds class])];
        
        [self.navigationController pushViewController:vc animated:NO];
    } @catch (NSException *exception) {
        
    }
}

- (void)showInterstitial:(NSString *)zoneId {
    @try {
        if (!interstitial ||
            interstitial == nil) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            interstitial = [sb instantiateViewControllerWithIdentifier:@"InterstitialScreen"];
        }
        interstitial.strZoneId = zoneId;
        
        [self.navigationController pushViewController:interstitial animated:NO];
    } @catch (NSException *exception) {
        
    }
}

- (void)showIncentivized:(NSString *)zoneId{
    @try {
        if (!incentivized ||
            incentivized == nil) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            incentivized = [sb instantiateViewControllerWithIdentifier:@"IncentivizedScreen"];
        }
        incentivized.strAdId = zoneId;
        
        [self.navigationController pushViewController:incentivized animated:NO];
//        [self.navigationController presentViewController:incentivized animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    }
}

- (void)showVideoSuite:(NSString *)zoneId{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoSuiteDemo *controller = [sb instantiateViewControllerWithIdentifier:@"VideoSuiteDemo"];
    controller.strZoneId = zoneId;
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)showVideoRoll:(NSString *)zoneId{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoRollDemo *controller = [sb instantiateViewControllerWithIdentifier:@"VideoRollDemo"];
    controller.strZoneId = zoneId;
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)showVideoRollOne:(NSString *)zoneId{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoRollOneDemo *controller = [sb instantiateViewControllerWithIdentifier:@"VideoRollOneDemo"];
    controller.strZoneId = zoneId;
    [self.navigationController pushViewController:controller animated:NO];
}

//- (void)loadIncentivizedAd{
//    [incentivized loadAdsIncentivized];
//}

#pragma mark - Orientation handling

- (BOOL)shouldAutorotate
{
    NSArray *supportedOrientationsInPlist = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    
    BOOL isPortraitSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortrait"];
    return isPortraitSupported;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return UIInterfaceOrientationIsPortrait(currentInterfaceOrientation) ? currentInterfaceOrientation : UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

//#pragma mark Delegate Incentivized
////================Delegate Incentivized======================
//
//- (void)onIncentivizedAdsLoadFinished:(NSString *)type {
//    if (incentivized.isIncentivizedAdsLoaded) {
//        [incentivized show:self];
//    }
//}
//
//- (void)onIncentivizedAdsLoadFailed:(NSInteger)errorCode {
//    NSLog(@"onIncentivizedAdsLoadFailed = %zi", errorCode);
//}
//
//-(void)onIncentivizedAdsOpened {
//    NSLog(@"onIncentivizedAdsOpened");
//}
//
//- (void)onIncentivizedAdsClosed {
//    NSLog(@"onIncentivizedAdsClosed");
//}
//
//- (void)onIncentivizedAdsLeftApplication {
//    NSLog(@"onIncentivizedAdsLeftApplication");
//}
//- (void)onIncentivizedClickPlayVideo {
//    NSLog(@"onIncentivizedClickPlayVideo");
//}
//
//- (void)onIncentivizedFinishPlayVideo {
//    NSLog(@"onIncentivizedFinishPlayVideo");
//}
//
//- (void)onIncentivizedMuteVideo:(BOOL)isMute {
//    NSLog(@"VIDEO : onIncentivizedMuteVideo");
//}
//
//- (void)onIncentivizedPauseVideo {
//    NSLog(@"onIncentivizedPauseVideo");
//}
//
//- (void)onIncentivizedAdsRewarded:(id)extras{
//    
//    id item = nil;
//    
//    if (extras &&
//        [extras isKindOfClass:[NSString class]]) {
//        item = [extras copy];
//    }
//    
//    [self performSelector:@selector(showRewarded:) withObject:item afterDelay:0.5];
//}
//
//- (void)showRewarded:(id)extras{
//    NSString *item = @"unknown";
//    if (extras &&
//        [extras isKindOfClass:[NSString class]]) {
//        item = extras;
//    }
//    NSString *message = [NSString stringWithFormat:@"rewarded %@",item];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
//    [alertView show];
//}
@end
