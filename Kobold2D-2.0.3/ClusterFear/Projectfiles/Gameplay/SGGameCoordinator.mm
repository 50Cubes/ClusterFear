//
//  SGGameCoordinator.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGGameCoordinator.hh"

#import "SGRandomization.h"

#import "SGBug.h"
#import "TileMapLayer.h"
#import "SGLocalPlayer.h"
#import "SGWeapon.h"
#import "SGRunActivator.h"

#import "SGProjectile.h"

#import "SGObstacle.h"

#import "SGBat.h"
#import "../GameNodes/SGBatCluster.h"

#define PTM_RATIO 32

@interface SGGameCoordinator ()
{
    NSMutableArray *_moverList;
    
    CCArray *_enemyTypes;
}

-(void)physicsSetup;
-(void)physicsTick:(ccTime)dt;

-(void)addPhysicalBodyToSprite:(CCSprite *)sprite;

@end

@implementation SGGameCoordinator

@synthesize enemyCount = _enemyCount;
@synthesize moverList = _moverList;

-(id)init
{
    self = [super init];
    if( self != nil )
    {
        [self physicsSetup];
        _moverList = [NSMutableArray new];
        
        TileMapLayer *tileMapLayer = [TileMapLayer node];
        
        [tileMapLayer setDelegate:self];
        [self setTileLayer:tileMapLayer];
        [tileMapLayer setSize:[self size]];
        
        [self addChild:tileMapLayer];
        
        
        localPlayer = [SGLocalPlayer playerWithFile:@"soldier.png" health:100 andWeapon:[[SGWeapon alloc] init]];
        [localPlayer setOwner:self];
        
        localPlayer.position = CGPointMake(tileMapLayer.contentSize.width/2, tileMapLayer.contentSize.height/2);
        [self addPhysicalBodyToSprite:localPlayer];
        [self addChild:localPlayer];
        
        runActivator = [SGRunActivator node];
        [runActivator setContentSize:CGSizeMake(150, 60)];
        [runActivator setup];
        runActivator.isTouchEnabled = YES;
        //runActivator.position = CGPointMake(runActivator.contentSize.width/2, runActivator.contentSize.height/2);
        [self addChild:runActivator];
        
        
        _enemyTypes = [CCArray arrayWithCapacity:2];
        [_enemyTypes addObject:[SGBat class]];
        [_enemyTypes addObject:[SGBug class]];
        
        [self generateRandomObstacles];
        [self schedule:@selector(spawnEnemies) interval:1.0f];
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

#define numObstacles 25
-(void)generateRandomObstacles
{
    for( int count = 0; count < numObstacles; count++ )
    {
        SGObstacle *newObstacle = [SGObstacle obstacle];
        
        [newObstacle setPosition:SGRandomScreenPoint()];
        
        [self addPhysicalBodyToSprite:newObstacle];
        [self addChild:newObstacle];
    }
}


#pragma mark - Level Config

-(void)tileOfType:(NSString *)tileType inTile:(CGPoint)tilePos
{
    //populate tiles based on map
}

-(void)spawnEnemies
{
    if( _enemyCount < 10 )
    {
        _enemyCount++;
        
        //Class enemyClass = [_enemyTypes randomObject];
        //SGEnemy *testBug = [enemyClass enemy];
        Class clusterClass = [SGBatCluster class];//TODO randomize
        SGFoeCluster *spawnedCluster = [[clusterClass alloc] init];
        
        CGPoint spawnPoint = SGRandomScreenPoint();

        //[testBug setPosition:spawnPoint];
        [spawnedCluster setPosition:spawnPoint];
        
        for (SGEnemy* minion in [spawnedCluster children]) {
            [self addPhysicalBodyToSprite:minion];
            [self addMover:minion];
        }
        
        //[self addPhysicalBodyToSprite:testBug];
        //[self addMover:testBug];
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
    }
    else
    {
        [localPlayer facePoint:touchPoint];

        [localPlayer fireWeapon];
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
    SGProjectile *casing = [projectile casing];
    
    if( casing != nil )
    {
        [self addChild:casing];
    }
    
    [self addChild:projectile];
    [projectile fired];
}

#pragma mark - Local Player Delegates

-(void)playerHasDied:(SGLocalPlayer *)player
{
    
}

-(void)playerMovedToPoint:(CGPoint)newPoint
{
//    [[self tileLayer] set]
}

#pragma mark physics

-(void)physicsSetup{
    //physicalSpace = cpSpaceNew();
    //physicalSpace = new b2World(b2Vec2(0.0, 0.0), false);
    physicalSpace = new b2World(b2Vec2(0.0, 0.0));
    listener = new MyContactListener();
    physicalSpace->SetContactListener(listener);
    [self schedule:@selector(physicsTick:)];
}

-(void)physicsTick:(ccTime)dt{
    @synchronized(self){
        physicalSpace->Step(dt, 10, 10);
        for(b2Body *b = physicalSpace->GetBodyList(); b; b=b->GetNext()) {
            if (b->GetUserData() != NULL) {
                CCSprite *sprite = (__bridge CCSprite *)b->GetUserData();
                
                b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                           sprite.position.y/PTM_RATIO);
                float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
                
                b->SetTransform(b2Position, b2Angle);
            }
        }
        
        std::vector<b2Body *>toDestroy;
        std::vector<MyContact>::iterator pos;
        for(pos = listener->_contacts.begin();
            pos != listener->_contacts.end(); ++pos) {
            MyContact contact = *pos;
            
            b2Body *bodyA = contact.fixtureA->GetBody();
            b2Body *bodyB = contact.fixtureB->GetBody();
            if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
                CCSprite *spriteA = (__bridge CCSprite *) bodyA->GetUserData();
                CCSprite *spriteB = (__bridge CCSprite *) bodyB->GetUserData();
                
                //CCLOG(@"collision between %@ and %@", spriteA, spriteB);
                
                toDestroy.push_back(bodyA);
                toDestroy.push_back(bodyB);

                /*
                if (spriteA.tag == 1 && spriteB.tag == 2) {
                    toDestroy.push_back(bodyA);
                } else if (spriteA.tag == 2 && spriteB.tag == 1) {
                    toDestroy.push_back(bodyA);
                }//*/
            }
        }
        
        //*
        std::vector<b2Body *>::iterator pos2;
        for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
            b2Body *body = *pos2;
            if (body->GetUserData() != NULL) {
                CCSprite *sprite = (__bridge CCSprite *) body->GetUserData();
                [[sprite parent] removeChild:sprite cleanup:YES];
            }else{
                physicalSpace->DestroyBody(body);
            }
        }//*/
    }
}

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
}//*/

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
}

@end
