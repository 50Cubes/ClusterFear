//
//  SGMover.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"

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
    
    float rotation = atanf(yDirection/xDirection);
    
    [super setPosition:position];
    if( rotation != rotation_ )
        [self setRotation:rotation];
}

@end
