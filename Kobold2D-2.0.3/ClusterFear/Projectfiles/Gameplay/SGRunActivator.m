//
//  SGRunActivator.m
//  ClusterFear
//
//  Created by Lev Trubov on 9/14/12.
//
//

#import "SGRunActivator.h"
#import "CCSprite.h"
#import "CCLayer.h"
#import "ccTypes.h"
#import "CCTouchDispatcher.h"

@implementation SGRunActivator

@synthesize isPressed = _isPressed;

+(SGRunActivator *)activatorWithOffset:(float)offset;
{
    SGRunActivator *activator = (SGRunActivator *)[self node];
    activator->offset = offset;
    return activator;
}

-(void)setup{
    ccColor4B mg = {ccGRAY.r, ccGRAY.g, ccGRAY.b, 196};
    
    
    CCLayerColor *color = [CCLayerColor layerWithColor:mg width:self.contentSize.width height:self.contentSize.height];
    [self addChild:color];
    
    CCSprite *menuButton = [CCSprite spriteWithFile:@"weaponicons.png" rect:CGRectMake(0, offset + 0, 128.0f, 64.0f)];
    CCSprite *menuDown = [CCSprite spriteWithFile:@"weaponicons.png" rect:CGRectMake(0, offset + 64.0f, 128.0f, 64.0f)];
    CCMenuItemSprite *weaponImage = [CCMenuItemSprite itemWithNormalSprite:menuButton selectedSprite:menuDown];
    
    [weaponImage setSize:[self contentSize]];
    
    [color addChild:weaponImage];
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    _isPressed = NO;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    _isPressed = NO;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL shouldClaimTouch = NO;
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    if([self containsPoint:location]){
        _isPressed = YES;
        shouldClaimTouch = YES;
    }
    
    return shouldClaimTouch;
}

@end
