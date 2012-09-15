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


-(void)crawl
{
    [super crawl];
    
    CCFiniteTimeAction *squirm = [CCSkewBy actionWithDuration:0.1247f skewX:0.45f skewY:-6.05f];
    CCFiniteTimeAction *squirm2 = [CCSkewBy actionWithDuration:0.2152f skewX:-8.35f skewY:-0.04f];
    CCFiniteTimeAction *squirm3 = [CCSkewBy actionWithDuration:0.1847f skewX:-0.15f skewY:9.05f];
    
    [self runAction:[CCSequence actions:squirm, squirm2, squirm3, [CCSkewTo actionWithDuration:0.1867f skewX:1.0f skewY:1.0f], nil]];
    
    CCFiniteTimeAction *flapDown = [CCScaleBy actionWithDuration:0.27f scaleX:0.95f scaleY:1.1f];
    
    [self runAction:[CCSequence actionOne:flapDown two:[flapDown reverse]]];
}

@end
