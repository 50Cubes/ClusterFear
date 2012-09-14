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

@class SGLocalPlayer;
@class SGRunActivator;

@interface SGGameCoordinator : CCScene <TileMapLayerDelegate>{
    SGLocalPlayer *localPlayer;
    SGRunActivator *runActivator;
}

@property (nonatomic, strong)TileMapLayer *tileLayer;

-(void)spawnEnemies;


@end
