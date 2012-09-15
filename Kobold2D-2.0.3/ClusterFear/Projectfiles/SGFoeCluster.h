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

@interface SGFoeCluster : CCNode

+(SGFoeStats *)getStats;
+(SGFoeStats *)findStats;
+(SGFoeCluster *)foeCluster;
+(Class)minionClass;

@property(nonatomic, readonly)NSUInteger minionLimit;
@property(nonatomic, readonly)NSUInteger minionCount;

@property(nonatomic, readonly)NSUInteger health;
@property(nonatomic, readonly)NSUInteger damage;

-(BOOL)memberStruck:(SGEnemy *)member withWeapon:(SGWeapon *)weaponStriking;
-(void)memberDied:(SGEnemy *)member;

-(void)populate;

@end



@interface SGFoeStats : NSObject{
@public
    int maxHealth;
    int maxCritters;
    int damage;
    int moveSpeed;
}

-(id)initWithKeyPath:(NSString *)keyPath;

@end
