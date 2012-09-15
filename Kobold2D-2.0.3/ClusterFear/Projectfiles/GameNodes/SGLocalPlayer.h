//
//  SGLocalPlayer.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"

@class SGWeapon;

@class SGLocalPlayer;

@protocol SGLocalPlayerOwner <NSObject>

-(void)playerMovedToPoint:(CGPoint)newPoint;
-(void)playerHasDied:(SGLocalPlayer *)player;

@end

@interface SGLocalPlayer : SGMover{
    SGWeapon *weapon;
}

+(id)playerWithFile:(NSString *)file health:(int)startingHealth andWeapon:(SGWeapon *)weapon;

@property(nonatomic, unsafe_unretained)NSObject <SGLocalPlayerOwner, SGMoverOwner> *owner;

-(void)fireWeapon;

@end
