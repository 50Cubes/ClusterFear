//
//  SGDestroyable.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"

@class SGWeapon;

@interface SGDestroyable : CCSprite
{
    int health_;
}

+(SGDestroyable *)destroyable;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

@end
