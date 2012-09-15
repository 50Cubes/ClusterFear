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

+(float)maxRotation
{
    return 5280.0f;
}

+(SGCasing *)casingForProjectile:(SGProjectile *)projectile
{
    SGCasing *rtnCasing = [self spriteWithFile:[self casingPath]];
    
    rtnCasing->position_ = [projectile position];
    rtnCasing->rotation_ = [projectile rotation];
    
    float radRot = CC_DEGREES_TO_RADIANS(rtnCasing->rotation_);
    rtnCasing->position_.x -= 2.0f * sinf(radRot);
    rtnCasing->position_.x -= 1.0f * cosf(radRot);
    
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
    
    ccTime flyTime = 0.167f + squareBounciness;
    
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
    
    
    float bounceAngle = squareBounciness * [[self class] maxRotation] * randSeed;
    [self runAction:[CCRotateBy actionWithDuration:0.26f + squareBounciness angle:bounceAngle]];
    
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
    [self scheduleOnce:@selector(bounceAround) delay:0.0167f];
}

-(CCFiniteTimeAction *)ejectionAction
{
    CCFiniteTimeAction *scaleUp = [CCEaseOut actionWithAction:[CCScaleBy actionWithDuration:0.187f scale:1.4f]];
    
    CCFiniteTimeAction *scaleDown = [CCEaseBounceIn actionWithAction:[CCScaleTo actionWithDuration:0.24f scale:[[self class] fadeScale]]];
    
    
    return [CCSequence actionOne:scaleUp two:scaleDown];
}

-(void)onEnter
{
    [super onEnter];
    
    [self runAction:[self ejectionAction]];
                                   
    [self bounceAround];
}

@end
