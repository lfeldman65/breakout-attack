//
//  GameOverScene.m
//  Bowling
//
//  Created by Larry Feldman on 5/27/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size playerWon:(BOOL)isWon
{
    self = [super initWithSize:size];
    if (self) {
      //  SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
      //  background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
      //  [self addChild:background];
        
        // 1
        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 42;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        if (isWon) {
            gameOverLabel.text = @"Game Won";
        } else {
            gameOverLabel.text = @"Game Over";
        }
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
