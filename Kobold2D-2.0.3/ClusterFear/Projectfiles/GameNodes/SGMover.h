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
    CGFloat velocity_;
}

+(float)speed;

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth;

@property(nonatomic, readonly)BOOL isEnemy;
@property(nonatomic, unsafe_unretained)NSObject <SGMoverOwner> *owner;

@property(nonatomic, readonly)float velocity;

-(void)fireProjectile:(SGProjectile *)projectile;

-(float)facePoint:(CGPoint)pointToFace;
-(CCFiniteTimeAction *)actionToFacePoint:(CGPoint)normalizedVector;


-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection;
-(CCFiniteTimeAction *)actionToFaceRelativePoint:(CGPoint)normalizedVector;



-(CCFiniteTimeAction *)moveToPointActions:(CGPoint)targetPoint;
-(void)moveToPoint:(CGPoint)targetPoint;
-(void)moveByAmount:(CGPoint)movementVector;

-(void)didDestroy:(SGDestroyable *)destroyable;

@end
