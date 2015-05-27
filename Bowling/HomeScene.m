//
//  HomeScene.m
//  Bowling
//
//  Created by Larry Feldman on 5/27/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "HomeScene.h"
#import "GameScene.h"

@implementation HomeScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        //  SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        //  background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        //  [self addChild:background];
        
        // 1
        
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        SKLabelNode *gcNode = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        SKLabelNode *playNode = [SKLabelNode labelNodeWithFontNamed:@"Arial"];

        gcNode.name = @"gameCenterNode";
        playNode.name = @"playNode";

        NSInteger lastScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastGameScore"];
        NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];

        NSString *scoreString = [NSString stringWithFormat:@"Last Score: %li", lastScore];
        NSString *highScoreString = [NSString stringWithFormat:@"High Score: %li", highScore];

        if (lastScore > highScore) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:lastScore forKey:@"highScore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            highScoreString = [NSString stringWithFormat:@"High Score: %li", lastScore];
            
        //    [[GameCenterManager sharedManager] saveAndReportScore:(int)lastGame leaderboard:@"mostMonstersKilled1" sortOrder:GameCenterSortOrderHighToLow];
        }
    
        gameOverLabel.fontSize = 30;
        highScoreLabel.fontSize = 30;
        gcNode.fontSize = 30;
        playNode.fontSize = 30;

        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+40);
        gcNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+80);
        playNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+120);

        gameOverLabel.text = scoreString;
        highScoreLabel.text = highScoreString;
        gcNode.text = @"Game Center";
        playNode.text = @"Play";
        
        [self addChild:gameOverLabel];
        [self addChild:highScoreLabel];
        [self addChild:gcNode];
        [self addChild:playNode];


    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /*  GameScene* gameScene = [[GameScene alloc] initWithSize:self.size];
    [self.view presentScene:gameScene];*/
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"gameCenterNode"]) {

        [self gameCenter];

    }
    
    if ([node.name isEqualToString:@"playNode"]) {
        
        GameScene* gameScene = [[GameScene alloc] initWithSize:self.size];
        [self.view presentScene:gameScene];
        
    }
}

- (void)gameCenter {
    
    NSLog(@"GC");
    
}


@end
