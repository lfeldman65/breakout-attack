//
//  GameViewController.m
//  Bowling
//
//  Created by Larry Feldman on 5/27/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController

int iAdHeight;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        iAdHeight = 66;
    }
    else {
        
        iAdHeight = 50;
    }
    
    NSError *error;
    self.backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background2" withExtension:@"wav"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];

    }
    
    self.eatURL = [[NSBundle mainBundle] URLForResource:@"eating" withExtension:@"mp3"];
    self.eatSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.eatURL error:&error];
    self.eatSoundPlayer.numberOfLoops = 0;
    
 /*   self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"h130.png"],
                                      [UIImage imageNamed:@"h130green.png"],
                                      [UIImage imageNamed:@"h130orange.png"],
                                      [UIImage imageNamed:@"h130pink.png"],
                                      nil];
    
    self.imageView.animationDuration = 1.0;
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];*/
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkGameOver:)
                                                 name:@"gameOverNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(soundChanged:)
                                                 name:@"soundDidChange"
                                               object:nil];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"wasGameLaunched"]) {
        
        NSString *infoString = @"If you dare to enter the house of terror, heed my advice. Read the instructions on the Settings screen before attempting to battle the beasts within.";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not for the Faint of Heart" message:infoString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"wasGameLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    NSString *lGS = [NSString stringWithFormat:@"Last Game: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"lastGameScore"]];
    self.lastGameLabel.text = lGS;
    
    NSString *hSS = [NSString stringWithFormat:@"High Score: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]];
    self.highScoreLabel.text = hSS;
    
    // Game Center
    
    [[GameCenterManager sharedManager] setDelegate:self];
    BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    if (available) {
        NSLog(@"available");
    } else {
        NSLog(@"not available");
    }
    
    [[GKLocalPlayer localPlayer] authenticateHandler];
    
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    self.skView = (SKView *)self.view;
    if (!self.skView.scene) {
        self.skView.showsFPS = NO;
        self.skView.showsNodeCount = NO;
    }
    
    [self.lastGameLabel setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 50)];
    self.lastGameLabel.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    self.lastGameLabel.center = CGPointMake(.34*[UIScreen mainScreen].bounds.size.width, .1*[UIScreen mainScreen].bounds.size.height);
    
    [self.highScoreLabel setFrame:CGRectMake(0, 0, .35*[UIScreen mainScreen].bounds.size.width, 50)];
    self.highScoreLabel.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    self.highScoreLabel.center = CGPointMake(.66*[UIScreen mainScreen].bounds.size.width, .1*[UIScreen mainScreen].bounds.size.height);
    
    [self.settingsButton setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 75)];
    self.settingsButton.center = CGPointMake(.1*[UIScreen mainScreen].bounds.size.width, .1*[UIScreen mainScreen].bounds.size.height);
    self.settingsButton.titleLabel.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    
    [self.startButton setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 75)];
    self.startButton.center = CGPointMake(.9*[UIScreen mainScreen].bounds.size.width, .1*[UIScreen mainScreen].bounds.size.height);
    self.startButton.titleLabel.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    
    [self.imageView setFrame:CGRectMake(0, 0, .42*[UIScreen mainScreen].bounds.size.width, .42*[UIScreen mainScreen].bounds.size.width)];
    self.imageView.center = CGPointMake(.5*[UIScreen mainScreen].bounds.size.width, .53*[UIScreen mainScreen].bounds.size.height);
    
    [self.bgImage setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.bgImage.center = CGPointMake(.5*[UIScreen mainScreen].bounds.size.width, .5*[UIScreen mainScreen].bounds.size.height);
    
    [self.webAddress setFrame:CGRectMake(0, 0, .5*[UIScreen mainScreen].bounds.size.width, 50)];
    self.webAddress.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    self.webAddress.center = CGPointMake(.5*[UIScreen mainScreen].bounds.size.width, .94*[UIScreen mainScreen].bounds.size.height);
    
    [self.iAdOutlet setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - iAdHeight, [UIScreen mainScreen].bounds.size.width, iAdHeight)];

}

- (IBAction)startPressed:(id)sender {
    
    // Present the scene.
    
    self.startButton.hidden = YES;
    self.settingsButton.hidden = YES;
    self.imageView.hidden = YES;
    self.highScoreLabel.hidden = YES;
    self.lastGameLabel.hidden = YES;
    self.bgImage.hidden = YES;
    self.iAdOutlet.hidden = YES;
    self.webAddress.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkGameOver:)
                                                 name:@"gameOverNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(soundChanged:)
                                                 name:@"soundDidChange"
                                               object:nil];
    
    self.scene = [[GameScene alloc] initWithSize:self.skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.skView presentScene:self.scene];
    
}


