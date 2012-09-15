//
//  SGLocalPlayer.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGLocalPlayer.h"
#import "SGWeapon.h"

#import "SGFoeCluster.h"

#import "SGProjectile.h"

@interface SGLocalPlayer ()

-(void)initializeWeapon:(SGWeapon *)newWeapon;

@end

@implementation SGLocalPlayer

static SGFoeStats *playerStats = nil;

+(void)initialize
{
    playerStats = [[SGFoeStats alloc] initWithKeyPath:[NSString stringWithFormat:@"%@.%@", @"SGFoeStats",[self description]]];
}

+(float)speed
{
    return playerStats == nil ? 100.0f : playerStats->moveSpeed;
}


+(id)playerWithFile:(NSString *)file health:(int)startingHealth andWeapon:(SGWeapon *)weapon{
    SGLocalPlayer *p = [self moverWithFile:file andHealth:startingHealth];
    [p initializeWeapon:weapon];
    return p;
}

//-(void)setPosition:(CGPoint)position
//{
//    [super setPosition:position];
//    
//    [[self owner] playerMovedToPoint:position];
//}


-(BOOL)isEnemy
{
    return NO;
}


-(void)initializeWeapon:(SGWeapon *)newWeapon{
    [weapon setOwner:nil];
    [newWeapon setOwner:self];
    weapon = newWeapon;
}

-(void)fireWeapon
{
    [weapon fire];
}

-(void)getHitByEnemy:(SGEnemy *)enemy
{
    
}

-(void)getHitFromProjectile:(SGProjectile *)projectile
{
    [[self owner] playerHit:self fromProjectile:projectile];
}

-(void)collideWithDestroyable:(SGDestroyable *)other
{
    int damage = [other damage];
    if( damage > 0 )
    {
        if( [other isKindOfClass:[SGProjectile class]] )
            [[self owner] playerHit:self fromProjectile:(id)other];
        else
        {
            [[self owner] playerHit:self forDamage:damage];
        }
        
        [self hitForDamage:damage];
    }
}

//-(void)hitForDamage:(int)damage
//{
//    [super hitForDamage:damage];
//}

-(void)receiveReward:(int)coinValue
{
    coins_ += coinValue;
}

-(void)die
{
    [[self owner] playerHasDied:self];
    
    [super die];
}

@end
