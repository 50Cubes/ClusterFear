//
//  SGGameCoordinator.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGGameCoordinator.h"

#import "SGRandomization.h"
#import "SGFoeCluster.h"

#import "SGBatCluster.h"
#import "SGBugCluster.h"
#import "SGBug.h"
#import "TileMapLayer.h"
#import "SGLocalPlayer.h"
#import "SGWeapon.h"
#import "SGRunActivator.h"

#import "SGProjectile.h"

#import "SGObstacle.h"

#import "SGSpray.h"

#import "SGCollectable.h"

#import "SGBat.h"
#import "SimpleAudioEngine.h"


@interface SGGameCoordinator ()
{
    CCArray *_moverList, *_projectileList;
    
    CCArray *_enemyTypes;
    CCArray *_clusters;
    
    CCArray *_turrets;
}


//-(void)physicsSetup;
//-(void)physicsTick:(ccTime)dt;

//-(void)addPhysicalBodyToSprite:(CCSprite *)sprite;
-(void)replay;
-(void)spawnTurrets;

@end

@implementation SGGameCoordinator

static SGGameCoordinator *_sharedCoordinator = nil;
+(SGGameCoordinator *)sharedCoordinator
{
    if( _sharedCoordinator == nil )
    {
        NSLog(@"@oh noe");
    }
    return _sharedCoordinator;
}

@synthesize moverList = _moverList;

-(id)init
{
    self = [super init];
    if( self != nil )
    {
        _sharedCoordinator = self;
        //[self physicsSetup];
        _clusters = [CCArray arrayWithCapacity:10];
        _moverList = [CCArray new];
        _projectileList = [CCArray new];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"alien-sfx.caf"];
        TileMapLayer *tileMapLayer = [TileMapLayer node];
    
        
        [tileMapLayer setDelegate:self];
        [self setTileLayer:tileMapLayer];
        [tileMapLayer setSize:[self size]];
        
        [self addChild:tileMapLayer];
        

        [self spawnPlayer];
        
//        [self runAction:[CCFollow actionWithTarget:localPlayer]];
        
//        localPlayer = [SGLocalPlayer playerWithFile:@"soldier.png" health:100 andWeapon:[[SGWeapon alloc] init]];
//        [localPlayer setOwner:self];
//        
//        localPlayer.position = CGPointMake(tileMapLayer.contentSize.width/2, tileMapLayer.contentSize.height/2);
//        //[self addPhysicalBodyToSprite:localPlayer];
//        [self addChild:localPlayer];
        
        runActivator = [SGRunActivator node];
        [runActivator setContentSize:CGSizeMake(150, 60)];
        [runActivator setup];
        runActivator.isTouchEnabled = YES;
        //runActivator.position = CGPointMake(runActivator.contentSize.width/2, runActivator.contentSize.height/2);
        [self addChild:runActivator];
        
        
        _enemyTypes = [CCArray arrayWithCapacity:2];
        [_enemyTypes addObject:[SGBatCluster class]];
        [_enemyTypes addObject:[SGBugCluster class]];
        
        
        CCMenuItemSprite *replay = [CCMenuItemSprite itemWithTarget:self selector:@selector(replay)];
        [replay setNormalImage:[CCSprite spriteWithFile:@"game-events.png"]];
        replay.isEnabled = NO;
        replay.position = CGPointMake(0, 700);
        
        [self generateRandomObstacles];
        
        [self spawnTurrets];
        
        [self schedule:@selector(spawnEnemies) interval:1.0f];
//        [self schedule:@selector(physicsTick:)];
        [self scheduleUpdateWithPriority:1];
    }
    return self;
}

-(void)spawnPlayer
{
    localPlayer = [SGLocalPlayer playerWithFile:@"soldier.png" health:100 andWeapon:[[SGWeapon alloc] init]];
    [localPlayer setOwner:self];
    
    localPlayer.position = CGPointMake(_tileLayer.contentSize.width/2, _tileLayer.contentSize.height/2);
    [_tileLayer addChild:localPlayer z:1];
}



-(void)onEnter
{
    [super onEnter];
    
    //[self spawnEnemies];
    //[self schedule:@selector(spawnEnemies) interval:5.0f];
    NSLog(@"Entering");
}

-(NSUInteger)enemyCount
{
    return [_clusters count];
}

