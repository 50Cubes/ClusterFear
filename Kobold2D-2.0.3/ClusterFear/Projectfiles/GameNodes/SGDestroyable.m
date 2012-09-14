//
//  SGDestroyable.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGDestroyable.h"
#import "SGWeapon.h"

@interface SGDestroyable ()

-(void)initializeShape;

@end

@implementation SGDestroyable

@synthesize destroyableShape;

+(NSString *)imagePath
{
    return @"rock.png";
}

+(int)startingHealth{
    return 100;
}


+(SGDestroyable *)destroyable
{
    SGDestroyable *d = [self spriteWithFile:[self imagePath]];
    [d initializeHealth:[self startingHealth]];
    [d initializeShape];
    return d;
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

-(void)initializeShape{
    destroyableShape = cpCircleShapeNew(cpBodyNew(25, INFINITY), 20.0, cpvzero);
    destroyableShape->e = 0.5;
    destroyableShape->u = 0.8;
    destroyableShape->collision_type = 1;
    destroyableShape->data = (__bridge void *)self;
}

@end
