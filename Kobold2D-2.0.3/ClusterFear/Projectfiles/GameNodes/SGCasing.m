//
//  SGCasing.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGCasing.h"
#import "SGWeapon.h"

#import "CCSprite+Convenience.h"

#define kSGCasingMinimumBounceCoefficient 0.1f

@implementation SGCasing

+(NSString *)casingPath
{
    return @"bullet.png";
}

+(float)fadeScale
{
    return 0.75f;
}

+(SGCasing *)casingForProjectile:(SGProjectile *)projectile
{
    SGCasing *rtnCasing = [self spriteWithFile:[self casingPath]];
    [rtnCasing setProjectile:projectile];
    return rtnCasing;
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    if( (self = [super initWithTexture:texture rect:rect rotated:rotated]) != nil)
        bounciness_ = 0.64f;
    return self;
}

-(float)ejectionIntensity
{
    return [[[self projectile] class] range] * (bounciness_ * bounciness_) * 0.5f;
}

-(CGPoint)findPrimaryDirection
{
    float distance = [self ejectionIntensity];
    
    CGPoint casingDirection = ccpMult([self forwardDirection], distance);
    
    CGFloat oldX = casingDirection.x;
    
    distance *= 0.1f;
    casingDirection.x = casingDirection.y + (CCRANDOM_MINUS1_1() * distance * bounciness_);
    casingDirection.y = oldX + (CCRANDOM_MINUS1_1() * distance * bounciness_);
    
    return casingDirection;
}

-(void)bounceAround
{
    float squareBounciness = (bounciness_ * bounciness_);
    
    float randSeed = (CCRANDOM_MINUS1_1());
    
    ccTime flyTime = 0.21f + squareBounciness;
    
    if( randSeed == 0.0f )
    {
        randSeed = 0.2f;
    }
    else
    {
        float randAbs = fabsf(randSeed);
        if( randAbs < 0.1f )
        {
            randSeed += 0.2f * (randSeed / randAbs);
        }
    }
    
    
    float bounceAngle = squareBounciness * 5280.0f * randSeed;
    [self runAction:[CCRotateBy actionWithDuration:0.32f + squareBounciness angle:bounceAngle]];
    
    CGPoint casingDirection = [self findPrimaryDirection];
    
    //CCLOG(@"Casing bounce angle %f and direction %@", bounceAngle, NSStringFromCGPoint(casingDirection));
    
    CCMoveBy *moveAction = [CCMoveBy actionWithDuration:flyTime position:casingDirection];
    CCFiniteTimeAction *lastAction = nil;
    
    if( bounciness_ > kSGCasingMinimumBounceCoefficient )
    {
        bounciness_ = squareBounciness;
        
        lastAction = [CCSequence actionOne:moveAction two:[CCCallFunc actionWithTarget:self selector:@selector(bounceAround)]];
    }
    else
    {
        lastAction = moveAction;
        [self setProjectile:nil];
    }
    
    [self runAction:lastAction];
}

-(void)bounce
{
    [self scheduleOnce:@selector(bounceAround) delay:0.01f];
}

-(void)onEnter
{
    [super onEnter];
    
    CCFiniteTimeAction *scaleUp = [CCEaseOut actionWithAction:[CCScaleBy actionWithDuration:0.09f scale:1.2f]];
    
    CCFiniteTimeAction *scaleDown = [CCEaseBounceIn actionWithAction:[CCScaleTo actionWithDuration:0.47f scale:[[self class] fadeScale]]];
    
    
    [self runAction:[CCSequence actionOne:scaleUp two:scaleDown]];
                                   
    [self bounceAround];
}

@end
