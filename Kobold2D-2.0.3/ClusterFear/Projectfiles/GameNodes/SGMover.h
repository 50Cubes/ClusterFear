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

+(float)speed;

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth;

-(void)getHitFromWeapon:(SGWeapon *)weapon;
-(void)die;

-(void)facePoint:(CGPoint)pointToFace;
-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection;
-(void)moveToPoint:(CGPoint)targetPoint;

@end
