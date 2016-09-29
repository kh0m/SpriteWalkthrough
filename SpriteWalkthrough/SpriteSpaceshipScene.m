//
//  SpriteSpaceshipScene.m
//  SpriteWalkthrough
//
//  Created by Ken Hom on 6/7/14.
//  Copyright (c) 2014 Ken Hom. All rights reserved.
//

#import "SpriteSpaceshipScene.h"

@interface SpriteSpaceshipScene ()

@property BOOL contentCreated;

@end


@implementation SpriteSpaceshipScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // new spaceship
    SKSpriteNode *spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    [self addChild:spaceship];
    
    // add some rocks
    SKAction *makeRocks = [SKAction sequence:@[
                                               [SKAction performSelector:@selector(addRock) onTarget:self],
                                               [SKAction waitForDuration:0.10 withRange:0.15]
                                               ]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
}

- (SKSpriteNode *)newSpaceship
{
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    
    // physics
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    
    // lights
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    // hover
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:50.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100 y:-50.0 duration:1.0]
                                           ]];
    [hull runAction:[SKAction repeatActionForever:hover]];
    return hull;
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8, 8)];
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]
                                           ]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction:blinkForever];
    
    return light;
}


// stuff for random number creation
static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addRock
{
    // alloc and init
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8, 8)];
    // position with random x
    rock.position = CGPointMake(skRand(0, self.size.width),self.size.height - 50);
    // name
    rock.name = @"rock";
    // physics body
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    // physics detection
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    // add as child to self
    [self addChild:rock];
}

// for rocks that drop off the scene
- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop){
        if (node.position.y < 0) {
            [node removeFromParent];
        }
    }];
}


@end







