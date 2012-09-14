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
    
    if( isnan(xDirection) || isnan(yDirection) )
        NSLog(@"Invalid position");
    
    float magnitude = sqrtf(xDirection * xDirection + yDirection * yDirection);
    
    xDirection /= magnitude;
    yDirection /= magnitude;
    
    float rotation = atan2f(yDirection,xDirection);
    
    [super setPosition:position];
    
    if( rotation != rotation_ )
    {
        [self setRotation:CC_RADIANS_TO_DEGREES(rotation) - 90.0f];
//        NSLog(@"Rotated to %f degress with x: %f y: %f", CC_RADIANS_TO_DEGREES(rotation), xDirection, yDirection);
    }
}

@end
