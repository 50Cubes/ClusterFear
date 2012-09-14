//
//  SGEnemy.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"

@interface SGEnemy : SGMover

+(SGEnemy *)enemy;
+(NSString *)imagePath;


-(CCFiniteTimeAction *)nextAction;

@end
