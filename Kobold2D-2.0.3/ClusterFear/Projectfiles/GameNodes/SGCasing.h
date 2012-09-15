//
//  SGCasing.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGProjectile.h"

@interface SGCasing : SGProjectile
{
    float bounciness_;
}

+(SGCasing *)casingForWeapon:(SGWeapon *)weapon;

@end
