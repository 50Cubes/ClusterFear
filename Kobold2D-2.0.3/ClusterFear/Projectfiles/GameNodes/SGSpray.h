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

+(SGSpray *)sprayOnCharacter:(SGMover *)character forDamage:(int)damage andIntensity:(float)intensity;
+(SGSpray *)sprayFromProjectile:(SGProjectile *)projectile andIntensity:(float)intensity;

@property (nonatomic, readonly)CCTexture2D *splatterTexture;

@end
