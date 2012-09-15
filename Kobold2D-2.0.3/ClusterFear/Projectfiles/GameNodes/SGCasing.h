//
//  SGCasing.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGProjectile.h"

@interface SGCasing : CCSprite
{
    float bounciness_;
}

@property(nonatomic, strong)SGProjectile *projectile;

+(NSString *)casingPath;

+(SGCasing *)casingForProjectile:(SGProjectile *)projectile;

@end
