//
//  SGEnemy.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"

@class SGFoeCluster;

@interface SGEnemy : SGMover

+(SGEnemy *)enemy;
+(SGEnemy *)enemyForCluster:(SGFoeCluster *)cluster;
+(NSString *)imagePath;

@property (nonatomic, unsafe_unretained)SGFoeCluster *cluster;

-(CCFiniteTimeAction *)nextAction;

@end
