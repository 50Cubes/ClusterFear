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

@implementation SGBugCluster

+(void)initialize
{
    bugStats = [self findStats];
}
+(SGFoeStats *)getStats
{
    return bugStats;
}

+(Class)minionClass
{
    return [SGBug class];
}

//-(id)init{
//    // Static init
//    if (nil==bugStats) {
//        bugStats=[[self class] getStats];
//    }
//    // Return nil if stats not found in LUA (maxHealth==0)
//    self = bugStats->maxHealth ? [super init] : nil;
//    if(nil!=self){
//        health=bugStats->maxHealth;
//        for (int x=0; x<bugStats->maxCritters; ++x) {
//            [self addChild:[SGBug enemy]];
//        }
//    }
//    return self;
//}


-(NSUInteger)damage{
    return bugStats->damage;
}
@end