#define numObstacles 25
-(void)generateRandomObstacles
{
    for( int count = 0; count < numObstacles; count++ )
    {
        SGObstacle *newObstacle = [SGObstacle obstacle];
        
        [newObstacle setPosition:SGRandomScreenPoint()];
        
        //[self addPhysicalBodyToSprite:newObstacle];
        [_tileLayer addChild:newObstacle z:1 tag:0];
    }
}


#pragma mark - Level Config

-(void)tileOfType:(NSString *)tileType inTile:(CGPoint)tilePos
{
    //populate tiles based on map
}

-(void)spawnEnemies
{
    if( [self enemyCount] < 8 )
    {
        Class clusterClass = [_enemyTypes randomObject];//TODO randomize
        SGFoeCluster *spawnedCluster = [clusterClass foeCluster];
//        SGFoeCluster *spawnedCluster = [SGBatCluster foeCluster];
        
        CGPoint spawnPoint = SGRandomScreenPoint();

        [spawnedCluster setPosition:spawnPoint];
        
        if( spawnedCluster != nil )
            [self addCluster:spawnedCluster];
    }
}

-(void)addCluster:(SGFoeCluster *)newCluster
{
    [newCluster setOwner:self];
    
    [_clusters addObject:newCluster];
    
    [_tileLayer addChild:newCluster z:2 tag:1];
}

-(void)addMover:(SGMover *)newMover
{
//    [_moverList addObject:newMover];
    
    [newMover setOwner:self];
    
//    [self addChild:newMover];
}


-(void)touchAtPoint:(CGPoint)touchPoint inTile:(CGPoint)tilePos
{
    if( [runActivator isPressed]){
        [localPlayer moveToPoint:touchPoint];
    }
    else
    {
        [localPlayer facePoint:touchPoint];

        [localPlayer fireWeapon];
    }
}

#pragma mark - Mover Delegate Methods

//-(void)moverPerished:(SGMover *)mover
//{
//    [_moverList removeObject:mover];
//}

-(void)mover:(SGMover *)mover firedProjectile:(SGProjectile *)projectile
{
    SGProjectile *casing = [projectile casing];
    
    if( casing != nil )
    {
        [_tileLayer addChild:casing z:0 tag:0];
    }
    
    //[self addPhysicalBodyToSprite:projectile];
    [_projectileList addObject:projectile];
    [_tileLayer addChild:projectile z:2 tag:0];
    [projectile fired];
    [[SimpleAudioEngine sharedEngine] playEffect:@"alien-sfx.caf"];
}

-(void)removeProjectile:(SGProjectile *)projectile
{
    [_projectileList removeObject:projectile];
}


#pragma mark - Local Player Delegates

-(void)playerHasDied:(SGLocalPlayer *)player
{
    localPlayer = nil;
    [self scheduleOnce:@selector(spawnPlayer) delay:4.0f];
    
}

-(void)playerHit:(SGLocalPlayer *)player forDamage:(int)damage
{
    [SGSpray sprayOnCharacter:player forDamage:damage andIntensity:0.4f];
}

-(void)playerHit:(SGLocalPlayer *)player fromProjectile:(SGProjectile *)projectile
{
    SGSpray *splatter = [SGSpray sprayFromProjectile:projectile andIntensity:0.8f];
    
    [_tileLayer addChild:splatter z:0];
}

-(void)playerMovedToPoint:(CGPoint)newPoint
{
//    [_tileLayer set]
}

#pragma mark - Cluster Tracking

-(void)foeClusterDestroyed:(SGFoeCluster *)cluster
{
    [_clusters removeObject:cluster];
}

-(CGPoint)foeClusterRequestsPlayerLocation:(SGFoeCluster *)cluster
{
    return [localPlayer position];
}

-(void)foeCluster:(SGFoeCluster *)cluster hitByProjectile:(SGProjectile *)projectile
{
    SGSpray *splatter = [SGSpray sprayFromProjectile:projectile andIntensity:0.9f];
    
    [_tileLayer addChild:splatter z:0];
    
    if( CCRANDOM_0_1() > 0.9f )
    {
        SGCollectable *collectable = [SGCollectable collectable];
        
        [_tileLayer addChild:collectable z:1];
    }
}

#pragma mark physics


