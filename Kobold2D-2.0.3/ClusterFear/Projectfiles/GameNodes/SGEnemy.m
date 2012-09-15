//
//  SGEnemy.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

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
    return [self spriteWithFile:[self imagePath]];
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
        
        [self scheduleOnce:@selector(die) delay:12.0f];
    }
    return self;
}



-(void)crawl
{
    CCSequence *sequencedAction = [CCSequence actionOne:[self nextAction] two:[CCCallFunc actionWithTarget:self selector:@selector(crawl)]];
    [self runAction:sequencedAction];
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

@end
