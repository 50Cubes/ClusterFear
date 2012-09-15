//
//  SGWeapon.h
//  ClusterFear
//
//  Created by Lev Trubov on 9/14/12.
//
//

#import <Foundation/Foundation.h>

@class SGMover;
@class SGDestroyable;

@interface SGWeapon : NSObject{
    int damageInflicted;
    
    
}

+(Class)projectileClass;
+(CGFloat)fireDelay;
+(NSUInteger)magazineSize;

+(float)range;

@property(readonly) int damageInflicted;

@property(nonatomic, unsafe_unretained)SGMover *owner;

+(SGWeapon *)weapon;

-(void)fire;
-(void)didDestroy:(SGDestroyable *)killedMover;

@end
