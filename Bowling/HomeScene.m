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
        NSInteger lastScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastGameScore"];
        NSString *scoreString = [NSString stringWithFormat:@"Score: %li", lastScore];
        gameOverLabel.fontSize = 42;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        gameOverLabel.text = scoreString;
        [self addChild:gameOverLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.size];
    // 2
    [self.view presentScene:gameScene];
}


@end
