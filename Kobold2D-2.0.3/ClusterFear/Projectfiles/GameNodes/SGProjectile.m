//
//  SGProjectile.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGProjectile.h"

@implementation SGProjectile

+(float)range
{
    return 400.0f;
}

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
    
    
//    CCSequence *fireSequence = [CCSequence actionOne:[CCMoveBy] two:<#(CCFiniteTimeAction *)#>]
}

@end
