//
//  SGSpray.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGCasing.h"

@interface SGSpray : SGCasing
{
}

+(SGSpray *)sprayFromProjectile:(SGProjectile *)projectile andIntensity:(float)intensity;

@end
