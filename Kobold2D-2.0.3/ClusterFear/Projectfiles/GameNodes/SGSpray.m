//
//  SGSpray.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGSpray.h"
#import "SGSplatter.h"

#define kSGSprayThreshold 0.25f
#define kSGSprayDelay 0.12f

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
    return 75.0f;
}

-(CGPoint)findPrimaryDirection
{
    float distance = [self ejectionIntensity];
    
    CGPoint casingDirection = ccpMult([self forwardDirection], distance);
    
    CGFloat oldX = casingDirection.x;
    
    distance *= 0.1f;
    //    casingDirection.x = casingDirection.y + (CCRANDOM_MINUS1_1() * distance * bounciness_);
    //    casingDirection.y = oldX + (CCRANDOM_MINUS1_1() * distance * bounciness_);
    
    casingDirection.y = casingDirection.y + (CCRANDOM_MINUS1_1() * distance * bounciness_);
    casingDirection.x = -1.0f *(oldX + (CCRANDOM_MINUS1_1() * distance * bounciness_));
    
    return casingDirection;
}

-(void)splatter
{
    float seed = CCRANDOM_MINUS1_1();
    BOOL flip = seed <= -0.1f;
    
    if( flip )
    {
        SGSplatter *splatter = [SGSplatter splatterFromSpray:self];
        
        [splatter setPosition:position_];
        [splatter setRotation:rotation_];
        
        [[self parent] addChild:splatter z:1 tag:0];
    }
    
    if( bounciness_ <= kSGSprayThreshold )
    {
        [self unschedule:@selector(splatter)];
    }
    else
    {
        bounciness_ *= bounciness_ * 0.8f;
        
        SGSpray *newSpray = [SGSpray sprayFromProjectile:[self projectile] andIntensity:bounciness_ * (flip) ? 0.25f : 0.55f];
        
        if( flip )
        {
            newSpray->rotation_ += 180.0f;
        }
        
        seed = CCRANDOM_MINUS1_1();
        
        newSpray->rotation_ += (seed * 15.0f) / bounciness_;
        
        [[self parent] addChild:newSpray];
    }
}

-(CCFiniteTimeAction *)ejectionAction
{
    [self runAction:[CCScaleBy actionWithDuration:0.247f scale:1.5f * bounciness_]];
    [self runAction:[CCMoveBy actionWithDuration:0.327 position:[self findPrimaryDirection]]];
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
