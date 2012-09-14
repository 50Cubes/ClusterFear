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

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

-(void)moveToPoint:(CGPoint)targetPoint;
-(void)turnTowardPoint:(CGPoint)targetPoint;

@end
