//
//  CCSprite+Convenience.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"

@interface CCSprite (Convenience)

-(CGPoint)forwardDirection;
-(CGPoint)backwardDirection;

-(CGRect)boundingBoxInWorldSpace;

@end
