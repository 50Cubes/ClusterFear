//
//  SGBugCluster.m
//  ClusterFear
//
//  Created by Alan Richardson on 9/14/12.
//
//

#import "SGBugCluster.h"
#import "SGBug.h"

SGFoeStats * bugStats=nil;

@interface SGBugCluster (){
    uint health;
}
@end

@implementation SGBugCluster
-(id)init{
    // Static init
    if (nil==bugStats) {
        bugStats=[SGFoeCluster getStatsByClassName:@"SGBugCluster"];
    }
    // Return nil if stats not found in LUA (maxHealth==0)
    self = bugStats.stats.maxHealth ? [super init] : nil;
    if(nil!=self){
        health=bugStats.stats.maxHealth;
        for (int x=0; x<bugStats.stats.maxCritters; ++x) {
            [self addChild:[SGBug enemy]];
        }
    }
    return self;
}

@synthesize health;

-(NSUInteger)damage{
    return bugStats.stats.damage;
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
    float ratio = health/((float)bugStats.stats.maxHealth);
    float fractionalMinions = ratio * bugStats.stats.maxCritters;
    uint numMinions = (uint)fractionalMinions;
    if ([self minionCount] > numMinions) {
        [self removeChild:memberStruck cleanup:YES];
    }
}
@end
