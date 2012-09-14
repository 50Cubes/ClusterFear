//
//  SGDestroyable.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGDestroyable.h"
#import "SGWeapon.h"

@implementation SGDestroyable

+(NSString *)imagePath
{
    return @"rock.png";
}

+(SGDestroyable *)destroyable
{
    return [self spriteWithFile:[self imagePath]];
}

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    health_ -= [weapon damageInflicted];
    if(health_ <= 0){
        [weapon didDestroy:self];
        [self die];
    }
}


-(void)initializeHealth:(int)newHealth{
    health_ = newHealth;
}

-(void)die{
    [self stopAllActions];
    
    CCFiniteTimeAction *dieSequence = [CCSequence actionOne:[CCFadeOut actionWithDuration:0.5f] two:[CCCallFunc actionWithTarget:self selector:@selector(removeFromParentAndDoCleanup)]];
    [self runAction:dieSequence];
}


-(void)removeFromParentAndDoCleanup
{
    [self removeFromParentAndCleanup:YES];
}

@end