static inline void DoCollision(SGDestroyable *destroyable, SGProjectile *projectile)
{
    [destroyable getHitFromProjectile:projectile];
    
    [projectile projectileDidHitTarget:destroyable];
}
static inline void DoDestroyableCollision(SGDestroyable *destroyable, SGDestroyable *destroyable2)
{
    [destroyable collideWithDestroyable:destroyable2];
    [destroyable2 collideWithDestroyable:destroyable];
}
static inline void DoClusterCollision(SGLocalPlayer *player, SGFoeCluster *cluster)
{
}

#define kPhysicsCollisionThreashold 64.0f

static inline BOOL TestPoints(CGRect bounds, CGPoint *points)
{
    for( int count = 0; count < 4; count++ )
    {
        if( CGRectContainsPoint(bounds, points[count]) )
            return YES;
    }
    return NO;
}

static inline BOOL SGEnemyCheckCollisionWithPoint(SGEnemy *enemy, CGPoint clusterCenter, CGPoint checkPoint, float radius)
{
    CGPoint enemyCenter = [enemy boundingBoxCenter];
    enemyCenter.x += clusterCenter.x;
    enemyCenter.y += clusterCenter.y;
    
    float distance = ccpDistance(checkPoint, enemyCenter);
    
    float enemyRadius = [enemy radius];
    
    return ( distance < (enemyRadius + radius) );
}

//static inline BOOL TransformPointsIntersectionTest

static inline void DoPhysics(ccTime dT, SGLocalPlayer *localPlayer, CCArray *clusters, CCArray *projectiles )
{
//    BOOL hasDebug = NO;
    CGPoint playeCenter = [localPlayer boundingBoxCenter];
    float playerRadius = [localPlayer radius];
    for( SGFoeCluster *cluster in clusters )
    {
        CGPoint clusterCenter = [cluster boundingBoxCenter];
        CGRect clusterBounds = (CGRect){.origin=[cluster boundingBoxCenter],.size=CGSizeZero};
        float radius = [cluster radius];
//        clusterBounds.origin.x -= radius;
//        clusterBounds.origin.y -= radius;
        radius *= 2.0f;
        clusterBounds.size.width = radius;
        clusterBounds.size.height = radius;
        
        if( ccpDistance(clusterCenter, playeCenter) < kPhysicsCollisionThreashold + playerRadius )
        {
            DoClusterCollision(localPlayer, cluster);
            
            for( SGEnemy *minion in [cluster minions] )
            {
                if( SGEnemyCheckCollisionWithPoint( minion, clusterCenter, playeCenter, kPhysicsCollisionThreashold + playerRadius ) )
                {
                    DoDestroyableCollision(localPlayer, minion);
                }
            }
        }
        
        for( SGProjectile *bullet in projectiles )
        {
            CGPoint bulletCenter = [bullet boundingBoxCenter];
            
            float bulletRadius = [bullet radius];
            if(  ccpDistance(bulletCenter, clusterCenter) < (kPhysicsCollisionThreashold + radius + bulletRadius) ) //TestPoints(clusterBounds, bulletBounds))
            {
                for( SGEnemy *enemy in [cluster minions] )
                {
//                    static float maxDist = 0.0f;
                    
                    CGPoint enemyCenter = [enemy boundingBoxCenter];
                    enemyCenter.x += clusterCenter.x;
                    enemyCenter.y += clusterCenter.y;
                    
                    float distance = ccpDistance(bulletCenter, enemyCenter);
                    
                    float enemyRadius = [enemy radius];
                    
                    if( distance < (kPhysicsCollisionThreashold + enemyRadius + bulletRadius) )
                   {
                        DoCollision(enemy, bullet);
                   }
                }
            }
        }
    }
}

-(void)update:(ccTime)dT
{
//    const float maxTimeSlice = 0.127f;
    
    ccTime interval = dT;
//    ccTime interval = maxTimeSlice;
//    do
//    {
//        dT -= maxTimeSlice;
//        if( dT <= 0.0f )
//            interval = maxTimeSlice + dT;
        DoPhysics(interval, localPlayer, _clusters, _projectileList);
        
//    } while( dT > 0.0f );
}

