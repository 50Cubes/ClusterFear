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
        locustStats=[FoeCluster getStatsByClassName:@"SGLocustCluster"];
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
@end