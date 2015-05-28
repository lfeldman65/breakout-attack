//
//  GameScene.m
//  Bowling
//
//  Created by Larry Feldman on 5/27/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "GameScene.h"

static NSString* ballCategoryName = @"ball";
static NSString* paddleCategoryName = @"paddle";
static NSString* blockCategoryName = @"block";
static NSString* blockNodeCategoryName = @"blockNode";
static NSString* superBlockCategoryName = @"superBlockNode";

static const uint32_t ballCategory  = 0x1 << 0;
static const uint32_t bottomCategory = 0x1 << 1;
static const uint32_t blockCategory = 0x1 << 2;
static const uint32_t paddleCategory = 0x1 << 3;
static const uint32_t superBlockCategory = 0x1 << 4;


@interface GameScene()

@property (nonatomic) BOOL isFingerOnPaddle;

@end


@implementation GameScene

@synthesize paddle;
@synthesize ball;
@synthesize block;
@synthesize bottom;

NSInteger blocksHit;

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
    //    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
    //    background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //    [self addChild:background];
        NSLog(@"init");
        blocksHit = 0;
        self.blockTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(addRowOfBlocks) userInfo:nil repeats:YES];
        
         self.superBlockTimer = [NSTimer scheduledTimerWithTimeInterval:13.0 target:self selector:@selector(addSuperBlock) userInfo:nil repeats:YES];
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, -1.0f);
        
        // 1 Create an physics body that borders the screen
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody;
        // 3 Set the friction of that physicsBody to 0
        self.physicsBody.friction = 0.0f;
        
        // 1
        ball = [SKSpriteNode spriteNodeWithImageNamed: @"ball.png"];
        ball.name = ballCategoryName;
        ball.position = CGPointMake(0.5*self.frame.size.width, 0.7*self.frame.size.height);
        [self addChild:ball];
        
        // 2
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
        // 3
        ball.physicsBody.friction = 0.0f;
        // 4
        ball.physicsBody.restitution = 1.1f;
        // 5
        ball.physicsBody.linearDamping = 0.0f;
        // 6
        ball.physicsBody.allowsRotation = NO;
        
        ball.physicsBody.affectedByGravity = YES;
        
        
        // To do: random impulse vector
        
        [ball.physicsBody applyImpulse:CGVectorMake(5.0f, 15.0f)];
        
        paddle = [[SKSpriteNode alloc] initWithImageNamed: @"paddle.png"];
        paddle.name = paddleCategoryName;
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 0.8f);
        [self addChild:paddle];
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
        paddle.physicsBody.restitution = 0.1f;
        paddle.physicsBody.friction = 0.4f;
        
        // make paddle static
        paddle.physicsBody.dynamic = NO;
        
        CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        bottom = [SKNode node];
        bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
        [self addChild:bottom];
        
        bottom.physicsBody.categoryBitMask = bottomCategory;
        ball.physicsBody.categoryBitMask = ballCategory;
        paddle.physicsBody.categoryBitMask = paddleCategory;

        ball.physicsBody.contactTestBitMask = bottomCategory | blockCategory | superBlockCategory;
        
        self.physicsWorld.contactDelegate = self;
        [self addRowOfBlocks];

    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    //Called when a touch begins
    
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
     
    SKPhysicsBody *body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node.name isEqualToString: paddleCategoryName]) {
  //  NSLog(@"Began touch on paddle");
    self.isFingerOnPaddle = YES;
     
     }
}

-(void)addSuperBlock {
    
    
    SKSpriteNode *superBlock = [SKSpriteNode spriteNodeWithImageNamed:@"paddle.png"];
    
    int minX = superBlock.size.width / 2;
    int maxX = self.frame.size.width - superBlock.size.width / 2;
    int rangeX = maxX - minX;
    int actualXStart = (arc4random() % rangeX) + minX;
    
    superBlock.position = CGPointMake(actualXStart, self.frame.size.height*0.95f);
    superBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:superBlock.frame.size];
    superBlock.physicsBody.allowsRotation = NO;
    superBlock.physicsBody.friction = 0.0f;
    superBlock.physicsBody.velocity = CGVectorMake(0, -50.0);
    superBlock.name = superBlockCategoryName;
    superBlock.physicsBody.categoryBitMask = superBlockCategory;
    superBlock.physicsBody.contactTestBitMask = bottomCategory | paddleCategory;
    superBlock.physicsBody.affectedByGravity = NO;
    [self addChild:superBlock];
    
}


