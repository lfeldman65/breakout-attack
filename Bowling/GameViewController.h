//
//  GameViewController.h
//  Bowling
//

//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "SettingsViewController.h"


@interface GameViewController : UIViewController <GameCenterManagerDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, strong) AVAudioPlayer * backgroundMusicPlayer;
@property (nonatomic, strong) AVAudioPlayer * eatSoundPlayer;

@property (nonatomic, strong) SKScene *scene;
@property (nonatomic, strong) SKView *skView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UILabel *lastGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) NSURL *backgroundMusicURL;
@property (strong, nonatomic) NSURL *eatURL;
@property (weak, nonatomic) IBOutlet ADBannerView *iAdOutlet;

@property (weak, nonatomic) IBOutlet UILabel *webAddress;

@property (nonatomic, assign) BOOL bannerIsVisible;
@property (strong, nonatomic) ADBannerView *adView;

@end
