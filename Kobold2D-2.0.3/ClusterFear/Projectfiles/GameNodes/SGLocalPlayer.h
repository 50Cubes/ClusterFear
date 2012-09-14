//
//  SGLocalPlayer.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"

@class SGWeapon;

@interface SGLocalPlayer : SGMover{
    SGWeapon *weapon;
}

+(id)playerWithFile:(NSString *)file health:(int)startingHealth andWeapon:(SGWeapon *)weapon;

-(void)fireWeapon;

@end
