//
//  SGRunActivator.h
//  ClusterFear
//
//  Created by Lev Trubov on 9/14/12.
//
//

#import "CCLayer.h"

@interface SGRunActivator : CCLayer
{
    float offset;
}

+(SGRunActivator *)activatorWithOffset:(float)offset;

-(void)setup;

@property(readonly) BOOL isPressed;


@end
