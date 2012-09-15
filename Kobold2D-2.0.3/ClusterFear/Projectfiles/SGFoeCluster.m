//
//  FoeCluster.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/13/12.
//
//

#import "SGFoeCluster.h"
#import "SGRandomization.h"

#import "SGProjectile.h"

#define EXPECTED_NUM_CLUSTER_TYPES 5
static NSMutableDictionary *statDict=nil;

@implementation SGFoeCluster

@synthesize health = _health;

@synthesize minions = _minions;

+(NSString *)keyPath
{
    return [NSString stringWithFormat:@"%@%@",@"SGFoeStats.",[self description]];
}
+(SGFoeCluster *)foeCluster
{
    return [[self alloc] init];
}

+(Class)minionClass
{
    return [SGEnemy class];
}

+(SGFoeStats*)getStats
{
    return [self findStats];
}

+(SGFoeStats *)findStats
{
    if(nil == statDict){
        statDict = [NSMutableDictionary dictionaryWithCapacity:EXPECTED_NUM_CLUSTER_TYPES];
    }
    
    SGFoeStats *newStats = [statDict objectForKey:self];
    if(nil==newStats){
        // Build path string
        NSString* configPath = [self keyPath];
        // Set the config lookup path
        SGFoeStats *someStats = [[SGFoeStats alloc] initWithKeyPath:configPath];
        
        if( someStats != nil )
        {
            if( someStats->maxHealth > 0 )
            {
                newStats = someStats;
                [statDict setObject:newStats forKey:self];
            }
        }
    }

    return newStats;
}

@synthesize velocity = velocity_;
@synthesize destination = destination_;

-(id)init
{
    SGFoeStats *myStats = [[self class] getStats];
    if( myStats != nil )
    {
        self = [super init];
        if( self != nil )
        {
            _health = myStats->maxHealth;
            [self populate];
        }
    }
    else
        self = nil;

    return self;
}

-(float)radius
{
    return 128.0f;
}

-(float)speed
{
    return [[self class] getStats]->moveSpeed;
}

-(CGPoint)velocity
{
    return velocity_;
}

-(void)populate
{
    [self schedule:@selector(chainSpawnMinions) interval:0.167f];
}


-(void)chainSpawnMinions
{
    BOOL unschedule = NO;
    
    NSUInteger numMinions = [self minionCount];
    NSUInteger limit = [self minionLimit];
    
    unschedule = numMinions > limit;
    if( !unschedule )
    {
        
        Class minionClass = [[self class] minionClass];
                if( minionClass != nil )
        {
            SGEnemy *minion;
            if(numMinions == limit && (limit % 3) == 0)
            {
                unschedule = YES;
                minion = [minionClass bossForCluster:self];
            }
            else
            {
                minion = [minionClass enemyWithStrength:CCRANDOM_0_1()];
                [minion setCluster:self];
            }
            
            [_minions addObject:minion];
            [self addChild:minion];
        }
    }
    
    if( unschedule )
        [self unschedule:@selector(chainSpawnMinions)];
}

//-(SGFoeCluster *)initWithStats:(GBFoeStats *)stats
//{
//    self = [super init];
//    if( self != nil )
//    {
//        
//    }
//    
//    return self;
//}

-(NSUInteger) minionLimit{
    return [[self class] getStats]->maxCritters;
}
-(NSUInteger) minionCount{
    return [[self children] count];
}

-(BOOL)memberStruck:(SGEnemy *)member withProjectile:(SGProjectile *)projectile
{
    if( _health > 0 )
    {
        [_owner foeCluster:self hitByProjectile:projectile];
        uint damage = (uint) [[projectile weapon] damageInflicted];
        if (_health <= damage)
        {
            _health = 0;
            [_owner foeClusterDestroyed:self];
            return YES;
        }
        // else
        _health-=damage;
        
        [self checkForMinion:member];
    }
    return NO;
}

-(void)memberDied:(SGEnemy *)member
{
    [_minions removeObject:member];
}

-(void)checkForMinion:(SGEnemy*)memberStruck{
    SGFoeStats *myStats = [[self class] getStats];
    float ratio = _health/((float)myStats->maxHealth);
    float fractionalMinions = ratio * myStats->maxCritters;
    uint numMinions = (uint)fractionalMinions;
    if ([self minionCount] > numMinions) {
        [self removeChild:memberStruck cleanup:YES];
    }
}


-(void)onEnter
{
    [super onEnter];
    
    [self crawl];
}

-(void)crawl
{
    CCSequence *sequencedAction = [CCSequence actionOne:[self nextAction] two:[CCCallFunc actionWithTarget:self selector:@selector(crawl)]];
    
    
    [self notifyMinionsOfPathChange];
    
    [self runAction:sequencedAction];
}

-(void)notifyMinionsOfPathChange
{
    [children_ makeObjectsPerformSelector:@selector(reorient)];
}

-(CCFiniteTimeAction *)nextAction
{
    float randomDirection = 2 * PI * CCRANDOM_0_1();
    
    CGPoint playerPosition = [_owner foeClusterRequestsPlayerLocation:self];
    
    playerPosition = ccpSub(playerPosition, position_);
    
    ccpMult(playerPosition, 0.005f);
    
    float speed = [self speed];
    CGPoint moveDirection = CGPointMake(speed * sinf(randomDirection), speed * cosf(randomDirection));
    
    moveDirection = ccpAdd(moveDirection, playerPosition);
    
    ccTime moveTime = 22.25f;
    
    velocity_ = ccpMult(moveDirection, 1.0f/moveTime);
    
    destination_ = moveDirection;

    return [CCMoveBy actionWithDuration:moveTime position:moveDirection];
}
@end

@implementation SGFoeStats

-(id)initWithKeyPath:(NSString *)keyPath{
    if(self=[super init]){
        if([KKConfig selectKeyPath:keyPath]){
            self->damage = [KKConfig intForKey:@"Damage"];
            self->maxCritters = [KKConfig intForKey:@"MaxCritters"];
            self->maxHealth = [KKConfig intForKey:@"MaxHealth"];
            self->moveSpeed = [KKConfig floatForKey:@"MoveSpeed"];
        }
        else{
            NSLog(@"SGFoeStats.getStatsByClassName: %@ not found by KKConfig.selectKeyPath.",keyPath);
//            [self release];
            self = nil;
        }
    }
    return self;
}

@end