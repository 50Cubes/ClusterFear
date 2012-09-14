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
        [tileMapLayer setSize:[self size]];
        
        [self addChild:tileMapLayer];
        
        [self spawnEnemies];
        [self schedule:@selector(spawnEnemies) interval:5.0f];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    NSLog(@"Entering");
}

-(void)spawnEnemies
{
    SGBug *testBug = [SGBug spriteWithFile:@"game-events.png"];
    
    
    
    CGPoint spawnPoint = CGPointMake(CCRANDOM_0_1() * 1024.0f, CCRANDOM_0_1() * 768.0f );
    
    [testBug setPosition:spawnPoint];
    
    [self addChild:testBug];
}


-(void)touchAtPoint:(CGPoint)touchPoint inTile:(CGPoint)tilePos
{
    
}

@end
