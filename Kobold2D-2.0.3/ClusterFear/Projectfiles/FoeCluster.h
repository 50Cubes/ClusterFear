//
//  FoeCluster.h
//  ClusterFear
//
//  Created by Alan Richardson on 9/13/12.
//
// Abstract base class for enemy clusters in ClusterFear. Could be a protocol?

#import <Foundation/Foundation.h>

typedef struct {
    int maxHealth;
    int maxCritters;
    int damage;
    int moveSpeed;
} SGFoeStats;

@interface FoeCluster : CCNode

@property(nonatomic, readonly)CGPoint center;

@property(nonatomic, readonly)NSUInteger minionCount;

@property(nonatomic, readonly)NSUInteger health;
@property(nonatomic, readonly)NSUInteger damage;

+(SGFoeStats) getStatsByClassName:(NSString*)name;
@end

