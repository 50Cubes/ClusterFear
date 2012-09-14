//
//  SGMover.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"

@class SGWeapon;

@interface SGMover : CCSprite{
    int health;
}

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

@end
