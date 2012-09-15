//
//  SGLocustCluster.m
//  ClusterFear
//
//  Created by Alan Richardson on 9/14/12.
//
//

#import "SGLocustCluster.h"

SGFoeStats * locustStats=nil;

@interface SGLocustCluster (){
    uint health;
}
@end

@implementation SGLocustCluster
-(id)init{
    // Static init
    if (nil==locustStats) {
        locustStats=[SGFoeCluster getStats];
    }
    // Return nil if stats not found in LUA (maxHealth==0)
    self = locustStats->maxHealth ? [super init] : nil;
    if(nil!=self){
        health=locustStats->maxHealth;
    }
    return self;
}

@synthesize health;

-(NSUInteger)damage{
    return locustStats->damage;
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
//    float ratio = health/((float)locustStats->maxHealth);
//    float fractionalMinions = ratio * locustStats->maxCritters;
//    uint numMinions = (uint)fractionalMinions;
//    if ([self minionCount] > numMinions) {
//        [self removeChild:memberStruck cleanup:YES];
//    }
//}
@end
