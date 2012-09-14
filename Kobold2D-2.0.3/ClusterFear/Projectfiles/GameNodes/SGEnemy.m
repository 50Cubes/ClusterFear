//
//  SGEnemy.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGEnemy.h"

@implementation SGEnemy

+(NSString *)imagePath
{
    return @"spider.png";
}

+(SGEnemy *)enemy
{
    return [self spriteWithFile:[self imagePath]];
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
        
        [self scheduleOnce:@selector(die) delay:15.0f];
    }
    return self;
}

@end
