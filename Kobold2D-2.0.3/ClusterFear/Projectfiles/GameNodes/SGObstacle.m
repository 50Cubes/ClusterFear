//
//  SGObstacle.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGObstacle.h"

@implementation SGObstacle

+(NSString *)filePath
{
    return CCRANDOM_MINUS1_1() < 0.9f ? @"rock.png" : @"chemical_spill.png" ;
}

+(SGObstacle *)obstacle
{
    SGObstacle *newObst = [self spriteWithFile:[self filePath]];
    
    [newObst setRotation:35.0f * CCRANDOM_MINUS1_1()];
    
    return newObst;
}

@end
