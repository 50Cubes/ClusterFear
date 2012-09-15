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

@interface SGBatCluster (){
    uint health;
}
@end

@implementation SGBatCluster
-(id)init{
    // Static init
    if (nil==batStats) {
        batStats=[SGFoeCluster getStatsByClassName:@"SGBatCluster"];
    }
    // Return nil if stats not found in LUA (maxHealth==0)
    self = batStats.stats.maxHealth ? [super init] : nil;
    if(nil!=self){
        health=batStats.stats.maxHealth;
        for (int i=0; i<batStats.stats.maxCritters; ++i) {
            [self addChild:[SGBat enemy]];
        }
    }
    return self;
}

@synthesize health;

-(NSUInteger)damage{
    return batStats.stats.damage;
}
-(BOOL)strike:(SGEnemy*)memberStruck :(SGWeapon*)weaponStriking{
    uint damage = (uint) [weaponStriking damageInflicted];
    if (health < damage) {
        health = 0;
        return YES;
    }
    // else
    health-=damage;
    [self checkForMinion:memberStruck];
    return NO;
}

-(void)checkForMinion:(SGEnemy*)memberStruck{
    float ratio = health/((float)batStats.stats.maxHealth);
    float fractionalMinions = ratio * batStats.stats.maxCritters;
    uint numMinions = (uint)fractionalMinions;
    if ([self minionCount] > numMinions) {
        [self removeChild:memberStruck cleanup:YES];
    }
}
@end
