//
//  SGDestroyable.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"
#import "chipmunk.h"

@class SGWeapon;
@class SGProjectile;

@interface SGDestroyable : CCSprite
{
    int health_;
}

+(int)damageCapability;

@property(nonatomic, readonly) int damage;

@property(nonatomic, readonly)BOOL isDead;

+(NSString *)imagePath;
+(int)startingHealth;
+(int)damageCapability;
+(SGDestroyable *)destroyable;

-(void)initializeHealth:(int)health;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)getHitFromProjectile:(SGProjectile *)projectile;
-(void)die;

-(void)collideWithDestroyable:(SGDestroyable *)other;
-(void)removeFromParentAndDoCleanup;

@end
