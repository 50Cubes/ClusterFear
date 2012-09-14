//
//  SGBatCluster.m
//  ClusterFear
//
//  Created by Alan Richardson on 9/14/12.
//
//

#import "SGBatCluster.h"

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
    }
    return self;
}

@synthesize health;
@synthesize center;

-(NSUInteger)damage{
    return batStats.stats.damage;
}
@end
