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
    NSString *spiderSize = @"spider_small.png";
    
    float roll = CCRANDOM_0_1();
    if( roll > 0.95f )
        spiderSize = @"spider_large.png";
    else if( roll > 0.5f )
        spiderSize = @"spider_medium.png";
    
    return spiderSize;
}

+(CCTexture2D *)textureWithTier:(SGEnemyTier)tier
{
    NSString *spiderSize;
    switch (tier) {
        case SGEnemyTier_Grunt:
            spiderSize = @"spider_small.png";
            break;
        case SGEnemyTier_Elite:
            spiderSize = @"spider_medium.png";
            break;
        case SGEnemyTier_Boss:
            spiderSize = @"spider_large.png";
            break;
            
        default:
            break;
    }
    
    return [[CCTextureCache sharedTextureCache] addImage:spiderSize];
}

//@synthesize speed = speed_;

-(void)onEnter
{
    [super onEnter];
    
    [self scheduleUpdate];
}

-(void)crawl
{    
    [super crawl];
    
//    CCFiniteTimeAction *squirm = [CCSkewBy actionWithDuration:0.1747f skewX:0.45f skewY:-6.05f];
//    CCFiniteTimeAction *squirm2 = [CCSkewBy actionWithDuration:0.1852f skewX:-8.35f skewY:-0.04f];
//    CCFiniteTimeAction *squirm3 = [CCSkewBy actionWithDuration:0.1247f skewX:-0.15f skewY:9.05f];
//    CCFiniteTimeAction *squirm4 = [CCSkewBy actionWithDuration:0.2847f skewX:-1.15f skewY:-0.85f];
//    CCSequence *mainSequence = [CCSequence actions:squirm, squirm2, squirm3, nil];
    
//    [self runAction:[CCSequence actions:mainSequence, [CCSkewTo actionWithDuration:0.167f skewX:1.0f skewY:1.0f], nil]];
    
    CCFiniteTimeAction *flapDown = [CCScaleBy actionWithDuration:0.27f scaleX:0.95f scaleY:1.1f];
    
    [self runAction:[CCSequence actionOne:flapDown two:[flapDown reverse]]];
}

#define skewLimit 12.0f

-(void)update:(ccTime)dT
{
    float xTarget = 1.0f;
    float yTarget = 1.0f;
    
    float currentX = skewX_;
    float currentY = skewY_;
    
    int count = 2;
    
//    float adjustedSkewLimit = skewLimit * dT;
    
    switch( crawlPhase )
    {
        case 0:
            
            if( currentY < skewLimit)
            {
                count--;
                yTarget = skewLimit;
            }
            
            if( currentX > -skewLimit)
            {
                count--;
                xTarget = -skewLimit;
            }
            
            break;
            
        case 1:
            
            if( currentY > -skewLimit)
            {
                count--;
                yTarget = -skewLimit;
            }
            
            if( currentX < skewLimit)
            {
                count--;
                xTarget = skewLimit;
            }
            break;
//        case 2:
//            
//            if( currentY < skewLimit)
//            {
//                count--;
//                yTarget = skewLimit;
//            }
//            
//            if( currentX > -skewLimit)
//            {
//                count--;
//                xTarget = -skewLimit;
//            }
//            break;
//            
//            if( currentY < skewLimit)
//            {
//                count--;
//                yTarget = skewLimit;
//            }
//            
//            if( currentX > -skewLimit)
//            {
//                count--;
//                xTarget = -skewLimit;
//            }
//        case 3:
            
            break;
    }
    
    if( count <= 0 )
        crawlPhase = ((crawlPhase + 1) % 2);
    
    float adjust = dT * 7.65f;
    xTarget = currentX + ((xTarget - currentX) * adjust);
    yTarget = currentY + ((yTarget - currentY) * adjust);
    
//    NSLog(@"Skewing bugs with x %f and y %f", xTarget, yTarget);
    [self setSkewX:xTarget];
    [self setSkewY:yTarget];
}

-(void)die
{
    [self unscheduleUpdate];
    
    [super die];
}

@end
