//
//  FoeCluster.h
//  ClusterFear
//
//  Created by Alan Richardson on 9/13/12.
//
// Abstract base class for enemy clusters in ClusterFear. Could be a protocol?

#import <Foundation/Foundation.h>

@interface FoeCluster : CCNode
- (NSNumber*) health;
- (NSNumber*) damage;

@end
