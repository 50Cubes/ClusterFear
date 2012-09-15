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

@interface SGDestroyable : CCSprite
{
    int health_;
}

@property(nonatomic, readonly) int damage;

+(NSString *)imagePath;
+(int)startingHealth;
+(int)damageCapability;
+(SGDestroyable *)destroyable;

-(void)initializeHealth:(int)health;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

-(void)collideWithDestroyable:(SGDestroyable *)other;
-(void)removeFromParentAndDoCleanup;

@end
