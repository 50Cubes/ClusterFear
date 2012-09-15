//
//  FoeCluster.h
//  ClusterFear
//
//  Created by Alan Richardson on 9/13/12.
//
// Abstract base class for enemy clusters in ClusterFear. Could be a protocol?

#import <Foundation/Foundation.h>
#import "GameNodes/SGEnemy.h"
#import "Gameplay/SGWeapon.h"

@interface SGFoeStats : NSObject{
    @public
    int maxHealth;
    int maxCritters;
    int damage;
    int moveSpeed;
}

@property(nonatomic, unsafe_unretained)SGFoeStats *stats;

-(id)initWithKeyPath:(NSString *)keyPath;
@end

@interface SGFoeCluster : CCNode

+(SGFoeCluster *)foeCluster;

@property(nonatomic, readonly)CGPoint center;

@property(nonatomic, readonly)NSUInteger minionCount;

@property(nonatomic, readonly)NSUInteger health;
@property(nonatomic, readonly)NSUInteger damage;

+(SGFoeStats*) getStatsByClassName:(NSString*)name;
-(BOOL) strike:(SGEnemy*)memberStruck:(SGWeapon*)weaponStriking;
@end

