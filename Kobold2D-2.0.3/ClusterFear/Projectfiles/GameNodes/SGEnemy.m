//
//  SGEnemy.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite+Convenience.h"

#import "SGEnemy.h"
#import "SGFoeCluster.h"

#import "SGRandomization.h"

@implementation SGEnemy

+(NSString *)imagePath
{
    return @"spider_small.png";
}

+(SGEnemy *)enemyWithStrength:(float)strength
{
    SGEnemyTier tier = SGEnemyTier_Grunt;
    if( strength > 0.96f )
        tier = SGEnemyTier_Boss;
    else if( strength > 0.6f )
        tier = SGEnemyTier_Elite;
    return [self enemyWithTier:tier];
}

+(SGEnemy *)enemyForCluster:(SGFoeCluster *)cluster
{
    SGEnemy *rtnEnemy = [self enemy];
    [rtnEnemy setCluster:cluster];
    return rtnEnemy;
}

+(SGEnemy *)bossForCluster:(SGFoeCluster *)cluster
{
    SGEnemy *enemy = [self enemyWithTier:SGEnemyTier_Boss];
    
    [enemy setCluster:cluster];
    
    return enemy;
}

+(SGEnemy *)enemyWithTier:(SGEnemyTier)tier
{
    return [self spriteWithTexture:[self textureWithTier:tier]];
}

+(SGEnemy *)enemy
{
    //return [self spriteWithFile:[self imagePath]];
    return [self moverWithFile:[self imagePath] andHealth:20];
}

+(SGEnemy *)enemyAtSize
{
    return [self enemy];
}

+(CCTexture2D *)textureWithTier:(SGEnemyTier)tier
{
    return [[CCTextureCache sharedTextureCache] addImage:[self imagePath]];
}


-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];
    if( self != nil )
    {
        //        actionManager_ = [[CCActionManager alloc] init];
        //        speed_ = 50.0f;
        
        currentSpeed_ = 1.0f;
        
        [self setOpacity:0];
        
        [self runAction:[CCFadeIn actionWithDuration:0.657f]];
        [self scheduleOnce:@selector(crawl) delay:0.75f];
        
//        [self scheduleOnce:@selector(die) delay:1200.0f];
    }
    return self;
}



-(void)crawl
{
    CCSequence *sequencedAction = [CCSequence actionOne:[self nextAction] two:[CCCallFunc actionWithTarget:self selector:@selector(crawl)]];
    [self runAction:sequencedAction];
}

-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection
{
    SGFoeCluster *myCluster = [self cluster];
    CGPoint parentDirection = [myCluster destination];
    
    parentDirection = ccpNormalize(ccpSub(ccpAdd(parentDirection, destination_), position_));
    
    [super faceRelativePoint:parentDirection];
}

-(void)reorient
{
    [self faceRelativePoint:[self forwardDirection]];
}

-(float)speed
{
    return [[self cluster] speed];
}

-(CCFiniteTimeAction *)nextAction
{
    float randomDirection = 2 * PI * CCRANDOM_0_1();
    
    float radius = [[self cluster] radius];
    float speed = [self speed];
    
    float distance = radius * CCRANDOM_0_1();
    CGPoint moveDirection = CGPointMake(distance * sinf(randomDirection), distance * cosf(randomDirection));
    
    
    speed *= (0.5f + (0.5f * CCRANDOM_0_1()));
    ccTime flyTime = distance / speed;
    
    currentSpeed_ = speed;
    
    [self faceRelativePoint:moveDirection];
    
    return [CCMoveTo actionWithDuration:flyTime position:moveDirection];
}

-(void)getHitFromProjectile:(SGProjectile *)projectile
{
    [super getHitFromProjectile:projectile];
    
    [_cluster memberStruck:self withProjectile:projectile];
}

-(void)die
{
    [[self cluster] memberDied:self];
    
    [self stopAllActions];
    
    CCFiniteTimeAction *defalteAction = [CCScaleTo actionWithDuration:0.327f scaleX:0.35f scaleY:0.78f];
    
    [self runAction:[CCSequence actionOne:defalteAction two:[CCCallFunc actionWithTarget:self selector:@selector(fadeAway)]]];
}

-(void)fadeAway
{
    [super die];
}

-(void)afterBounce{
    [self crawl];
}

@end
