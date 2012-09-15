//
//  SGDestroyable.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGDestroyable.h"
#import "SGWeapon.h"

#import "SGProjectile.h"

@interface SGDestroyable ()


@end

@implementation SGDestroyable

@synthesize damage;

+(NSString *)imagePath
{
    return @"rock.png";
}

+(int)startingHealth{
    return 100;
}

+(int)damageCapability{
    return 5;
}



+(SGDestroyable *)destroyable
{
    SGDestroyable *d = [self spriteWithFile:[self imagePath]];
    [d initializeHealth:[self startingHealth]];
    return d;
}

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    health_ -= [weapon damageInflicted];
    if(health_ <= 0){
        [weapon didDestroy:self];
        [self die];
    }
}

-(void)getHitFromProjectile:(SGProjectile *)projectile
{
    health_ -= [projectile damage];
    if(health_ <= 0){
        [[projectile weapon] didDestroy:self];
        [self die];
    }
}


-(void)initializeHealth:(int)newHealth{
    health_ = newHealth;
}

-(void)die{
    [self stopAllActions];
    
    //CCFiniteTimeAction *dieSequence = [CCSequence actionOne:[CCFadeOut actionWithDuration:0.5f] two:[CCCallFunc actionWithTarget:self selector:@selector(removeFromParentAndDoCleanup)]];
    //[self runAction:dieSequence];
    [self removeFromParentAndDoCleanup];
}


-(void)removeFromParentAndDoCleanup
{
    [self removeFromParentAndCleanup:YES];
}

#pragma mark - collision

-(void)collideWithDestroyable:(SGDestroyable *)other
{
    
}



@end
