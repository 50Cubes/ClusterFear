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

//-(void)setPosition:(CGPoint)position
//{
//    float xDirection = position.x;
//    float yDirection = position.y;
//    
//    xDirection -= position_.x;
//    yDirection -= position_.y;
//    
//    if( isnan(xDirection) || isnan(yDirection) )
//        NSLog(@"Invalid position");
//    
//    float magnitude = sqrtf(xDirection * xDirection + yDirection * yDirection);
//    
//    xDirection /= magnitude;
//    yDirection /= magnitude;
//    
//    float rotation = atan2f(yDirection,-xDirection);
//    
//    CCLOG(@"rotation is: %f with yDIrection %f xDir %f", rotation, xDirection, yDirection);
//    
////    [super setPosition:position];
//    
//    rotation = CC_RADIANS_TO_DEGREES(rotation) - 90.0f;
//    if( rotation != rotation_ )
//    {
//        [self setRotation:rotation];
////        NSLog(@"Rotated to %f degress with x: %f y: %f", CC_RADIANS_TO_DEGREES(rotation), xDirection, yDirection);
//    }
//}

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
    
    [super die];
}

-(void)didDestroy:(SGDestroyable *)destroyable
{
    //yay i killed something
}

#pragma mark initialization

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth{
    SGMover *m = [self spriteWithFile:file];
    [m initializeHealth:startingHealth];
    return m;
}

@end
