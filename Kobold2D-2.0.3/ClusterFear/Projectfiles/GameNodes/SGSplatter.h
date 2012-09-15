//
//  SGSplatter.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGCasing.h"

@interface SGSplatter : SGCasing
{
}

+(SGSplatter *)splatterFromProjectile:(SGProjectile *)projectile andIntensity:(float)intensity;

@end
