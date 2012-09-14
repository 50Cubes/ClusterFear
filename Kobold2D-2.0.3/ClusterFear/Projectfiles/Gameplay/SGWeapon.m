//
//  SGWeapon.m
//  ClusterFear
//
//  Created by Lev Trubov on 9/14/12.
//
//

#import "SGWeapon.h"

@implementation SGWeapon

@synthesize damageInflicted;

-(id)init{
    if((self = [super init])){
        damageInflicted = 10;
    }
    
    return self;
}

@end
