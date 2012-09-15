//
//  SGCasing.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGCasing.h"
#import "SGWeapon.h"

#define kSGCasingMinimumBounceCoefficient 0.1f

@implementation SGCasing

+(SGCasing *)casingForWeapon:(SGWeapon *)weapon
{
    SGCasing *rtnCasing = [self spriteWithFile:[self projectileAsset]];
    [rtnCasing setWeapon:weapon];
    return rtnCasing;
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    if( (self = [super initWithTexture:texture rect:rect rotated:rotated]) != nil)
        bounciness_ = 0.64f;
    return self;
}

-(void)bounceAround
{
    float squareBounciness = (bounciness_ * bounciness_);
    
    float randSeed = (CCRANDOM_MINUS1_1());
    
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
    
    
    float distance = [[[self weapon] class] range] * squareBounciness * 0.5f;
    CGPoint casingDirection = ccpMult([self forwardDirection], distance);
    
    CGFloat oldX = casingDirection.x;
    
    distance *= 0.1f;
    casingDirection.x = casingDirection.y + (CCRANDOM_MINUS1_1() * distance * bounciness_);
    casingDirection.y = oldX + (CCRANDOM_MINUS1_1() * distance * bounciness_);
    
    NSLog(@"Casing bounce angle %f and direction %@", bounceAngle, NSStringFromCGPoint(casingDirection));
    
    CCMoveBy *moveAction = [CCMoveBy actionWithDuration:0.21f + squareBounciness position:casingDirection];
    CCFiniteTimeAction *lastAction = nil;
    
    if( bounciness_ > kSGCasingMinimumBounceCoefficient )
    {
        bounciness_ = squareBounciness;
        
        lastAction = [CCSequence actionOne:moveAction two:[CCCallFunc actionWithTarget:self selector:@selector(bounceAround)]];
    }
    else
        lastAction = moveAction;
    
    [self runAction:lastAction];
}

-(void)bounce
{
    [self scheduleOnce:@selector(bounceAround) delay:0.01f];
}

-(void)onEnter
{
    [super onEnter];
    
    [self bounceAround];
}

@end