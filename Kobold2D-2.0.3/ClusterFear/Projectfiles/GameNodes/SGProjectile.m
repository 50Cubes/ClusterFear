//
//  SGProjectile.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGProjectile.h"
#import "CCSprite+Convenience.h"

#import "SGGameCoordinator.h"
#import "SGCasing.h"

#import "SGWeapon.h"

@implementation SGProjectile

@synthesize spent;
@synthesize damage = damage_;

+(float)range
{
    return 400.0f;
}

+(float)speed
{
    return 800.0f;
}

+(NSString *)projectileAsset
{
    return @"bullet5.png";
}

+(NSString *)casingAsset
{
    return [self projectileAsset];
}


+(SGProjectile *)projectileForWeapon:(SGWeapon *)weapon
{
    SGProjectile *aProj = [self spriteWithFile:[self projectileAsset]];
    
    [aProj setWeapon:weapon];
    
    return aProj;
}

-(void)onEnter
{
    [super onEnter];
    
    damage_ = [[self weapon] damageInflicted];
}

-(void)fired
{
    float myRange = [[self class] range];
    CGPoint direction = ccpMult([self forwardDirection], [[[self weapon] class] range]);
    direction.x *= -1.0f;
    
    ccTime fireTime = myRange / [[self class] speed];
    
    CCSequence *fireSequence = [CCSequence actionOne:[CCMoveBy actionWithDuration:fireTime position:direction] two:[CCCallFuncO actionWithTarget:self selector:@selector(projectileDidHitTarget:) object:nil]];
    
    [self runAction:fireSequence];
}

-(SGCasing *)casing
{
    SGCasing *casing = [SGCasing casingForProjectile:self];
    
//    [casing setPosition:position_];
//    [casing setRotation:rotation_];
    
    return casing;
}

-(void)collideWithDestroyable:(SGDestroyable *)collidedWith
{
    [[SGGameCoordinator sharedCoordinator] removeProjectile:self];
    [self removeFromParentAndCleanup:YES];
}

-(void)projectileDidHitTarget:(SGDestroyable *)target
{
    if( damage_ > 0 )
    {
        damage_ -= [self damage];
        
        if( damage_ <= 0 )
        {
            [[SGGameCoordinator sharedCoordinator] removeProjectile:self];
            [self removeFromParentAndCleanup:YES];
        }
    }
}

@end
