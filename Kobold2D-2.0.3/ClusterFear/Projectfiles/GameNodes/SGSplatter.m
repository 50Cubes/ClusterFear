//
//  SGSplatter.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGSplatter.h"

@implementation SGSplatter


static CCArray *_pool = nil;
static CCArray *_roster = nil;

+(void)initialize
{
    if( self == [SGSplatter class] )
    {
        _pool = [CCArray arrayWithCapacity:64];
        _roster = [CCArray arrayWithCapacity:64];
    }
}

+(BOOL)returnToPool:(SGSplatter *)splatter;
{
    [_pool addObject:splatter];
    [_roster removeObject:splatter];
}

+(SGSplatter *)pooledSplatter
{
    SGSplatter *fromPool = nil;
    NSUInteger poolSize = [_pool count];
    if( poolSize > 0 )
    {
        fromPool = [_pool lastObject];
        [_pool removeLastObject];
    }
    else if( [_roster count] >= 64 )
    {
        fromPool = [_roster objectAtIndex:0];
        [_roster removeObjectAtIndex:0];
        
        [fromPool unscheduleAllSelectors];
        [fromPool stopAllActions];
        
        [fromPool removeFromParentAndCleanup:NO];
    }
    return fromPool;
}

+(SGSplatter *)splatterFromSpray:(SGSpray *)spray
{
    SGSplatter *splatter = [self pooledSplatter];
    if( splatter == nil )
    {
        splatter = [self spriteWithTexture:[spray splatterTexture]];
        [_roster addObject:splatter];
    }
    
    [splatter setOpacity:128 * CCRANDOM_0_1()];
    [splatter setPosition:[spray position]];
    
    [splatter setRotation:CCRANDOM_MINUS1_1() * [spray rotation]];
    
//    splatter->lifeTime = 120.0f;
    [splatter scheduleOnce:@selector(repool) delay:45.30f];
    
    return splatter;
}

-(void)doRepool
{
    [self removeFromParentAndCleanup:NO];
    [[self class] returnToPool:self];
}

-(void)repool
{
    [self runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:0.47f opacity:0] two:[CCCallFunc actionWithTarget:self selector:@selector(doRepool)]]];
}

//-(void)onEnter
//{
//    [super onEnter];
//    
////    [self scheduleUpdate];
//}

@end
