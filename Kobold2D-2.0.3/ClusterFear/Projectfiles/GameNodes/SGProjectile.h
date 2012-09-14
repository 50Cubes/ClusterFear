//
//  SGProjectile.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"
#import "SGmover.h"

@class SGWeapon;

@interface SGProjectile : CCSprite

+(float)range;

+(NSString *)projectileAsset;
+(SGProjectile *)projectileForWeapon:(SGWeapon *)weapon;


@property(nonatomic, strong)SGWeapon *weapon;
-(void)fired;

@end
