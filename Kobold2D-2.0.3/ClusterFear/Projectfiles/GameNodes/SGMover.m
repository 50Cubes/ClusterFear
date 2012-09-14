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

-(void)setPosition:(CGPoint)position
{
    float xDirection = position.x;
    float yDirection = position.y;
    
    xDirection -= position_.x;
    yDirection -= position_.y;
    
    float magnitude = sqrtf(xDirection * xDirection + yDirection * yDirection);
    
    xDirection /= magnitude;
    yDirection /= magnitude;
    
    float rotation = atanf((xDirection == 0) ? 0.0f : yDirection/xDirection);
    
    CCLOG(@"rotation is: %f", rotation);
    
    [super setPosition:position];
    if( rotation != rotation_ ){
        [self setRotation:CC_RADIANS_TO_DEGREES(rotation)];
    }
}

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    health -= [weapon damageInflicted];
    if(health <= 0){
        [self die];
    }
}

-(void)die{
    
}

-(void)moveToPoint:(CGPoint)targetPoint
{
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
