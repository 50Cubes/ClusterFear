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
    return @"rock.png";
}

+(SGObstacle *)obstacle
{
    return [self spriteWithFile:[self filePath]];
}

@end
