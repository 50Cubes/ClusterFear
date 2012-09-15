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

-(CGPoint)backwardDirection{
    return ccpForAngle(CC_DEGREES_TO_RADIANS(rotation_) + 180);
}

-(CGRect)boundingBoxInWorldSpace{
    CGRect res = CGRectZero;
    res.size = [self boundingBox].size;
    res.origin = [self convertToWorldSpace:[self boundingBox].origin];
    
    return res;
}

@end