- (void)checkGameOver:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"gameOverNotification"]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        self.startButton.hidden = NO;
        self.settingsButton.hidden = NO;
        
        [self.scene removeFromParent];
        [self.skView presentScene:nil];
        
        self.imageView.hidden = NO;
        self.highScoreLabel.hidden = NO;
        self.lastGameLabel.hidden = NO;
        self.bgImage.hidden = NO;
        self.iAdOutlet.hidden = NO;
        self.webAddress.hidden = NO;
        
        NSInteger lastGame = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastGameScore"];
        
        //   NSLog(@"last game = %ld", (long)lastGame);
        
        NSString *lastGameString = [NSString stringWithFormat:@"Last Game: %ld", (long)lastGame];
        self.lastGameLabel.text = lastGameString;
        
        NSInteger best = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
        
        if (lastGame > best) {
            
            NSString *highScoreString = [NSString stringWithFormat:@"High Score: %ld", (long)lastGame];
            self.highScoreLabel.text = highScoreString;
            
            [[NSUserDefaults standardUserDefaults] setInteger:lastGame forKey:@"highScore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[GameCenterManager sharedManager] saveAndReportScore:(int)lastGame leaderboard:@"mostMonstersKilled1" sortOrder:GameCenterSortOrderHighToLow];
            
        }
        
        if (lastGame > 100 && lastGame <= 250) {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"100Monsters" percentComplete:100 shouldDisplayNotification:YES];
        }
        
        if (lastGame > 250 && lastGame <= 500) {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"250Monsters" percentComplete:100 shouldDisplayNotification:YES];  // achievement name is wrong.
        }
        
        if (lastGame > 500 && lastGame <= 1000) {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"500Monsters" percentComplete:100 shouldDisplayNotification:YES];
        }
        
        if (lastGame > 1000) {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"1000Monsters" percentComplete:100 shouldDisplayNotification:YES];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
            
            [self.eatSoundPlayer prepareToPlay];
            [self.eatSoundPlayer play];
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(soundChanged:)
                                                     name:@"soundDidChange"
                                                   object:nil];
        
        
    }
}

- (void)soundChanged:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"soundDidChange"]) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
            
            [self.backgroundMusicPlayer prepareToPlay];
            [self.backgroundMusicPlayer play];
            
        } else {
            
            [self.backgroundMusicPlayer stop];
        }
    }
}

-(void)settingsDidFinish:(SettingsViewController *)controller {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"fullVersion"]) {
        self.iAdOutlet.hidden = YES;
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toSettings"]){
        SettingsViewController *svc = (SettingsViewController *)[segue destinationViewController];
        svc.delegate = self;
    }
    
}



# pragma mark - Game Center


- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
    NSLog(@"GC Availabilty: %@", availabilityInformation);
    if ([[availabilityInformation objectForKey:@"status"] isEqualToString:@"GameCenter Available"]) {
        
        NSLog(@"Game Center is online, the current player is logged in, and this app is setup.");
        
    } else {
        
     //   NSLog(@"error here1");
    }
    
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error {
    NSLog(@"GCM Error: %@", error);
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Achievement: %@", achievement);
    } else {
        NSLog(@"GCM Error while reporting achievement: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Score: %@", score);
    } else {
        NSLog(@"GCM Error while reporting score: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score {
    NSLog(@"Saved GCM Score with value: %lld", score.value);
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement {
    NSLog(@"Saved GCM Achievement: %@", achievement);
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (gameCenterViewController.viewState == GKGameCenterViewControllerStateAchievements) {
        NSLog(@"Displayed GameCenter achievements.");
    } else if (gameCenterViewController.viewState == GKGameCenterViewControllerStateLeaderboards) {
        NSLog(@"Displayed GameCenter leaderboard.");
    } else {
        NSLog(@"Displayed GameCenter controller.");
    }
}

-(void) showLeaderboard {
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
}

- (void) loadChallenges {
    // This feature is only supported in iOS 6 and higher (don't worry - GC Manager will check for you and return NIL if it isn't available)
    [[GameCenterManager sharedManager] getChallengesWithCompletion:^(NSArray *challenges, NSError *error) {
        NSLog(@"GC Challenges: %@ | Error: %@", challenges, error);
    }];
}

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}


#pragma mark - iAd

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"fullVersion"]) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [banner setAlpha:1];
        [UIView commitAnimations];
      //  NSLog(@"here");
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
