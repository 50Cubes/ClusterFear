//
//  SGGameCoordinator.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import <Foundation/Foundation.h>
#import "CCScene.h"

#import "TileMapLayer.h"

#import "SGMover.h"
//#import "MyContactListener.h"
#import "SGLocalPlayer.h"

#import "SGFoeCluster.h"
#import "SGTurret.h"

@class SGLocalPlayer;
@class SGRunActivator;

@interface SGGameCoordinator : CCScene <TileMapLayerDelegate, SGMoverOwner, SGLocalPlayerOwner, SGFoeClusterOwner, SGTurretOwner>{
    SGLocalPlayer *localPlayer;
    SGRunActivator *runActivator;
    SGRunActivator *turretActivator;
    SGRunActivator *shotgunActivator;
    
    CCNode *shiftLayer;
    
    //cpSpace *physicalSpace;
    //b2World *physicalSpace;
    //MyContactListener *listener;
}

+(SGGameCoordinator  *)sharedCoordinator;

@property (nonatomic, strong)TileMapLayer *tileLayer;

@property (nonatomic, readonly)unsigned int enemyCount;

@property (nonatomic, strong, readonly)CCArray *moverList;

-(void)spawnEnemies;

-(void)addMover:(SGMover *)newMover;

-(void)removeProjectile:(SGProjectile *)projectile;


@end
