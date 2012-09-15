//
//  SGTurret.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGTurret.h"
#import "SGRandomization.h"

#import "SGShotgun.h"

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
    SGTurret *t = [SGTurret moverWithFile:[self imagePath] andHealth:500];
    [t setAmmo:ammo];
    
    BOOL isShotgun = (CCRANDOM_0_1() > 0.95f);
    Class weaponClass = isShotgun ? [SGShotgun class] : [SGWeapon class];
    [t initializeWeapon:[weaponClass weapon]];
    
    if( isShotgun )
        [t setAmmo:250];

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
    baseSprite = [CCSprite spriteWithFile:@"base.png"]; //doesn't rotate with turrent
    baseSprite.position = position;
    [parent addChild:baseSprite];
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
        
        if( (ammo_ % 2) == 0 )
            [self hitForDamage:1];
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

-(void)collideWithDestroyable:(SGDestroyable *)other{
    if([self isDead]){
        return;
    }
    int damage = [other damage];
    if( damage > 0 )
    {
        [self hitForDamage:damage];
    }

}

-(void)die
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [baseSprite removeFromParentAndCleanup:YES];
    [[self owner] getDestroyed:self];
    [super die];
}


@end
