//
//  SGWeapon.h
//  ClusterFear
//
//  Created by Lev Trubov on 9/14/12.
//
//

#import <Foundation/Foundation.h>

@class SGMover;

@interface SGWeapon : NSObject{
    int damageInflicted;
    
    
}

+(Class)projectileClass;
+(CGFloat)fireDelay;
+(NSUInteger)magazineSize;

@property(readonly) int damageInflicted;

@property(nonatomic, unsafe_unretained)SGMover *owner;


-(void)fire;

@end
