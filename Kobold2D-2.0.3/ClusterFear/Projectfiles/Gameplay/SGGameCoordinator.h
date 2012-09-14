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

@class SGLocalPlayer;
@class SGRunActivator;

@interface SGGameCoordinator : CCScene <TileMapLayerDelegate, SGMoverOwner>{
    SGLocalPlayer *localPlayer;
    SGRunActivator *runActivator;
}

@property (nonatomic, strong)TileMapLayer *tileLayer;

@property (nonatomic, readonly)unsigned int enemyCount;

@property (nonatomic, strong, readonly)NSArray *moverList;

-(void)spawnEnemies;

-(void)addMover:(SGMover *)newMover;


@end
