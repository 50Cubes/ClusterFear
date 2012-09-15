//
//  SGMover.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"
#import "SGWeapon.h"

#import "SGProjectile.h"

#import "SGSplatter.h"

@interface SGMover ()

@end

@implementation SGMover

+(float)speed
{
    return 50.0f;
}

-(BOOL)isEnemy
{
    return YES;
}

-(void)fireProjectile:(SGProjectile *)projectile
{
    [projectile setPosition:position_];
    [projectile setRotation:rotation_];
    
    [[self owner] mover:self firedProjectile:projectile];
}


-(float)facePoint:(CGPoint)pointToFace
{
    float xDirection = pointToFace.x;
    float yDirection = pointToFace.y;
    
    xDirection -= position_.x;
    yDirection -= position_.y;
    
#ifdef DEBUG
    if( isnan(xDirection) || isnan(yDirection) )
        NSLog(@"Invalid position");
#endif
    
    float magnitude = sqrtf(xDirection * xDirection + yDirection * yDirection);
    
    float normXDirection = xDirection / magnitude;
    float normYDirection = yDirection / magnitude;
    
    [self faceRelativePoint:(CGPoint){.x=normXDirection,.y=normYDirection}];
    
    return magnitude;
//    return (CGPoint){.x=xDirection, .y=yDirection};
}

-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection
{
    float rotation = atan2f(normalizedRelativeDirection.y,-normalizedRelativeDirection.x);
    
    rotation = CC_RADIANS_TO_DEGREES(rotation);
    if( rotation != rotation_ )
    {
        //[self setRotation:rotation];
        //        NSLog(@"Rotated to %f degress with x: %f y: %f", CC_RADIANS_TO_DEGREES(rotation), xDirection, yDirection);
        [self runAction:[CCRotateTo actionWithDuration:0.2 angle:rotation]];
    }
}

-(void)moveToPoint:(CGPoint)targetPoint
{
    float distance = [self facePoint:targetPoint];
    
    ccTime moveTime = 1.0f;
    
    float mySpeed = [[self class] speed];
    
    
    velocity_ = distance / moveTime;
    
    if( velocity_ > mySpeed )
    {
        moveTime *= (velocity_ / mySpeed);
        velocity_ = mySpeed;
    }
    
    [self runAction:[CCMoveTo actionWithDuration:moveTime position:targetPoint]];
}

-(void)moveByAmount:(CGPoint)movementVector
{
    [self moveToPoint:ccpAdd(position_, movementVector)];
}

-(void)die
{
    [[self owner] moverPerished:self];
    
    //[super die];
    [self stopAllActions];
    
    //CCFiniteTimeAction *dieSequence = [CCSequence actionOne:[CCFadeOut actionWithDuration:0.5f] two:[CCCallFunc actionWithTarget:self selector:@selector(removeFromParentAndDoCleanup)]];
    //[self runAction:dieSequence];
    [self removeFromParentAndDoCleanup];
}

-(void)didDestroy:(SGDestroyable *)destroyable
{
    //yay i killed something
}

-(void)collideWithDestroyable:(SGDestroyable *)other{
    //return;
    if([other respondsToSelector:@selector(weapon)]){
        SGWeapon *w = [other performSelector:@selector(weapon)];
        [self getHitFromWeapon:w];
    }else{
        //return;

        health_ -= [other damage];
        
        [self stopAllActions];
        
        if(health_ <= 0){
            [self die];
        }else{
            [healthLabel setString:[NSString stringWithFormat:@"%d", health_]];
        }
    }
}

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    if([[weapon owner] isEqual:self]){
        return;
    }
    [super getHitFromWeapon:weapon];
    if(health_ > 0){
        [healthLabel setString:[NSString stringWithFormat:@"%d", health_]];
    }
}

#pragma mark initialization

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth{
    SGMover *m = [self spriteWithFile:file];
    [m initializeHealth:startingHealth];
    return m;
}

-(void)initializeHealth:(int)health{
    [super initializeHealth:health];
    healthLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", health_]
                                   dimensions:CGSizeMake(64, 24)
                                   hAlignment:kCCTextAlignmentCenter
                                lineBreakMode:kCCLineBreakModeWordWrap
                                     fontName:@"Arial"
                                     fontSize:24];
    healthLabel.position = CGPointMake(0, 0);
    healthLabel.color = ccRED;
    [self addChild:healthLabel];
}

#pragma mark - collision

-(void)bounce{
    CCAction *bounceAction = [CCSequence actionOne:[CCMoveBy actionWithDuration:0.2 position:[self backwardDirection]] two:[CCCallFunc actionWithTarget:self selector:@selector(afterBounce)]];
    [self runAction:bounceAction];
}

-(void)afterBounce{
    
}

@end
