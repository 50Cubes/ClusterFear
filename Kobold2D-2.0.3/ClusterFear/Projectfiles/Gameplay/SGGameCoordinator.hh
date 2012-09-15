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
#import "SpaceManagerCocos2d.h"
#import "chipmunk.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import "SGLocalPlayer.h"

@class SGLocalPlayer;
@class SGRunActivator;

@interface SGGameCoordinator : CCScene <TileMapLayerDelegate, SGMoverOwner, SGLocalPlayerOwner>{
    SGLocalPlayer *localPlayer;
    SGRunActivator *runActivator;
    
    //cpSpace *physicalSpace;
    b2World *physicalSpace;
    MyContactListener *listener;
}

@property (nonatomic, strong)TileMapLayer *tileLayer;

@property (nonatomic, readonly)unsigned int enemyCount;

@property (nonatomic, strong, readonly)NSArray *moverList;

-(void)spawnEnemies;

-(void)addMover:(SGMover *)newMover;


@end
