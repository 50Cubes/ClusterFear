//
//  SGDestroyable.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGDestroyable.h"

@implementation SGDestroyable

+(NSString *)filePath
{
    return @"rock.png";
}

+(SGDestroyable *)destroyable
{
    return [self spriteWithFile:[self filePath]];
}

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    health -= [weapon damageInflicted];
    if(health <= 0){
        [self die];
    }
}

-(void)die{
    [self stopAllActions];
    
    [[self owner] moverPerished:self];
    
    CCFiniteTimeAction *dieSequence = [CCSequence actionOne:[CCFadeOut actionWithDuration:1.0f] two:[CCCallFunc actionWithTarget:self selector:@selector(removeFromParentAndDoCleanup)]];
    [self runAction:dieSequence];
}

@end
