//
//  SGBugCluster.m
//  ClusterFear
//
//  Created by Alan Richardson on 9/14/12.
//
//

#import "SGBugCluster.h"

SGFoeStats * bugStats=nil;

@interface SGBugCluster (){
    uint health;
    CGPoint center;
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
        center.x=0;
        center.y=0;
    }
    return self;
}

@synthesize health;
@synthesize center;

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
