//
//  SGSpray.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGSpray.h"
#import "SGSplatter.h"

#define kSGSprayThreshold 0.4f
#define kSGSprayDelay 0.07f

@implementation SGSpray

+(NSString *)casingPath
{
    NSUInteger size = 16;
    float seed = CCRANDOM_MINUS1_1();
    if( seed > 0.95f )
        size = 64;
    else if (seed > 0.67f )
        size = 32;
    
    return [NSString stringWithFormat:@"%ublood%u.png", size, seed < 0.0f ? 1 : 2];
//    return CCRANDOM_MINUS1_1() >= 0.0f ? @"blood_splatter1_medium.png" : @"blood_splatter2_medium.png";
}

+(float)fadeScale
{
    return 0.24f;
}

+(float)maxRotation
{
    return 2.0f;
}

+(SGSpray *)sprayFromProjectile:(SGProjectile *)projectile andIntensity:(float)intensity
{
    SGSpray *newSplat = (SGSpray *)[self casingForProjectile:projectile];
    
//    CGFloat oldX = newSplat->
    newSplat->bounciness_ = intensity;
    
    return newSplat;
}

-(float)ejectionIntensity
{
    return 0.01f;
}

-(CGPoint)findPrimaryDirection
{
    return ccpMult([self forwardDirection], [self ejectionIntensity]);
}

-(void)splatter
{
    SGSpray *splatter = [[self class] sprayFromProjectile:[self projectile] andIntensity:bounciness_ * 0.25f];
    
    [splatter setPosition:position_];
    [splatter setRotation:rotation_];
    
    [[self parent] addChild:splatter];
    
    if( bounciness_ <= kSGSprayThreshold )
    {
        [[self parent] addChild:[SGSplatter splatterFromSpray:self]];
        
        [self unschedule:@selector(splatter)];
    }
    else
        bounciness_ *= bounciness_ * 0.8f;
}

-(CCFiniteTimeAction *)ejectionAction
{
    [self runAction:[CCScaleBy actionWithDuration:0.47f scale:1.3f]];
    return [CCSequence actionOne:[CCFadeIn actionWithDuration:0.237f] two:[CCFadeOut actionWithDuration:0.327f]];
}

-(void)onEnter
{
    [super onEnter];
    
    [self schedule:@selector(splatter) interval:0.017f repeat:kCCRepeatForever delay:0.07f];
    
    [self runAction:[CCFadeOut actionWithDuration:1.27f]];
}

     
-(void)bounceAround
{
    [self setOpacity:0];
}
@end
