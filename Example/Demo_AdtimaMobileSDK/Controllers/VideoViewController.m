//
//  VideoViewController.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by anhnt5 on 3/7/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController ()
{
    MPMoviePlayerController *theMoviPlayer;
    NSTimer *playbackTimer;
    BOOL isPlaying;
    BOOL hasPlayerStarted;
    NSTimeInterval movieDuration;
    NSTimeInterval playedSeconds;
    NSTimer *videoLoadTimeoutTimer;
    BOOL isResume;
}
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    theMoviPlayer = [[MPMoviePlayerController alloc] init];
    [theMoviPlayer setFullscreen:YES animated:YES];
    theMoviPlayer.controlStyle = MPMovieControlStyleNone;
    theMoviPlayer.view.frame = CGRectMake(0, 64, self.view.frame.size.width, 350);
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, theMoviPlayer.view.frame.size.width, theMoviPlayer.view.frame.size.height);
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(clickVideo) forControlEvents:UIControlEventTouchUpInside];
    [theMoviPlayer.view addSubview:btn];
    
    [self.view addSubview:theMoviPlayer.view];
    theMoviPlayer.view.hidden = YES;
    
    if (!self.nativeVideo) {
        self.nativeVideo = [[ZAdsVideo alloc] init];
    }
    self.nativeVideo.delegate = self;
    [self.nativeVideo setZoneId:self.zoneId];
    self.nativeVideo.adsTag = @"11111";
    
    [self.nativeVideo addAdsTargeting:@"category_id" value:@"11111"];
    [self.nativeVideo addAdsTargeting:@"category_name" value:@"News Category"];
    [self.nativeVideo addAdsTargeting:@"song_id" value:@"22222"];
    [self.nativeVideo addAdsTargeting:@"song_name" value:@"Song Name"];
    [self.nativeVideo addAdsTargeting:@"album_id" value:@"33333"];
    [self.nativeVideo addAdsTargeting:@"album_name" value:@"Album Name"];
    
    [self.nativeVideo addAdsTargeting:@"artist_id" value:@"44444"];
    [self.nativeVideo addAdsTargeting:@"artist_name" value:@"Artist Name"];
    
    [self.nativeVideo setAdsContentUrl:@"http://www.baomoi.com/nhung-pha-xu-ly-an-tuong-cua-ronaldo-nam-2016/r/21129105.epi"];
    [self.nativeVideo setContentId:@"http://adtima.vn"];
    
    [self.nativeVideo loadAdsVideo];
    [self.nativeVideo registerAdsInteraction:theMoviPlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieDuration:)
                                                 name:MPMovieDurationAvailableNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChangeNotification:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieSourceType:)
                                                 name:MPMovieSourceTypeAvailableNotification
                                               object:nil];
    
    [self.btnPause setTitle:@"Pause" forState:UIControlStateNormal];
}


- (IBAction)playVideo:(id)sender {
    [self.nativeVideo haveAdsInventory];
    if (self.nativeVideo.isVideoAdsLoaded) {
        @try {
            playedSeconds = 0.0;
            // Create and prepare the player to confirm the video is playable (or not) as early as possible
            NSURL *urlString=[NSURL URLWithString:self.nativeVideo.getAdsMediaUrl];
            theMoviPlayer.contentURL = urlString;
            theMoviPlayer.view.hidden = NO;
            [theMoviPlayer prepareToPlay];
        }
        @catch (NSException *e) {
            return;
        }
    }
}

- (void)clickVideo {
    [self pauseVideo:nil];
    [self.nativeVideo doAdsClick:self.nativeVideo.getAdsMediaUrl];
}

#pragma mark - MPMoviePlayerController notifications

