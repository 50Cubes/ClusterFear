//
//  SGSplatter.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGSplatter.h"

@implementation SGSplatter

+(NSString *)casingPath
{
    return CCRANDOM_MINUS1_1() >= 0.0f ? @"blood_splatter1_medium.png" : @"blood_splatter2_medium.png";
}

+(SGSplatter *)splatterFromProjectile:(SGProjectile *)projectile andIntensity:(float)intensity
{
    SGSplatter *newSplat = (SGSplatter *)[self casingForProjectile:projectile];
    
//    CGFloat oldX = newSplat->
    
    return newSplat;
}

-(void)onEnter
{
    [self setScale:0.05f];
    [super onEnter];
    
    [self runAction:[CCScaleTo actionWithDuration:0.87f scale:1.0f]];
}

@end
