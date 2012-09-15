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

//@synthesize speed = speed_;


@end
