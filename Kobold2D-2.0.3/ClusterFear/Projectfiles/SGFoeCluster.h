//
//  FoeCluster.h
//  ClusterFear
//
//  Created by Alan Richardson on 9/13/12.
//
// Abstract base class for enemy clusters in ClusterFear. Could be a protocol?

#import <Foundation/Foundation.h>
#import "CCNode.h"
#import "SGEnemy.h"
#import "SGWeapon.h"

@class SGFoeStats;

@class SGFoeCluster;

@class SGProjectile;

@protocol SGFoeClusterOwner <NSObject>

-(void)foeCluster:(SGFoeCluster *)cluster minion:(SGEnemy *)enemy hitByProjectile:(SGProjectile *)projectile;

//-(void)foeClusterRequestsMinionPlacement:(

-(CGPoint)foeClusterRequestsPlayerLocation:(SGFoeCluster *)cluster;
-(void)foeClusterDestroyed:(SGFoeCluster *)cluster;

@end

@interface SGFoeCluster : CCNode
{
//    float velocity_;
}

+(SGFoeStats *)getStats;
+(SGFoeStats *)findStats;
+(SGFoeCluster *)foeCluster;
+(Class)minionClass;

@property(nonatomic, readonly)float speed;

@property(nonatomic, readonly)CCArray *minions;

@property(nonatomic, readonly)NSUInteger minionLimit;
@property(nonatomic, readonly)NSUInteger minionCount;

@property(nonatomic, readonly)int health;
@property(nonatomic, readonly)NSUInteger damage;

@property(nonatomic, readonly)CGPoint velocity;

@property(nonatomic, readonly)float radius;

@property(nonatomic, readonly)BOOL dead;

//In local coordinate system, add to position for global
@property(nonatomic, readonly)CGPoint destination;

@property(nonatomic, unsafe_unretained)NSObject <SGFoeClusterOwner> *owner;

@property(nonatomic, readonly)SGFoeStats *stats;

-(BOOL)memberStruck:(SGEnemy *)member withProjectile:(SGProjectile *)projectile;
-(void)memberDied:(SGEnemy *)member;

-(void)populate;

@end



@interface SGFoeStats : NSObject{
@public
    int maxHealth;
    int maxCritters;
    int damage;
    float moveSpeed;
}


-(id)initWithKeyPath:(NSString *)keyPath;

@end
