//
//  SGSplatter.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGSplatter.h"

@implementation SGSplatter

+(SGSplatter *)splatterFromSpray:(SGSpray *)spray
{
    SGSplatter *splatter = [self spriteWithTexture:[spray texture]];
    [splatter setOpacity:128 * CCRANDOM_0_1()];
    [splatter setPosition:[spray position]];
    return splatter;
}



@end
