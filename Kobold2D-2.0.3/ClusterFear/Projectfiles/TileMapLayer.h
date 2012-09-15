/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "cocos2d.h"

enum
{
	TileMapNode = 0,
};

@protocol TileMapLayerDelegate <NSObject>

-(void)tileOfType:(NSString *)tileType inTile:(CGPoint)tilePos;

-(void)touchAtPoint:(CGPoint)touchPoint inTile:(CGPoint)tilePos;

@end

@interface TileMapLayer : CCLayer
{
	float tileMapHeightInPixels;
}

@property (nonatomic, unsafe_unretained)NSObject <TileMapLayerDelegate> *delegate;

+(id) node;

@end
