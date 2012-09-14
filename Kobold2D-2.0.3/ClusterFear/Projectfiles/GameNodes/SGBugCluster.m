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
        bugStats=[FoeCluster getStatsByClassName:@"SGBugCluster"];
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
@end
