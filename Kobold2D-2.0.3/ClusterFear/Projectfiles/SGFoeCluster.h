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

-(void)foeCluster:(SGFoeCluster *)cluster hitByProjectile:(SGProjectile *)projectile;

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

@property(nonatomic, readonly)float velocity;

@property(nonatomic, readonly)NSUInteger minionLimit;
@property(nonatomic, readonly)NSUInteger minionCount;

@property(nonatomic, readonly)NSUInteger health;
@property(nonatomic, readonly)NSUInteger damage;

@property(nonatomic, unsafe_unretained)NSObject <SGFoeClusterOwner> *owner;

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
