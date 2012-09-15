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
    float ratio = health/((float)bugStats.stats.maxHealth);
    float fractionalMinions = ratio * bugStats.stats.maxCritters;
    uint numMinions = (uint)fractionalMinions;
    while ([self minionCount] > numMinions) {
        [self removeChild:[[self children] objectAtIndex:0] cleanup:YES];
    }
}
@end
