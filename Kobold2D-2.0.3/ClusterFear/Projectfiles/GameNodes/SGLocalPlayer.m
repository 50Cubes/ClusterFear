//
//  SGLocalPlayer.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGLocalPlayer.h"

@implementation SGLocalPlayer

-(void)moveToPoint:(CGPoint)targetPoint
{
    [self runAction:[CCMoveTo actionWithDuration:0.5f position:targetPoint]];
}

@end
