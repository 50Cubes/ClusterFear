//
//  SGProjectile.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGProjectile.h"

@implementation SGProjectile


+(NSString *)projectileAsset
{
    return @"game_events.png";
}

+(SGProjectile *)projectileForWeapon:(SGWeapon *)weapon
{
    SGProjectile *aProj = [self spriteWithFile:[self projectileAsset]];
    
    [aProj setWeapon:weapon];
    
    return aProj;
}

-(void)fired
{
    
}

@end
