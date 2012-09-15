//
//  SGMover.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGDestroyable.h"

@class SGWeapon;

@class SGMover;

@class SGProjectile;

@protocol SGMoverOwner <NSObject>

-(void)mover:(SGMover *)mover firedProjectile:(SGProjectile *)projectile;

-(void)moverPerished:(SGMover *)mover;

@end

@interface SGMover : SGDestroyable{
    CCLabelTTF *healthLabel;
}

+(float)speed;

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth;

@property(nonatomic, readonly)BOOL isEnemy;
@property(nonatomic, unsafe_unretained)NSObject <SGMoverOwner> *owner;

-(void)fireProjectile:(SGProjectile *)projectile;

-(void)facePoint:(CGPoint)pointToFace;
-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection;
-(void)moveToPoint:(CGPoint)targetPoint;


-(void)didDestroy:(SGDestroyable *)destroyable;

@end
