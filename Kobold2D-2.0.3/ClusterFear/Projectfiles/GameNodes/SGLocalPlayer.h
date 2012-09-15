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

@class SGEnemy;

@protocol SGLocalPlayerOwner <NSObject>

-(void)playerMovedToPoint:(CGPoint)newPoint;
-(void)playerHit:(SGLocalPlayer *)player fromProjectile:(SGProjectile *)projectile;
-(void)playerHit:(SGLocalPlayer *)player forDamage:(int)damage;
-(void)playerHasDied:(SGLocalPlayer *)player;

@end

@interface SGLocalPlayer : SGMover{
    SGWeapon *weapon;
    int coins_;
}

+(id)playerWithFile:(NSString *)file health:(int)startingHealth andWeapon:(SGWeapon *)weapon;

@property(nonatomic, unsafe_unretained)NSObject <SGLocalPlayerOwner, SGMoverOwner> *owner;

-(void)fireWeapon;
-(void)fireWeaponAtPoint:(CGPoint)target;

-(void)receiveReward:(int)coinValue;

-(void)getHitByEnemy:(SGEnemy *)enemy;

@end
