//
//  GameScene.h
//  Bowling
//

//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene<SKPhysicsContactDelegate>

@property (strong, nonatomic) NSTimer *swipeTimer;
@property (nonatomic) CGPoint firstPoint;
@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint shotVectorUnit;

@property (nonatomic) float ballVelocityX;
@property (nonatomic) float ballVelocityY;

@end
