//
//  FoeCluster.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/13/12.
//
//

#import "SGFoeCluster.h"
#define EXPECTED_NUM_CLUSTER_TYPES 5
static NSMutableDictionary *statDict=nil;

@implementation SGFoeCluster
+(SGFoeStats*)getStatsByClassName:(NSString *)name{
    if(nil == statDict){
        statDict = [NSMutableDictionary dictionaryWithCapacity:EXPECTED_NUM_CLUSTER_TYPES];
    }
    if(nil==[statDict objectForKey:name]){
        SGFoeStats_ nuStats; // TODO Cache by name instead of re-fetching every time
        // Build path string
        NSString* configPath = [NSString stringWithFormat:@"%@%@",@"SGFoeStats.",name];
        // Set the config lookup path
        if([KKConfig selectKeyPath:configPath]){
            nuStats.damage = [KKConfig intForKey:@"Damage"];
            nuStats.maxCritters = [KKConfig intForKey:@"MaxCritters"];
            nuStats.maxHealth = [KKConfig intForKey:@"MaxHealth"];
            nuStats.moveSpeed = [KKConfig intForKey:@"Damage"];
        }
        else{
            NSLog(@"SGFoeStats.getStatsByClassName: %@ not found by KKConfig.selectKeyPath.",configPath);
            nuStats.damage = -1;
            nuStats.maxHealth = 0;
        }
        [statDict setValue:[[SGFoeStats alloc]init:&nuStats] forKey:name];
    }

    return [statDict objectForKey:name];
}

-(NSUInteger) minionCount{
    return [[self children] count];
}
-(BOOL) strike:(NSUInteger)damage{
    return NO;
}
@end

@implementation SGFoeStats

@synthesize stats;

-(id)init:(SGFoeStats_ const *)stat{
    if(self=[super init]){
        self.stats=(*stat);
    }
    return self;
}

@end