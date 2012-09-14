//
//  SGLocalPlayer.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"

@interface SGLocalPlayer : SGMover{
    //SGWeapon *weapon;
}

-(void)moveToPoint:(CGPoint)targetPoint;

@end
