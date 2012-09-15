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

@interface SGProjectile : SGDestroyable

+(float)speed;

+(NSString *)projectileAsset;
+(SGProjectile *)projectileForWeapon:(SGWeapon *)weapon;

@property(nonatomic, strong)SGWeapon *weapon;
@property(nonatomic, readonly) BOOL spent;

-(SGProjectile *)casing;
-(void)fired;

@end
