//
//  SGShotgun.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGShotgun.h"
#import "SGProjectile.h"

#define numPellets 5

@implementation SGShotgun

+(float)range
{
    return 265.0f;
}

+(ccTime)fireDelay
{
    return 0.415f;
}


+(NSString *)gunshotFile
{
    return @"Shotgun1.wav";
}

-(int)damageInflicted
{
    return 3;
}

-(void)fire
{
    if( nextFireTime <= 0.0f )
    {
        Class projectileClass = [[self class] projectileClass];
        
        SGMover *myOwner = [self owner];
        for( int count = numPellets; count > 0; count-- )
        {
            SGProjectile *projectile = [projectileClass projectileForWeapon:self];
            
            [myOwner fireProjectile:projectile withAccuracy:27.5f];
        }
        
        nextFireTime = [[self class] fireDelay];
        
        
        [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:self priority:1 paused:NO];
    }
}

-(void)update:(ccTime)dT
{
    nextFireTime -= dT;
    
    if( nextFireTime <= 0.0f )
        [[[CCDirector sharedDirector] scheduler] unscheduleUpdateForTarget:self];
}

@end
