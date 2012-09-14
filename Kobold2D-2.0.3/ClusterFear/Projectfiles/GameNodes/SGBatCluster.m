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
    CGPoint center;
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
        center.x=0;
        center.y=0;
        for (int i=0; i<batStats.stats.maxCritters; ++i) {
            [self addChild:[SGBat enemy]];
        }
    }
    return self;
}

@synthesize health;
@synthesize center;

-(NSUInteger)damage{
    return batStats.stats.damage;
}
-(BOOL) strike:(NSUInteger)damage{
    if (health < damage) {
        health = 0;
        return YES;
    }
    // else
    health-=damage;
    [self killMinions];
    return NO;
}

-(void)killMinions{
    float ratio = health/((float)batStats.stats.maxHealth);
    float fractionalMinions = ratio * batStats.stats.maxCritters;
    uint numMinions = (uint)fractionalMinions;
    while ([self minionCount] > numMinions) {
        [self removeChild:[[self children] objectAtIndex:0] cleanup:YES];
    }
}
@end
