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

+(SGEnemy *)enemyForCluster:(SGFoeCluster *)cluster
{
    SGEnemy *rtnEnemy = [self enemy];
    [rtnEnemy setCluster:cluster];
    return rtnEnemy;
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


-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];
    if( self != nil )
    {
        //        actionManager_ = [[CCActionManager alloc] init];
        //        speed_ = 50.0f;
        
        [self setOpacity:0];
        
        [self runAction:[CCFadeIn actionWithDuration:1.0f]];
        [self scheduleOnce:@selector(crawl) delay:1.0f];
        
        [self scheduleOnce:@selector(die) delay:1200.0f];
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
    CGPoint parentDirection = [[self cluster] forwardDirection];
    
    [super faceRelativePoint:ccpNormalize(ccpAdd(parentDirection, normalizedRelativeDirection))];
}

-(CCFiniteTimeAction *)nextAction
{
    float randomDirection = 2 * PI * CCRANDOM_0_1();
    
    float speed = [[self class] speed];
    CGPoint moveDirection = CGPointMake(speed * sinf(randomDirection), speed * cosf(randomDirection));
    
    [self faceRelativePoint:moveDirection];
    
    return [CCMoveTo actionWithDuration:1.25f position:moveDirection];
}

-(void)getHitFromWeapon:(SGWeapon *)weapon
{
    [_cluster memberStruck:self withWeapon:weapon];
    
    [super getHitFromWeapon:weapon];
}

-(void)die
{
    [[self cluster] memberDied:self];
    
    [super die];
}

-(void)afterBounce{
    [self crawl];
}

@end
