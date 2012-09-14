//
//  Header.h
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#ifndef ClusterFear_Header_h
#define ClusterFear_Header_h

#define PI 3.14159265358979

static uint32_t _x = 123456789;
static uint32_t _y = 362436069;
static uint32_t _z = 521288629;
static uint32_t _w = 88675123;

static void SGSetXorSeeds( uint32_t x, uint32_t y, uint32_t z, uint32_t w )
{
    _x = x;
    _y = y;
    _z = z;
    _w = w;
}

static uint32_t SGRand(void) {
    uint32_t t;
    
    t = _x ^ (_x << 11);
    _x = _y; _y = _z; _z = _w;
    return _w = _w ^ (_w >> 19) ^ (t ^ (t >> 8));
}

static float SGRandNormalized(void)
{
    return (float)(SGRand()/4294967296.0);
}

#endif
