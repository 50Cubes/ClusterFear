//
//  FoeCluster.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/13/12.
//
//

#import "SGFoeCluster.h"
#import "SGRandomization.h"

#define EXPECTED_NUM_CLUSTER_TYPES 5
static NSMutableDictionary *statDict=nil;

@implementation SGFoeCluster

@synthesize health = _health;

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

-(id)init
{
    SGFoeStats *myStats = [[self class] getStats];
    if( myStats != nil )
    {
        self = [super init];
        if( self != nil )
        {
            [self populate];
        }
    }
    else
        self = nil;

    return self;
}

-(void)populate
{
    Class minionClass = [[self class] minionClass];
    for( int numCrits = [self minionLimit]; numCrits > 0; numCrits-- )
    {
        SGEnemy *minion = [minionClass enemyForCluster:self];
        if( minionClass != nil )
        {
            [self addChild:minion];
        }
    }
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

-(BOOL)memberStruck:(SGEnemy *)member withWeapon:(SGWeapon *)weaponStriking{
    uint damage = (uint) [weaponStriking damageInflicted];
    if (_health <= damage) {
        _health = 0;
        return YES;
    }
    // else
    _health-=damage;
    [self checkForMinion:member];
    return NO;
}

-(void)memberDied:(SGEnemy *)member
{
    
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


-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection
{
    float rotation = atan2f(normalizedRelativeDirection.y,-normalizedRelativeDirection.x);
    
    rotation = CC_RADIANS_TO_DEGREES(rotation);
    if( rotation != self->rotation_ )
    {
        //[self setRotation:rotation];
        //        NSLog(@"Rotated to %f degress with x: %f y: %f", CC_RADIANS_TO_DEGREES(rotation), xDirection, yDirection);
        [self runAction:[CCRotateTo actionWithDuration:0.2 angle:rotation]];
    }
}

-(void)crawl
{
    CCSequence *sequencedAction = [CCSequence actionOne:[self nextAction] two:[CCCallFunc actionWithTarget:self selector:@selector(crawl)]];
    [self runAction:sequencedAction];
}

-(CCFiniteTimeAction *)nextAction
{
    float randomDirection = 2 * PI * CCRANDOM_0_1();
    
    float speed = [[[self class] minionClass] speed];
    CGPoint moveDirection = CGPointMake(speed * sinf(randomDirection), speed * cosf(randomDirection));
    
    [self faceRelativePoint:moveDirection];
    
    return [CCMoveBy actionWithDuration:3.25f position:moveDirection];
}
@end

@implementation SGFoeStats

-(id)initWithKeyPath:(NSString *)keyPath{
    if(self=[super init]){
        if([KKConfig selectKeyPath:keyPath]){
            self->damage = [KKConfig intForKey:@"Damage"];
            self->maxCritters = [KKConfig intForKey:@"MaxCritters"];
            self->maxHealth = [KKConfig intForKey:@"MaxHealth"];
            self->moveSpeed = [KKConfig intForKey:@"Damage"];
        }
        else{
            NSLog(@"SGFoeStats.getStatsByClassName: %@ not found by KKConfig.selectKeyPath.",self);
//            [self release];
            self = nil;
        }
    }
    return self;
}

@end