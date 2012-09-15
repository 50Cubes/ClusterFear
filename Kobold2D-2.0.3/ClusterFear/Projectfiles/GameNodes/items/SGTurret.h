//
//  SGTurret.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGDestroyable.h"

@interface SGTurret : SGDestroyable
{
    int ammo_;
}

@property (nonatomic, readonly)int ammo;

@end
