//
//  SGSplatter.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGSplatter.h"

#define kSGSplatterThreshold 0.1f
#define kSGSplatterDelay 0.07f

@implementation SGSplatter

+(NSString *)casingPath
{
    return CCRANDOM_MINUS1_1() >= 0.0f ? @"blood_splatter1_medium.png" : @"blood_splatter2_medium.png";
}

+(float)fadeScale
{
    return 0.24f;
}

+(SGSplatter *)splatterFromProjectile:(SGProjectile *)projectile andIntensity:(float)intensity
{
    SGSplatter *newSplat = (SGSplatter *)[self casingForProjectile:projectile];
    
//    CGFloat oldX = newSplat->
    newSplat->bounciness_ = intensity;
    
    return newSplat;
}

-(CGPoint)findPrimaryDirection
{
    return ccpMult([self forwardDirection], [self ejectionIntensity]);
}

-(void)splatter
{
    SGSplatter *splatter = [[self class] splatterFromProjectile:[self projectile] andIntensity:bounciness_ * 0.5f];
    
    [self addChild:splatter];
    
    if( bounciness_ <= kSGSplatterThreshold )
    {
        [self unschedule:@selector(splatter)];
    }
}

-(void)onEnter
{
    [super onEnter];
    
    [self schedule:@selector(splatter) interval:0.17f repeat:kCCRepeatForever delay:0.07f];
    
    [self runAction:[CCFadeOut actionWithDuration:1.27f]];
}

@end
