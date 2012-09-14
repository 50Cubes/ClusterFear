//
//  SGMover.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"

@class SGWeapon;

@class SGMover;

@class SGProjectile;

@protocol SGMoverOwner <NSObject>

-(void)mover:(SGMover *)mover firedProjectile:(SGProjectile *)projectile;

-(void)moverPerished:(SGMover *)mover;

@end

@interface SGMover : CCSprite{
    int health;
}

+(float)speed;

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth;

@property(nonatomic, readonly)BOOL isEnemy;
@property(nonatomic, unsafe_unretained)NSObject <SGMoverOwner> *owner;

-(void)fireProjectile:(SGProjectile *)projectile;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

-(void)facePoint:(CGPoint)pointToFace;
-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection;
-(void)moveToPoint:(CGPoint)targetPoint;

@end
