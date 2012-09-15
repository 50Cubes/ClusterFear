//
//  SGTurret.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGTurret.h"
#import "SGRandomization.h"

@interface SGTurret ()

-(void)setAmmo:(int)newAmmo;
-(void)initializeWeapon:(SGWeapon *)newWeapon;
-(void)tryToFire;

@end

@implementation SGTurret

+(NSString *)imagePath{
    return @"rotateTop.png";
}

+(id)turretWithAmmo:(int)ammo{
    SGTurret *t = [SGTurret moverWithFile:[self imagePath] andHealth:1000];
    [t setAmmo:ammo];
    [t initializeWeapon:[[SGWeapon alloc] init]];

    return t;
}

-(void)setAmmo:(int)newAmmo{
    ammo_ = newAmmo;
}

-(BOOL)isEnemy
{
    return NO;
}

-(void)addToParent:(CCNode *)parent atPosition:(CGPoint)position{
    self.position = position;
    CCSprite *turretBase = [CCSprite spriteWithFile:@"base.png"]; //doesn't rotate with turrent
    turretBase.position = position;
    [parent addChild:turretBase];
    [parent addChild:self];
}

-(void)initializeWeapon:(SGWeapon *)newWeapon{
    [weapon setOwner:nil];
    [newWeapon setOwner:self];
    weapon = newWeapon;
}

-(void)fireWeapon
{
    if(ammo_ > 0){
        ammo_--;
        [weapon fire];
    }
}

-(void)fireTowards:(CGPoint)direction{
    
}

-(void)activate{
    float time = 5.0*SGRandNormalized();
    [self performSelector:@selector(tryToFire) withObject:nil afterDelay:time];
}


-(void)tryToFire{
    CGPoint destination = [[self owner] directionForClosestEnemy:self];
    if(CGPointEqualToPoint(destination, CGPointZero)){
        return;
    }
    if(ammo_ <= 0){
        return;
    }
    
    [self facePoint:destination];
    [self fireWeapon];
    float time = 5.0*SGRandNormalized();
    [self performSelector:@selector(tryToFire) withObject:nil afterDelay:time];
}



@end
