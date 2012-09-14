//
//  SGDestroyable.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "CCSprite.h"
#import "chipmunk.h"

@class SGWeapon;

@interface SGDestroyable : CCSprite
{
    int health_;
    cpShape *destroyableShape;
}

@property(nonatomic, readonly) cpShape *destroyableShape;

+(NSString *)imagePath;
+(int)startingHealth;
+(SGDestroyable *)destroyable;

-(void)initializeHealth:(int)health;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

@end
