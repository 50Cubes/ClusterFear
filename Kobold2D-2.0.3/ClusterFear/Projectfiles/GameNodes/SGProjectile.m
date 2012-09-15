//
//  SGProjectile.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGProjectile.h"
#import "CCSprite+Convenience.h"

#import "SGCasing.h"

#import "SGWeapon.h"

@implementation SGProjectile

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

-(void)fired
{
    float myRange = [[self class] range];
    CGPoint direction = ccpMult([self forwardDirection], [[[self weapon] class] range]);
    direction.x *= -1.0f;
    
    ccTime fireTime = myRange / [[self class] speed];
    
    CCSequence *fireSequence = [CCSequence actionOne:[CCMoveBy actionWithDuration:fireTime position:direction] two:[CCCallFuncO actionWithTarget:self selector:@selector(collideWithDestroyable:) object:nil]];
    
    [self runAction:fireSequence];
}

-(SGCasing *)casing
{
    SGCasing *casing = [SGCasing casingForProjectile:self];
    
    [casing setPosition:position_];
    [casing setRotation:rotation_];
    
    return casing;
}

-(void)collideWithDestroyable:(SGDestroyable *)collidedWith
{
    if( collidedWith != nil )
    {
        
    }
    
    //[self removeFromParentAndCleanup:YES];
    [self die];
}

@end
