//
//  SGEnemy.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"

@class SGFoeCluster;

typedef enum {
    SGEnemyTier_Grunt = 4,
    SGEnemyTier_Elite = 5,
    SGEnemyTier_Boss = 6
} SGEnemyTier;

@interface SGEnemy : SGMover
{
    SGEnemyTier tier;
}

+(SGEnemy *)enemyWithStrength:(float)strength;

+(SGEnemy *)enemy;
+(SGEnemy *)enemyWithTier:(SGEnemyTier)tier;

+(SGEnemy *)enemyForCluster:(SGFoeCluster *)cluster;
+(SGEnemy *)bossForCluster:(SGFoeCluster *)cluster;

+(NSString *)imagePath;

+(CCTexture2D *)textureWithTier:(SGEnemyTier)tier;


@property (nonatomic, unsafe_unretained)SGFoeCluster *cluster;

@property (nonatomic, readonly)float radius;

-(CCFiniteTimeAction *)nextAction;

-(void)crawl;
-(void)reorient;

@end
