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

+(NSString *)keyPath
{
    return [NSString stringWithFormat:@"%@%@",@"SGFoeStats.",[self description]];
}
+(SGFoeCluster *)foeCluster
{
    return [[self alloc] init];
}

+(SGFoeStats*)getStatsByClassName:(NSString *)name{
    
    if(nil == statDict){
        statDict = [NSMutableDictionary dictionaryWithCapacity:EXPECTED_NUM_CLUSTER_TYPES];
    }
    
    SGFoeStats *newStats = [statDict objectForKey:name];
    if(nil==newStats){
        // Build path string
        NSString* configPath = [self keyPath];
        // Set the config lookup path
        newStats = [[SGFoeStats alloc] initWithKeyPath:configPath];
        
        if( newStats != nil )
            [statDict setValue:newStats forKey:name];
    }

    return newStats;
}

//-(SGFoeCluster *)initWithStats:(GBFoeStats *)stats
//{
//    self = [super init];
//    if( self != nil )
//    {
//        
//    }
//    
//    return self;
//}

-(NSUInteger) minionCount{
    return [[self children] count];
}
-(BOOL)strike:(SGEnemy*)memberStruck :(SGWeapon*)weaponStriking{
    return NO;
}

-(CGPoint)center{
    return [self position];
}
@end

@implementation SGFoeStats

@synthesize stats;

-(id)initWithKeyPath:(NSString *)keyPath{
    if(self=[super init]){
        if([KKConfig selectKeyPath:keyPath]){
            self->damage = [KKConfig intForKey:@"Damage"];
            self->maxCritters = [KKConfig intForKey:@"MaxCritters"];
            self->maxHealth = [KKConfig intForKey:@"MaxHealth"];
            self->moveSpeed = [KKConfig intForKey:@"Damage"];
        }
        else{
            NSLog(@"SGFoeStats.getStatsByClassName: %@ not found by KKConfig.selectKeyPath.",self);
//            [self release];
            self = nil;
        }
    }
    return self;
}

-(SGFoeStats *)stats
{
    return self;
}

@end