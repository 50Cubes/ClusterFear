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
    
    if( roll > 0.95f )
        asset = kSGBatAssetLarge;
    else if( roll > 0.7f )
        asset = kSGBatAssetMedium;
    
    return asset;
}

+(float)speed
{
    return 100.0f;
}

@end
