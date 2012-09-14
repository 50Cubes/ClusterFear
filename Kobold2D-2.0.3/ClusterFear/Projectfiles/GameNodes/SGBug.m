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

+(NSString *)imagePath
{
    return @"spider.png";
}

//@synthesize speed = speed_;


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
