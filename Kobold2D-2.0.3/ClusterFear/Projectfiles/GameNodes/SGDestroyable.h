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

+(NSString *)imagePath;
+(SGDestroyable *)destroyable;

-(void)initializeHealth:(int)health;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

@end
