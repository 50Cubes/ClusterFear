//
//  SGTurret.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGMover.h"
#import "SGWeapon.h"

@class SGTurret;

@protocol SGTurretOwner <NSObject>

-(CGPoint)directionForClosestEnemy:(SGTurret *)turret;
-(void)getDestroyed:(SGTurret *)turret;

@end

@interface SGTurret : SGMover
{
    SGWeapon *weapon;
    int ammo_;
    CCSprite *baseSprite;
}

@property (nonatomic, readonly)int ammo;
@property(nonatomic, unsafe_unretained)NSObject <SGTurretOwner, SGMoverOwner> *owner;


+(id)turretWithAmmo:(int)ammo;

-(void)addToParent:(CCNode *)parent atPosition:(CGPoint)position;
-(void)activate;
@end
