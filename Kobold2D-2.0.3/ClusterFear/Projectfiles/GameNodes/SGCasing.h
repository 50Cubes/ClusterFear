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

+(NSString *)casingPath;

+(SGCasing *)casingForProjectile:(SGProjectile *)projectile;

+(float)maxRotation;

+(float)bounceThreshold;

@property(nonatomic, strong)SGProjectile *projectile;


-(float)ejectionIntensity;
-(CGPoint)findPrimaryDirection;

-(CCFiniteTimeAction *)ejectionAction;

@end
