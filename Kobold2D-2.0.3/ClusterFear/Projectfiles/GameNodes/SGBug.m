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

//@synthesize speed = speed_;

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
    
    return [CCMoveBy actionWithDuration:2.0f position:moveDirection];
}

@end
