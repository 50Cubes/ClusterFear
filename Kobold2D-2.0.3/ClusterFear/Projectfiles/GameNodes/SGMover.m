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


-(void)facePoint:(CGPoint)pointToFace
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
    
    xDirection /= magnitude;
    yDirection /= magnitude;
    
    [self faceRelativePoint:(CGPoint){.x=xDirection,.y=yDirection}];
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
    [self facePoint:targetPoint];
    
    [self runAction:[CCMoveTo actionWithDuration:0.5f position:targetPoint]];
}

-(void)die
{
    [[self owner] moverPerished:self];
    
    //[super die];
    [self stopAllActions];
    
    CCFiniteTimeAction *dieSequence = [CCSequence actionOne:[CCFadeOut actionWithDuration:0.5f] two:[CCCallFunc actionWithTarget:self selector:@selector(removeFromParentAndDoCleanup)]];
    [self runAction:dieSequence];
}

-(void)didDestroy:(SGDestroyable *)destroyable
{
    //yay i killed something
}

-(void)collideWithDestroyable:(SGDestroyable *)other{
    if([other respondsToSelector:@selector(weapon)]){
        SGWeapon *w = [other performSelector:@selector(weapon)];
        [self getHitFromWeapon:w];
    }else{
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
    CCAction *bounceAction = [CCSequence actionOne:[CCMoveTo actionWithDuration:0.2 position:[self backwardDirection]] two:[CCCallFunc actionWithTarget:self selector:@selector(afterBounce)]];
    [self runAction:bounceAction];
}

-(void)afterBounce{
    
}

@end
