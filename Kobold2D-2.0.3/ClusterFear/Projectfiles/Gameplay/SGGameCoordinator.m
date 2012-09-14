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
#import "SGLocalPlayer.h"
#import "SGWeapon.h"

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
        
        
        localPlayer = [SGLocalPlayer playerWithFile:@"soldier.png" health:100 andWeapon:[[SGWeapon alloc] init]];
        
        localPlayer.position = CGPointMake(tileMapLayer.contentSize.width/2, tileMapLayer.contentSize.height/2);
        [self addChild:localPlayer];
        
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    //[self spawnEnemies];
    //[self schedule:@selector(spawnEnemies) interval:5.0f];
    NSLog(@"Entering");
}

-(void)spawnEnemies
{
    SGBug *testBug = [SGBug spriteWithFile:@"game-events.png"];
    
    
    
    CGPoint spawnPoint = CGPointMake(CCRANDOM_0_1() * 768.0f, CCRANDOM_0_1() * 1024.0f );
    
    [testBug setPosition:spawnPoint];
    
    [self addChild:testBug];
}


-(void)touchAtPoint:(CGPoint)touchPoint inTile:(CGPoint)tilePos
{
    [localPlayer moveToPoint:touchPoint];
}

@end
