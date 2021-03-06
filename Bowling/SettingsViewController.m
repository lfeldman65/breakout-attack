//
//  SettingsViewController.m
//  Bowling
//
//  Created by Larry Feldman on 5/27/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "SettingsViewController.h"
#import "Shop.h"

@interface SettingsViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UIButton *gcButton;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;
@property (nonatomic) Shop *ourNewShop;

- (IBAction)soundSwitched:(id)sender;
- (IBAction)gameCenterPressed:(id)sender;
- (IBAction)fullVersionPressed:(id)sender;

@end

@implementation SettingsViewController


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    float sWidth = [UIScreen mainScreen].bounds.size.width;
    float sHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self.backButton setFrame:CGRectMake(0, 0, .3*sWidth, .1*sHeight)];
    self.backButton.center = CGPointMake(.11*sWidth, .11*sHeight);
    self.backButton.titleLabel.font = [UIFont fontWithName: @"Noteworthy" size: .06*sWidth];
    
    [self.soundLabel setFrame:CGRectMake(.6*sWidth, .06*sHeight, .23*sWidth, .1*sHeight)];
    [[self soundLabel] setFont:[UIFont fontWithName:@"Noteworthy" size:.06*sWidth]];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        [self.soundSwitch setFrame:CGRectMake(.79*sWidth, .1*sHeight, .23*sWidth, .1*sHeight)];
        
    }
    else {
        
        [self.soundSwitch setFrame:CGRectMake(.79*sWidth, .085*sHeight, .23*sWidth, .1*sHeight)];
        
    }
    
    [self.textView setFrame:CGRectMake(0, 0, .91*sWidth, .62*sHeight)];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        self.textView.font = [UIFont fontWithName: @"Noteworthy" size: .04*sWidth];
        self.textView.center = CGPointMake(.5*sWidth, .5*sHeight);

    }
    else {
        
        if(sHeight==480) {
        
            self.textView.font = [UIFont fontWithName: @"Noteworthy" size: .043*sWidth];
            self.textView.center = CGPointMake(.5*sWidth, .48*sHeight);
            
        } else {
            
            self.textView.font = [UIFont fontWithName: @"Noteworthy" size: .05*sWidth];
            self.textView.center = CGPointMake(.5*sWidth, .48*sHeight);
        }
    }
    
    [self.fullButton setFrame:CGRectMake(0, 0, .4*sWidth, 50)];
    self.fullButton.center = CGPointMake(.5*sWidth, .75*sHeight);
    self.fullButton.titleLabel.font = [UIFont fontWithName: @"Noteworthy" size: .07*sWidth];
    
    [self.gcButton setFrame:CGRectMake(0, 0, sWidth/2, .1*sHeight)];
    self.gcButton.center = CGPointMake(sWidth/2, .9*sHeight);
    [self.gcButton.titleLabel setFont:[UIFont systemFontOfSize:.06*sWidth]];
    self.gcButton.layer.cornerRadius = .3*self.gcButton.layer.frame.size.height;
    self.gcButton.layer.masksToBounds = YES;

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        
        self.soundSwitch.on = true;
        
    } else {
        
        self.soundSwitch.on = false;
    }
}


- (IBAction)backPressed:(id)sender {
    
    [self.delegate settingsDidFinish:self];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

}


- (IBAction)soundSwitched:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isSoundOn"];
        
    }
    
    else {
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isSoundOn"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  /*  [[NSNotificationCenter defaultCenter]
     postNotificationName:@"soundDidChange"
     object:self];*/
    
}

- (IBAction)gameCenterPressed:(id)sender {
    
    
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];

    
}

- (IBAction)fullVersionPressed:(id)sender {
    
    
    [self.ourNewShop validateProductIdentifiers];
    
}


- (Shop *)ourNewShop {
    
    if (!_ourNewShop) {
        _ourNewShop = [[Shop alloc] init];
        _ourNewShop.delegate = self;
    }
    return _ourNewShop;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            [self.ourNewShop makeThePurchase];
            break;
            
        }
            
        case 1: {
            [self.ourNewShop restoreThePurchase];
            break;
            
        }
            
        default: {
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