- (void)playbackStateChangeNotification:(NSNotification *)notification
{
    @synchronized (self) {
        MPMoviePlaybackState state = [theMoviPlayer playbackState];
        
        switch (state) {
            case MPMoviePlaybackStateStopped:  // 0
                break;
            case MPMoviePlaybackStatePlaying:  // 1
                isPlaying=YES;
                [self startPlaybackTimer];
                break;
            case MPMoviePlaybackStatePaused:  // 2
                [self stopPlaybackTimer];
                isPlaying=NO;
                break;
            case MPMoviePlaybackStateInterrupted:  // 3
                break;
            case MPMoviePlaybackStateSeekingForward:  // 4
                break;
            case MPMoviePlaybackStateSeekingBackward:  // 5
                break;
            default:
                break;
        }
    }
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notification
{
    if ((theMoviPlayer.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK )
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        [self showAndPlayVideo];
    }
}

- (void)showAndPlayVideo
{
    [theMoviPlayer play];
    hasPlayerStarted=YES;
    
    [self.nativeVideo doAdsDisplay:self.nativeVideo.getAdsMediaUrl];
    
    [self.nativeVideo doAdsStart:self.nativeVideo.getAdsMediaUrl];
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    @synchronized(self) {
        [self updatePlayedSeconds];
        [self.nativeVideo doAdsComplete:self.nativeVideo.getAdsMediaUrl];
    }
}

- (void)movieDuration:(NSNotification *)notification
{
    @try {
        movieDuration = theMoviPlayer.duration;
    }
    @catch (NSException *e) {
    }
    if (movieDuration < 0.5 || isnan(movieDuration)) {
        [self close];
    }
}

- (void)close
{
    @synchronized (self) {
        [theMoviPlayer stop];
        
        theMoviPlayer = nil;
        
        [self.nativeVideo doAdsClose:self.nativeVideo.getAdsMediaUrl];
    }
}

- (void)movieSourceType:(NSNotification *)notification
{
    MPMovieSourceType sourceType;
    @try {
        sourceType = theMoviPlayer.movieSourceType;
    }
    @catch (NSException *e) {
        // sourceType is used for info only - any player related error will be handled otherwise, ultimately by videoTimeout, so no other action needed here.
    }
}

- (void)startPlaybackTimer
{
    @synchronized (self) {
        [self stopPlaybackTimer];
        playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                         target:self
                                                       selector:@selector(updatePlayedSeconds)
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

- (void)updatePlayedSeconds
{
    @try {
        playedSeconds = theMoviPlayer.currentPlaybackTime;
        [self.nativeVideo doAdsProgressByTimeWithUrl:self.nativeVideo.getAdsMediaUrl withSecond:playedSeconds withDuration:movieDuration];
    }
    @catch (NSException *e) {
        // The hang test below will fire if playedSeconds doesn't update (including a NaN value), so no need for further action here.
    }
}

- (BOOL)isPlaying{
    return isPlaying;
}

- (void)stopPlaybackTimer {
    [playbackTimer invalidate];
    playbackTimer = nil;
}

- (IBAction)pauseVideo:(id)sender {
    if (isResume) {
        [self.btnPause setTitle:@"Pause" forState:UIControlStateNormal];
        [self handleResumeState];
        isResume = NO;
    } else {
        [self.btnPause setTitle:@"Resume" forState:UIControlStateNormal];
        isResume = YES;
        [self handlePauseState];
    }
}

- (IBAction)replay:(id)sender {
    [self handleResumeState];
}

- (void)handlePauseState
{
    @synchronized (self) {
        if (isPlaying) {
            [theMoviPlayer pause];
            isPlaying = NO;
            [self.nativeVideo doAdsPause:self.nativeVideo.getAdsMediaUrl];
        }
        [self stopPlaybackTimer];
    }
}

- (void)handleResumeState
{
    @synchronized (self) {
        if (hasPlayerStarted) {
            if (isResume) {
                // resuming from background or phone call, so resume if was playing, stay paused if manually paused by inspecting controls state
                [theMoviPlayer play];
                isPlaying = YES;
                [self.nativeVideo doAdsResume:self.nativeVideo.getAdsMediaUrl];
                [self startPlaybackTimer];
            } else if (theMoviPlayer) {
                [self showAndPlayVideo];   // Edge case: loadState is playable but not playThroughOK and had resignedActive, so play immediately on resume
            }
        }
    }
}

- (void)dealloc {
    [theMoviPlayer stop];
    theMoviPlayer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [theMoviPlayer stop];
    theMoviPlayer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieSourceTypeAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.nativeVideo dismissAds];
}
#pragma mark Delegate Banner
//================Delegate Banner======================

- (void)onVideoAdsLoadFinished:(NSString *)tag {
    if ([tag isEqualToString:self.nativeVideo.adsTag]) {
        //[self.nativeVideo doAdsEvent];
        NSLog(@"getAdsRawData:%@",[self.nativeVideo getAdsRawData]);
        if ([self.nativeVideo isAdsAllowSkip]) {
            NSLog(@"AD Video allow skip after %ld", [self.nativeVideo getAdsSkipAfter]);
        }
    }
}

- (void)onVideoAdsLoadFailed:(NSString *)tag error:(NSInteger)errorCode {
    NSLog(@"onBannerAdsLoadFailed = %zi",errorCode);
    [_nativeVideo haveAdsInventory];
}

- (void)onVideoAdsOpened:(NSString *)tag {
    //NSLog(@"onBannerAdsOpened");
}

- (void)onVideoAdsClosed:(NSString *)tag {
    //NSLog(@"onBannerAdsClosed");
}

- (void)onVideoAdsLeftApplication:(NSString *)tag {
    //NSLog(@"onBannerAdsLeftApplication");
}
@end
