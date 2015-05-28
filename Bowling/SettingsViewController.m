//
//  SettingsViewController.m
//  Bowling
//
//  Created by Larry Feldman on 5/27/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "SettingsViewController.h"

//#import "Shop.h"

@interface SettingsViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UIButton *gcButton;
@property (weak, nonatomic) IBOutlet UIButton *ammoButton;
//@property (nonatomic) Shop *ourNewShop;

- (IBAction)soundSwitched:(id)sender;
- (IBAction)gameCenterPressed:(id)sender;
- (IBAction)ammoPressed:(id)sender;

@end

@implementation SettingsViewController


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.backButton setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 75)];
    self.backButton.center = CGPointMake(.16*[UIScreen mainScreen].bounds.size.width, .12*[UIScreen mainScreen].bounds.size.height);
    self.backButton.titleLabel.font = [UIFont fontWithName: @"Papyrus" size: .04*[UIScreen mainScreen].bounds.size.width];
    
    [self.soundLabel setFrame:CGRectMake(0, 0, .15*[UIScreen mainScreen].bounds.size.width, 50)];
    self.soundLabel.font = [UIFont fontWithName: @"Papyrus" size: .04*[UIScreen mainScreen].bounds.size.width];
    self.soundLabel.center = CGPointMake(.43*[UIScreen mainScreen].bounds.size.width, .12*[UIScreen mainScreen].bounds.size.height);
    
    [self.soundSwitch setFrame:CGRectMake(0, 0, 51, 31)];
    self.soundSwitch.center = CGPointMake(.56*[UIScreen mainScreen].bounds.size.width, .11*[UIScreen mainScreen].bounds.size.height);
    
    [self.gcButton setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 50)];
    self.gcButton.center = CGPointMake(.82*[UIScreen mainScreen].bounds.size.width, .12*[UIScreen mainScreen].bounds.size.height);
    self.gcButton.titleLabel.font = [UIFont fontWithName: @"Papyrus" size: .04*[UIScreen mainScreen].bounds.size.width];
    
    [self.textView setFrame:CGRectMake(0, 0, .91*[UIScreen mainScreen].bounds.size.width, .62*[UIScreen mainScreen].bounds.size.height)];
    self.textView.font = [UIFont fontWithName: @"Papyrus" size: .032*[UIScreen mainScreen].bounds.size.width];
    self.textView.center = CGPointMake(.5*[UIScreen mainScreen].bounds.size.width, .5*[UIScreen mainScreen].bounds.size.height);
    
    [self.ammoButton setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 50)];
    self.ammoButton.center = CGPointMake(.5*[UIScreen mainScreen].bounds.size.width, .9*[UIScreen mainScreen].bounds.size.height);
    self.ammoButton.titleLabel.font = [UIFont fontWithName: @"Papyrus" size: .04*[UIScreen mainScreen].bounds.size.width];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        
        self.soundSwitch.on = true;
        
    } else {
        
        self.soundSwitch.on = false;
    }
}


- (IBAction)backPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)soundSwitched:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isSoundOn"];
        
    }
    
    else {
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isSoundOn"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"soundDidChange"
     object:self];
    
}

- (IBAction)gameCenterPressed:(id)sender {
    
    
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];

    
}

- (IBAction)ammoPressed:(id)sender {
    
    // instantiate
    
   // [self.ourNewShop validateProductIdentifiers];
    
}

/*
- (Shop *)ourNewShop {  // SettingsViewController is the delegate for the Shop class
    
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
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
