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
    CGPoint center;
}
@end

@implementation SGLocustCluster
-(id)init{
    // Static init
    if (nil==locustStats) {
        locustStats=[SGFoeCluster getStatsByClassName:@"SGLocustCluster"];
    }
    // Return nil if stats not found in LUA (maxHealth==0)
    self = locustStats.stats.maxHealth ? [super init] : nil;
    if(nil!=self){
        health=locustStats.stats.maxHealth;
        center.x=0;
        center.y=0;
    }
    return self;
}

@synthesize health;
@synthesize center;

-(NSUInteger)damage{
    return locustStats.stats.damage;
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
    float ratio = health/((float)locustStats.stats.maxHealth);
    float fractionalMinions = ratio * locustStats.stats.maxCritters;
    uint numMinions = (uint)fractionalMinions;
    while ([self minionCount] > numMinions) {
        [self removeChild:[[self children] objectAtIndex:0] cleanup:YES];
    }
}
@end