-(void)addRowOfBlocks {
    
    int numberOfBlocks = 3;
    int blockWidth = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"].size.width;
    float padding = 20.0f;
    // 2 Calculate the xOffset
    float xOffset = (self.frame.size.width - (blockWidth * numberOfBlocks + padding * (numberOfBlocks-1))) / 2;
    // 3 Create the blocks and add them to the scene
    for (int i = 1; i <= numberOfBlocks; i++) {
        SKSpriteNode* block2 = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"];
        block2.position = CGPointMake((i-0.5f)*block2.frame.size.width + (i-1)*padding + xOffset, self.frame.size.height*0.95f);
        block2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block2.frame.size];
        block2.physicsBody.allowsRotation = NO;
        block2.physicsBody.friction = 0.0f;
        block2.physicsBody.velocity = CGVectorMake(0, -50.0);
        block2.name = blockCategoryName;
        block2.physicsBody.categoryBitMask = blockCategory;
        block2.physicsBody.contactTestBitMask = bottomCategory | paddleCategory;
        block2.physicsBody.affectedByGravity = NO;

        [self addChild:block2];
    }

}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // 1 Check whether user tapped paddle
    if (self.isFingerOnPaddle) {
     // 2 Get touch location
     UITouch* touch = [touches anyObject];
     CGPoint touchLocation = [touch locationInNode:self];
     CGPoint previousLocation = [touch previousLocationInNode:self];
     // 3 Get node for paddle
     SKSpriteNode* paddle2 = (SKSpriteNode*)[self childNodeWithName: paddleCategoryName];
     // 4 Calculate new position along x for paddle
     int paddleX = paddle2.position.x + (touchLocation.x - previousLocation.x);
     // 5 Limit x so that the paddle will not leave the screen to left or right
     paddleX = MAX(paddleX, paddle2.size.width/2);
     paddleX = MIN(paddleX, self.size.width - paddle2.size.width/2);
     // 6 Update position of paddle
     paddle2.position = CGPointMake(paddleX, paddle2.position.y);
     }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
     self.isFingerOnPaddle = NO;

}

- (void)didBeginContact:(SKPhysicsContact*)contact {
    
    NSLog(@"collision");
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory) {

        [self gameOver];
        
    }
    
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == blockCategory) {
        [secondBody.node removeFromParent];
        blocksHit++;
        [ball.physicsBody applyImpulse:CGVectorMake(0.0f, -5.0f)];

    }
    
    if (firstBody.categoryBitMask == bottomCategory && secondBody.categoryBitMask == blockCategory) {

        [self gameOver];
        
    }
    
    if (firstBody.categoryBitMask == blockCategory && secondBody.categoryBitMask == paddleCategory) {
        
        [self gameOver];
        
    }
    
    if (firstBody.categoryBitMask == bottomCategory && secondBody.categoryBitMask == superBlockCategory) {
        
        [self gameOver];
        
    }
    
    if (firstBody.categoryBitMask == paddleCategory && secondBody.categoryBitMask == superBlockCategory) {
        
        [self gameOver];
        
    }
    
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == superBlockCategory) {
        
        [secondBody.node removeFromParent];
        [ball.physicsBody applyImpulse:CGVectorMake(0.0f, -5.0f)];

       
        for (SKNode* node in self.children) {
            if ([node.name isEqual: blockCategoryName] || [node.name isEqual: superBlockCategoryName]) {
                [node removeFromParent];
            }
        }
    }
}

-(void)gameOver {
    
    
    [self.blockTimer invalidate];
    [self.superBlockTimer invalidate];
    
    [[NSUserDefaults standardUserDefaults] setInteger:blocksHit forKey:@"lastGameScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOverNotification" object:self];
    [self.scene removeFromParent];
    [SKAction removeFromParent];
}


-(BOOL) isGameWon {
    int numberOfBricks = 0;
    for (SKNode* node in self.children) {
        if ([node.name isEqual: blockCategoryName]) {
            numberOfBricks++;
        }
    }
    return numberOfBricks <= 0;  // if numberOfBricks <= 0, return true
}

-(void)update:(CFTimeInterval)currentTime {
    
   // [ball.physicsBody applyImpulse:CGVectorMake(5.0f, 15.0f)];

    /* Called before each frame is rendered */
    SKNode* ball2 = [self childNodeWithName: ballCategoryName];
    static int maxSpeed = 800;
    float speed = sqrt(ball2.physicsBody.velocity.dx*ball2.physicsBody.velocity.dx + ball2.physicsBody.velocity.dy * ball2.physicsBody.velocity.dy);
   // NSLog(@"speed = %f",speed);

    if (speed > maxSpeed) {
        ball2.physicsBody.linearDamping = 0.8f;
    } else {
        ball2.physicsBody.linearDamping = 0.0f;
    }
}

@end
