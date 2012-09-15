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

+(float)speed;

+(NSString *)projectileAsset;
+(SGProjectile *)projectileForWeapon:(SGWeapon *)weapon;

-(CGPoint)forwardDirection;

@property(nonatomic, strong)SGWeapon *weapon;

-(SGProjectile *)casing;
-(void)fired;

@end
