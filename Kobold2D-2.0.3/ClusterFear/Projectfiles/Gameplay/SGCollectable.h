//
//  SGCollectable.h
//  ClusterFear
//
//  Created by Katherine Geiger on 9/15/12.
//
//

#import "CCSprite.h"
#import "SGLocalPlayer.h"

@interface SGCollectable : CCSprite
{
    int reward_;
}

+(SGCollectable *)collectable;

@property (nonatomic, readonly)int reward;

-(void)playerCollectedReward:(SGLocalPlayer *)player;

@end
