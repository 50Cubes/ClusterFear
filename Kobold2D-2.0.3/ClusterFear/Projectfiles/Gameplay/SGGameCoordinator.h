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

@interface SGGameCoordinator : CCScene <TileMapLayerDelegate>

@property (nonatomic, strong)TileMapLayer *tileLayer;

-(void)spawnEnemies;


@end
