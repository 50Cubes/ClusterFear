//
//  SGSpray.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGSpray.h"
#import "SGSplatter.h"

#define kSGSprayThreshold 0.2f
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

+(float)bounceThreshold
{
    return 0.4f;
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

-(CCTexture2D *)splatterTexture
{
    return [self texture];
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
    SGSplatter *splatter = [SGSplatter splatterFromSpray:self];
    
    [splatter setPosition:position_];
    [splatter setRotation:rotation_];
    
    [[self parent] addChild:splatter z:1 tag:0];
    
    if( bounciness_ <= kSGSprayThreshold )
    {
        [self unschedule:@selector(splatter)];
    }
    else
    {
        SGSpray *newSpray = [SGSpray sprayFromProjectile:[self projectile] andIntensity:bounciness_ * 0.6f];
        
        float seed = CCRANDOM_MINUS1_1();
        if( seed >= 0.0f )
            newSpray->rotation_ += 180.0f;
        
        seed = CCRANDOM_MINUS1_1();
        
        newSpray->rotation_ += seed * 25.0f;
        
        [[self parent] addChild:newSpray];
        
        bounciness_ *= bounciness_ * 0.8f;
    }
}

-(CCFiniteTimeAction *)ejectionAction
{
    [self runAction:[CCScaleBy actionWithDuration:0.247f scale:1.5f * bounciness_]];
    [self runAction:[CCMoveBy actionWithDuration:0.327 position:ccpMult([self forwardDirection], 100.0f * bounciness_)]];
    return [CCSequence actionOne:[CCFadeIn actionWithDuration:0.137f] two:[CCFadeOut actionWithDuration:0.227f]];
}

-(void)onEnter
{
    [self setOpacity:0];
    
    [super onEnter];
    
    [self schedule:@selector(splatter) interval:0.017f repeat:kCCRepeatForever delay:0.07f];
}

     
-(void)bounceAround
{
}
@end
