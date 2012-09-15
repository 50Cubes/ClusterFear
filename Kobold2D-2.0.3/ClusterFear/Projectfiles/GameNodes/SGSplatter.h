//
//  SGSplatter.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/15/12.
//
//

#import "SGDecal.h"

#import "SGSpray.h"

@interface SGSplatter : SGDecal
{
//    float lifeTime;
}


+(SGSplatter *)splatterFromSpray:(SGSpray *)spray;



@end