/*
-(void)physicsTick:(ccTime)dt{
    @synchronized(self){
        CCArray *collisionObjects = [[CCArray alloc] initWithCapacity:[_moverList count]];
        CCArray *projectileSets =   [[CCArray alloc] initWithCapacity:[_moverList count]];

        for(SGMover *m in _moverList){
            NSMutableSet *s = [NSMutableSet new];
            for(SGProjectile *p in _projectileList){
                if(CGRectIntersectsRect([m boundingBoxInWorldSpace], [p boundingBoxInWorldSpace])){
                    [s addObject:p];
                }
            }
            
            if([s count] > 0){
                [collisionObjects addObject:m];
                [projectileSets addObject:s];
            }else{
                [collisionObjects addObject:[NSNull null]];
                [projectileSets addObject:[NSNull null]];
            }
        }
        
        int index = 0;
        if([collisionObjects count] > 0){
            NSMutableSet *alreadyGotSet = [NSMutableSet new];
            for(id item in collisionObjects){
                if(![item isKindOfClass:[NSNull class]]){
                    SGMover *m = (SGMover *)item;
                    NSMutableSet *projectileSet = [projectileSets objectAtIndex:index];
                    [projectileSet minusSet:alreadyGotSet];
                    for(SGProjectile *p in projectileSet){
//                        [m collideWithDestroyable:p];
//                        [p collideWithDestroyable:m];
                    }
                    
                    [alreadyGotSet unionSet:projectileSet];
                }
                
                index++;
            }
        }
    }
}//*/

/*
-(void)addChild:(CCNode *)node{
    if([node isKindOfClass:[SGDestroyable class]]){
        //cpSpaceAddShape(physicalSpace, [(SGDestroyable *)node destroyableShape]);
        SGDestroyable *sprite = (SGDestroyable *)node;
        b2BodyDef spriteBodyDef;
        spriteBodyDef.type = b2_dynamicBody;
        spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO,
                                   sprite.position.y/PTM_RATIO);
        spriteBodyDef.userData = (__bridge void *)sprite;
        b2Body *spriteBody = physicalSpace->CreateBody(&spriteBodyDef);
        
        b2PolygonShape spriteShape;
        spriteShape.SetAsBox(sprite.contentSize.width/PTM_RATIO/2,
                             sprite.contentSize.height/PTM_RATIO/2);
        b2FixtureDef spriteShapeDef;
        spriteShapeDef.shape = &spriteShape;
        spriteShapeDef.density = 10.0;
        spriteShapeDef.isSensor = true;
        spriteBody->CreateFixture(&spriteShapeDef);
    }
    
    [super addChild:node];
}

-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup{
    if([node isKindOfClass:[SGDestroyable class]]){
        SGDestroyable *sprite = (SGDestroyable *)node;
        b2Body *spriteBody = NULL;
        for(b2Body *b = physicalSpace->GetBodyList(); b; b=b->GetNext()) {
            if (b->GetUserData() != NULL) {
                CCSprite *curSprite = (__bridge CCSprite *)b->GetUserData();
                if (sprite == curSprite) {
                    spriteBody = b;
                    break;
                }
            }
        }
        if (spriteBody != NULL) {
            physicalSpace->DestroyBody(spriteBody);
        }
    }
    [super removeChild:node cleanup:cleanup];
}

-(void)addPhysicalBodyToSprite:(CCSprite *)sprite{
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO,
                               sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = (__bridge void *)sprite;
    b2Body *spriteBody = physicalSpace->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(sprite.contentSize.width/PTM_RATIO/2,
                         sprite.contentSize.height/PTM_RATIO/2);
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.0;
    spriteShapeDef.isSensor = true;
    spriteBody->CreateFixture(&spriteShapeDef);
}//*/

#pragma mark - turet

-(void)spawnTurrets{
    CGPoint points[] = {CGPointMake(200, 200), CGPointMake(200, 900), CGPointMake(900, 200), CGPointMake(900, 900)};
    for(int i = 0; i < 4; i++){
        SGTurret *t = [SGTurret turretWithAmmo:1000];
        t.owner = self;
        [t addToParent:self atPosition:points[i]];
        [t activate];
    }
}

-(CGPoint)directionForClosestEnemy:(SGTurret *)turret{
    CGPoint p = turret.position;
    float minDistance = (float)INT32_MAX;
    SGFoeCluster *target = nil;
    for(SGFoeCluster *f in _clusters){
        float dist = ccpDistance(p, f.position);
        if(dist < minDistance){
            minDistance = dist;
            target = f;
        }
    }
    
    if(target){
        return target.position;
    }
    
    return CGPointZero;
}

@end
