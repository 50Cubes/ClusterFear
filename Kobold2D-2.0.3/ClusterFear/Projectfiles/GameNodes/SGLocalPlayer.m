//
//  SGLocalPlayer.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGLocalPlayer.h"
#import "SGWeapon.h"

@interface SGLocalPlayer ()

-(void)initializeWeapon:(SGWeapon *)newWeapon;

@end

@implementation SGLocalPlayer

+(id)playerWithFile:(NSString *)file health:(int)startingHealth andWeapon:(SGWeapon *)weapon{
    SGLocalPlayer *p = [self moverWithFile:file andHealth:startingHealth];
    [p initializeWeapon:weapon];
    return p;
}


-(BOOL)isEnemy
{
    return NO;
}


-(void)initializeWeapon:(SGWeapon *)newWeapon{
    weapon = newWeapon;
}

-(void)fireWeapon
{
    [weapon fire];
}

@end
