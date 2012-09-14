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
#import "SGRunActivator.h"

#import "SGProjectile.h"

@interface SGGameCoordinator ()
{
    NSMutableArray *_moverList;
}

-(void)physicsSetup;
-(void)physicsTick;

@end

@implementation SGGameCoordinator

@synthesize enemyCount = _enemyCount;
@synthesize moverList = _moverList;

-(id)init
{
    self = [super init];
    if( self != nil )
    {
        _moverList = [NSMutableArray new];
        
        TileMapLayer *tileMapLayer = [TileMapLayer node];
        
        [tileMapLayer setDelegate:self];
        [self setTileLayer:tileMapLayer];
        [tileMapLayer setSize:[self size]];
        
        [self addChild:tileMapLayer];
        
        
        localPlayer = [SGLocalPlayer playerWithFile:@"soldier.png" health:100 andWeapon:[[SGWeapon alloc] init]];
        
        localPlayer.position = CGPointMake(tileMapLayer.contentSize.width/2, tileMapLayer.contentSize.height/2);
        [self addChild:localPlayer];
        
        runActivator = [SGRunActivator node];
        [runActivator setContentSize:CGSizeMake(150, 60)];
        [runActivator setup];
        runActivator.isTouchEnabled = YES;
        //runActivator.position = CGPointMake(runActivator.contentSize.width/2, runActivator.contentSize.height/2);
        [self addChild:runActivator];
        
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
    if( _enemyCount < 10 )
    {
        _enemyCount++;
        
        SGBug *testBug = [SGBug spriteWithFile:@"spider.png"];
        
        
        
        CGPoint spawnPoint = CGPointMake(CCRANDOM_0_1() * 768.0f, CCRANDOM_0_1() * 1024.0f );
        
        [testBug setPosition:spawnPoint];
        
        [self addMover:testBug];
    }
}

-(void)addMover:(SGMover *)newMover
{
    [_moverList addObject:newMover];
    
    [newMover setOwner:self];
    
    [self addChild:newMover];
}


-(void)touchAtPoint:(CGPoint)touchPoint inTile:(CGPoint)tilePos
{
    if([runActivator isPressed]){
        [localPlayer moveToPoint:touchPoint];
    }else{
        [localPlayer facePoint:touchPoint];
    }
}

#pragma mark - Mover Delegate Methods

-(void)moverPerished:(SGMover *)mover
{
    if( [mover isEnemy] )
        _enemyCount--;
}

-(void)mover:(SGMover *)mover firedProjectile:(SGProjectile *)projectile
{
    [self addChild:projectile];
    [projectile fired];
}

#pragma mark physics

-(void)physicsSetup{
    physicalSpace = cpSpaceNew();
    [self schedule:@selector(physicsTick)];
}

-(void)physicsTick{
    cpSpaceStep(physicalSpace, [[CCDirector sharedDirector] secondsPerFrame]);
}

@end
