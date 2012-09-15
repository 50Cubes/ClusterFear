//
//  SGWeapon.m
//  ClusterFear
//
//  Created by Lev Trubov on 9/14/12.
//
//

#import "SGWeapon.h"
#import "SGProjectile.h"

#import "SGMover.h"

@implementation SGWeapon

@synthesize damageInflicted;

+(Class)projectileClass
{
    return [SGProjectile class];
}

+(CGFloat)fireDelay
{
    return 0.1f;
}

+(NSUInteger)magazineSize
{
    return 10;
}

+(float)range
{
    return 400.0f;
}

+(SGWeapon *)weapon
{
    return [[self alloc] init];
}

-(id)init{
    if((self = [super init])){
        damageInflicted = 10;
    }
    
    return self;
}


-(void)fire
{
    SGProjectile *projectile = [[[self class] projectileClass] projectileForWeapon:self];
    
    [_owner fireProjectile:projectile];
    
}

-(void)didDestroy:(SGDestroyable *)destroyable
{
    [[self owner] didDestroy:destroyable];
}

@end
