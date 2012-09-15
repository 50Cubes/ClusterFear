//
//  CCSprite+Convenience.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite+Convenience.h"

@implementation CCSprite (Convenience)

-(CGPoint)forwardDirection
{
    return ccpForAngle(CC_DEGREES_TO_RADIANS(rotation_));
}

@end
