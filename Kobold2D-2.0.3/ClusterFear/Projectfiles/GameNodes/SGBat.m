//
//  SGBat.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGBat.h"

@implementation SGBat

+(NSString *)imagePath
{
    NSString *asset = kSGBatAssetSmall;
    
    float roll = CCRANDOM_0_1();
    
    if( roll > 0.98f )
        asset = kSGBatAssetLarge;
    else if( roll > 0.8f )
        asset = kSGBatAssetMedium;
    
    return asset;
}

+(CCTexture2D *)textureWithTier:(SGEnemyTier)tier
{
    NSString *spiderSize;
    switch (tier) {
        case SGEnemyTier_Grunt:
            spiderSize = kSGBatAssetSmall;
            break;
        case SGEnemyTier_Elite:
            spiderSize = kSGBatAssetMedium;
            break;
        case SGEnemyTier_Boss:
            spiderSize = kSGBatAssetLarge;
            break;
            
        default:
            break;
    }
    
    return [[CCTextureCache sharedTextureCache] addImage:spiderSize];
}

+(float)speed
{
    return 100.0f;
}

-(void)crawl
{
    [super crawl];
    
    CCFiniteTimeAction *flapDown = [CCScaleBy actionWithDuration:0.27f scaleX:0.8f scaleY:0.3f];
    
    [self runAction:[CCSequence actionOne:flapDown two:[flapDown reverse]]];
}

@end
