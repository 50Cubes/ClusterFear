//
//  CCSprite+Convenience.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite+Convenience.h"

@implementation CCNode (Convenience)

-(CGPoint)forwardDirection
{
    return ccpForAngle(CC_DEGREES_TO_RADIANS(rotation_));
}

-(CGPoint)backwardDirection{
    return ccpForAngle(CC_DEGREES_TO_RADIANS(rotation_) + 180);
}


@end
