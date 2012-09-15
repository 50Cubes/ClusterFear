//
//  SGBatCluster.m
//  ClusterFear
//
//  Created by Alan Richardson on 9/14/12.
//
//

#import "SGBatCluster.h"
#import "SGBat.h"

SGFoeStats * batStats=nil;

@implementation SGBatCluster


+(void)initialize
{
    batStats = [self findStats];
}
+(SGFoeStats*) getStats
{
    return batStats;
}

+(Class)minionClass
{
    return [SGBat class];
}

//-(id)init{
//    // Static init
//    if (nil==batStats) {
//        batStats=[[self class] getStats];
//    }
//    // Return nil if stats not found in LUA (maxHealth==0)
//    self = batStats->maxHealth ? [super init] : nil;
//    if(nil!=self)
//    {
//        health=batStats->maxHealth;
//        for (int i=0; i<batStats->maxCritters; ++i) {
//            [self addChild:[SGBat enemy]];
//        }
//    }
//    return self;
//}


-(NSUInteger)damage{
    return batStats->damage;
}
//-(BOOL)strike:(SGEnemy*)memberStruck :(SGWeapon*)weaponStriking{
//    uint damage = (uint) [weaponStriking damageInflicted];
//    if (health < damage) {
//        health = 0;
//        return YES;
//    }
//    // else
//    health-=damage;
//    [self checkForMinion:memberStruck];
//    return NO;
//}
//
//-(void)checkForMinion:(SGEnemy*)memberStruck{
//    float ratio = health/((float)batStats->maxHealth);
//    float fractionalMinions = ratio * batStats->maxCritters;
//    uint numMinions = (uint)fractionalMinions;
//    if ([self minionCount] > numMinions) {
//        [self removeChild:memberStruck cleanup:YES];
//    }
//}
@end
