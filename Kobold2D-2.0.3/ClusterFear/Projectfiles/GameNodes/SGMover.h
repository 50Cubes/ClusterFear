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

-(void)mover:(SGMover *)mover killedSomething:(SGDestroyable *)killer;

//-(void)moverPerished:(SGMover *)mover;

@end

@interface SGMover : SGDestroyable{
    CCLabelTTF *healthLabel;
    
    CGPoint destination_;
    CGPoint velocity_;
    CGFloat currentSpeed_;
}

+(float)speed;

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth;

@property(nonatomic, readonly)BOOL isEnemy;
@property(nonatomic, unsafe_unretained)NSObject <SGMoverOwner> *owner;

@property(nonatomic, readonly)CGPoint velocity;
@property(nonatomic, readonly)CGFloat currentSpeed;

@property(nonatomic, readonly)float radius;

-(void)fireProjectile:(SGProjectile *)projectile;
-(void)fireProjectile:(SGProjectile *)projectile withAccuracy:(float)accuracy;

-(float)facePoint:(CGPoint)pointToFace;
-(CCFiniteTimeAction *)actionToFacePoint:(CGPoint)normalizedVector;


-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection;
-(CCFiniteTimeAction *)actionToFaceRelativePoint:(CGPoint)normalizedVector;



-(CCFiniteTimeAction *)moveToPointActions:(CGPoint)targetPoint;
-(void)moveToPoint:(CGPoint)targetPoint;
-(void)moveByAmount:(CGPoint)movementVector;

-(void)didDestroy:(SGDestroyable *)destroyable;

//don't call directly
-(void)hitForDamage:(int)damage;

@end
