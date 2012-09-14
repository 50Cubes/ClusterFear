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

-(void)setup{
    ccColor4B mg = {ccMAGENTA.r, ccMAGENTA.g, ccMAGENTA.b, 255};
    
    CCLayerColor *color = [CCLayerColor layerWithColor:mg width:self.contentSize.width height:self.contentSize.height];
    [self addChild:color];
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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
