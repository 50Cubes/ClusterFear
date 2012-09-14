//
//  SGProjectile.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"

@class SGWeapon;

@interface SGProjectile : CCSprite

+(NSString *)projectileAsset;
+(SGProjectile *)projectileForWeapon:(SGWeapon *)weapon;


@property(nonatomic, strong)SGWeapon *weapon;
-(void)fired;

@end
