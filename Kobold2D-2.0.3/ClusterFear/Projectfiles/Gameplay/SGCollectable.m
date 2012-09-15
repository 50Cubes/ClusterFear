//
//  SGCollectable.m
//  ClusterFear
//
//  Created by Katherine Geiger on 9/15/12.
//
//

#import "SGCollectable.h"

@implementation SGCollectable

static CCTexture2D *coinTexture = nil;
+(CCTexture2D *)texture
{
    if( coinTexture == nil )
        coinTexture = [[CCTextureCache sharedTextureCache] addImage:@"coin.png"];
    return coinTexture;
}

+(SGCollectable *)collectable
{
    return [self spriteWithTexture:[self texture]];
}

@synthesize reward = reward_;

//-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
//{
//    self = [super initWithTexture:texture rect:rect rotated:rotated];
//    if( self != nil )
//    {
//        _active = YES;
//    }
//    return self;
//}

-(void)onEnter
{
    [super onEnter];
    
    if( reward_ <= 0 )
        reward_ = 100 * CCRANDOM_0_1();
}

-(void)playerCollectedReward:(SGLocalPlayer *)player
{
    
}

@end
