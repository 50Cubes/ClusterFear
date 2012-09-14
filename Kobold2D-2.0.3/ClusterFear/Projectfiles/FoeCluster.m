//
//  FoeCluster.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/13/12.
//
//

#import "FoeCluster.h"



@implementation FoeCluster
+(SGFoeStats)getStatsByClassName:(NSString *)name{
    SGFoeStats ret; // TODO Cache by name instead of re-fetching every time
    // Build path string
    NSString* configPath = [NSString stringWithFormat:@"%@%@",@"SGFoeStats.",name];
    // Set the config lookup path
    if([KKConfig selectKeyPath:configPath]){
        ret.damage = [KKConfig intForKey:@"Damage"];
        ret.maxCritters = [KKConfig intForKey:@"MaxCritters"];
        ret.maxHealth = [KKConfig intForKey:@"MaxHealth"];
        ret.moveSpeed = [KKConfig intForKey:@"Damage"];
    }
    else{
        NSLog(@"SGFoeStats.getStatsByClassName: %@ not found by KKConfig.selectKeyPath.",configPath);
        ret.damage = -1;
        ret.maxHealth = 0;
    }
    return ret;
}
@end
