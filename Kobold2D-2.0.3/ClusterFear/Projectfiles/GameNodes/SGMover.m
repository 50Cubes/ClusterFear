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

@end

@implementation SGMover

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    health -= [weapon damageInflicted];
    if(health <= 0){
        [self die];
    }
}

-(void)die{
    
}


-(void)facePoint:(CGPoint)pointToFace
{
    
}

-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection
{
    float rotation = atan2f(normalizedRelativeDirection.y,-normalizedRelativeDirection.x);
    
    rotation = CC_RADIANS_TO_DEGREES(rotation);
    if( rotation != rotation_ )
    {
        [self setRotation:rotation];
        //        NSLog(@"Rotated to %f degress with x: %f y: %f", CC_RADIANS_TO_DEGREES(rotation), xDirection, yDirection);
    }
}

-(void)moveToPoint:(CGPoint)targetPoint
{
    float xDirection = targetPoint.x;
    float yDirection = targetPoint.y;
    
    xDirection -= position_.x;
    yDirection -= position_.y;
    
    if( isnan(xDirection) || isnan(yDirection) )
        NSLog(@"Invalid position");
    
    float magnitude = sqrtf(xDirection * xDirection + yDirection * yDirection);
    
    xDirection /= magnitude;
    yDirection /= magnitude;
    
    [self faceRelativePoint:CGPointMake(xDirection, yDirection)];
    
    [self runAction:[CCMoveTo actionWithDuration:0.5f position:targetPoint]];
}


#pragma mark initialization

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth{
    SGMover *m = [self spriteWithFile:file];
    [m initializeHealth:startingHealth];
    return m;
}

-(void)initializeHealth:(int)newHealth{
    health = newHealth;
}



@end
