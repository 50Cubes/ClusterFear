//
//  SGGameCoordinator.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGGameCoordinator.h"

#import "SGBug.h"
#import "TileMapLayer.h"

@implementation SGGameCoordinator

-(id)init
{
    self = [super init];
    if( self != nil )
    {
        TileMapLayer *tileMapLayer = [TileMapLayer node];
        
        [tileMapLayer setDelegate:self];
        [self setTileLayer:tileMapLayer];
        [self addChild:tileMapLayer];
    }
    return self;
}

-(void)spawnEnemies
{
    SGBug *testBug = [SGBug spriteWithFile:@"game-events.png"];
    
    [[self tileLayer] addChild:testBug];
}


-(void)touchAtPoint:(CGPoint)touchPoint inTile:(CGPoint)tilePos
{
    
}

@end
