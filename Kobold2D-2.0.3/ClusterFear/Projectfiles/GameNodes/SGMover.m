//
//  SGMover.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"
#import "SGWeapon.h"

@interface SGMover ()

-(void)initializeHealth:(int)newHealth;
-(void)initializeShape;

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

@synthesize movingShape;

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
    [[self owner] mover:self firedProjectile:projectile];
}

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    health -= [weapon damageInflicted];
    if(health <= 0){
        [self die];
    }
}

-(void)die{
    [self stopAllActions];
    
    [[self owner] moverPerished:self];
    
    CCFiniteTimeAction *dieSequence = [CCSequence actionOne:[CCFadeOut actionWithDuration:1.0f] two:[CCCallFunc actionWithTarget:self selector:@selector(removeFromParentAndDoCleanup)]];
    [self runAction:dieSequence];
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


#pragma mark initialization

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth{
    SGMover *m = [self spriteWithFile:file];
    [m initializeHealth:startingHealth];
    [m initializeShape];
    return m;
}

-(void)initializeHealth:(int)newHealth{
    health = newHealth;
}

-(void)initializeShape{
    movingShape = cpCircleShapeNew(cpBodyNew(25, INFINITY), 20.0, cpvzero);
    movingShape->e = 0.5;
    movingShape->u = 0.8;
    movingShape->collision_type = 1;
    movingShape->data = (__bridge void *)self;
}


-(void)removeFromParentAndDoCleanup
{
    [self removeFromParentAndCleanup:YES];
}


@end
