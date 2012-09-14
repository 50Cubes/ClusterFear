//
//  SGBug.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGBug.h"
#import "SGRandomization.h"

@interface SGBug ()
{
//    CCSequence *_sequence; //need a custom action which returns the random movement / delegates for it
}

@end

@implementation SGBug

@synthesize speed = speed_;

-(id)init
{
    self = [super init];
    if( self != nil )
    {
        actionManager_ = [[CCActionManager alloc] init];
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
    float randomDirection = 2 * PI * SGRandNormalized();
    
    CGPoint nextPosition = position_;
    
    nextPosition.x += speed_ * sinf(randomDirection);
    nextPosition.y += speed_ * cosf(randomDirection);
    
    return [CCMoveTo actionWithDuration:2.0f position:nextPosition];
}

@end
