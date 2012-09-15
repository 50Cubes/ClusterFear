//
//  SGProjectile.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"
#import "SGmover.h"

#import "CCSprite+Convenience.h"

@class SGWeapon;

@protocol SGProjectileOwner <NSObject>

-(void)projectileDestroyed:(SGProjectile *)projectile;

@end

@interface SGProjectile : CCSprite
{
    int damage_;
}

+(float)speed;

+(NSString *)projectileAsset;
+(SGProjectile *)projectileForWeapon:(SGWeapon *)weapon;

@property(nonatomic, strong)SGWeapon *weapon;
@property(nonatomic, readonly) BOOL spent;

@property(nonatomic, readonly)int damage;

@property(nonatomic, readonly)float radius;

//@property(nonatomic, readonly)CGRect physicsBounds;

-(void)projectileDidHitTarget:(SGDestroyable *)target;

-(SGProjectile *)casing;
-(void)fired;

@end
