/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "TileMapLayer.h"
//#import "SimpleAudioEngine.h"


#import "SGMover.h"
#import "SGBug.h"

@implementation TileMapLayer

+(id) node
{
//	CCScene *scene = [CCScene node];
	TileMapLayer *layer = [[TileMapLayer alloc] init];
//	[scene addChild: layer];
	return layer;
}

-(id) init
{
	if ((self = [super init]))
	{
		CCTMXTiledMap* tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"orthogonal.tmx"];
        
        
		tileMapHeightInPixels = tileMap.mapSize.height * tileMap.tileSize.height / CC_CONTENT_SCALE_FACTOR();
		[self addChild:tileMap z:-1 tag:TileMapNode];
		
		// Use a negative offset to set the tilemap's start position
		//tileMap.position = CGPointMake(-160, -120);

		// hide the event layer, we only need this information for code, not to display it
		//CCTMXLayer* eventLayer = [tileMap layerNamed:@"GameEventLayer"];
		//eventLayer.visible = NO;

		//CCTMXLayer* winterLayer = [tileMap layerNamed:@"WinterLayer"];
		//winterLayer.visible = NO;

#if KK_PLATFORM_IOS
		self.isTouchEnabled = YES;
#elif KK_PLATFORM_MAC
		self.isMouseEnabled = YES;
#endif

		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"alien-sfx.caf"];
	}

	return self;
}

-(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
	// Tilemap position must be added as an offset, in case the tilemap position is not at 0,0 due to scrolling
	CGPoint pos = ccpSub(location, tileMap.position);
	
	// scaling tileSize to Retina display size if necessary
	float scaledWidth = tileMap.tileSize.width / CC_CONTENT_SCALE_FACTOR();
	float scaledHeight = tileMap.tileSize.height / CC_CONTENT_SCALE_FACTOR();
	// Cast to int makes sure that result is in whole numbers, tile coordinates will be used as array indices
	pos.x = (int)(pos.x / scaledWidth);
	pos.y = (int)((tileMap.mapSize.height * tileMap.tileSize.height - pos.y) / scaledHeight);
	
	//CCLOG(@"touch at (%.0f, %.0f) is at tileCoord (%i, %i)", location.x, location.y, (int)pos.x, (int)pos.y);
	
	// make sure coordinates are within bounds
	pos.x = fminf(fmaxf(pos.x, 0), tileMap.mapSize.width - 1);
	pos.y = fminf(fmaxf(pos.y, 0), tileMap.mapSize.height - 1);
	
	return pos;
}

-(CGRect) getRectFromObjectProperties:(NSDictionary*)dict tileMap:(CCTMXTiledMap*)tileMap
{
	float x, y, width, height;
	x = [[dict valueForKey:@"x"] floatValue] + tileMap.position.x;
	y = [[dict valueForKey:@"y"] floatValue] + tileMap.position.y;
	width = [[dict valueForKey:@"width"] floatValue];
	height = [[dict valueForKey:@"height"] floatValue];
	
	return CGRectMake(x, y, width, height);
}


-(void) tilemapTouchedAt:(CGPoint)location
{
	CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
	
	// get the position in tile coordinates from the touch location
	CGPoint tilePos = [self tilePosFromLocation:location tileMap:tileMap];
	
	// move tilemap so that touched tiles is at center of screen
	//[self centerTileMapOnTileCoord:tilePos tileMap:tileMap];
	
    /*
	// Check if the touch was on water (eg. tiles with isWater property drawn in GameEventLayer)
	bool isTouchOnWater = NO;
	CCTMXLayer* eventLayer = [tileMap layerNamed:@"GameEventLayer"];
	int tileGID = [eventLayer tileGIDAt:tilePos];
	
	if (tileGID != 0)
	{
		NSDictionary* properties = [tileMap propertiesForGID:tileGID];
		if (properties)
		{
			NSString* isWaterProperty = [properties valueForKey:@"isWater"];
			isTouchOnWater = ([isWaterProperty boolValue] == YES);
		}
	}//*/
	
    [[self delegate] touchAtPoint:location inTile:tilePos];

}


#if KK_PLATFORM_IOS

-(CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView:[touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// get the position in tile coordinates from the touch location
	CGPoint location = [self locationFromTouch:[touches anyObject]];
	[self tilemapTouchedAt:location];
}

#elif KK_PLATFORM_MAC

-(BOOL) ccMouseDown:(NSEvent*)event
{
	CGPoint location = [[CCDirector sharedDirector] convertEventToGL:event];
	[self tilemapTouchedAt:location];
	return YES;
}

#endif

/*

#ifdef DEBUG
-(void) drawRect:(CGRect)rect
{
	// Because there is no specialized rect drawing method the rect is drawn using 4 lines
	CGPoint pos1, pos2, pos3, pos4;
	pos1 = CGPointMake(rect.origin.x, rect.origin.y);
	pos2 = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
	pos3 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	pos4 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
	
	ccDrawLine(pos1, pos2);
	ccDrawLine(pos2, pos3);
	ccDrawLine(pos3, pos4);
	ccDrawLine(pos4, pos1);
}

// Draw the object rectangles for debugging and illustration purposes.
-(void) draw
{
	CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
	
	// get the object layer
	CCTMXObjectGroup* objectLayer = [tileMap objectGroupNamed:@"ObjectLayer"];
	NSAssert([objectLayer isKindOfClass:[CCTMXObjectGroup class]], @"ObjectLayer not found or not a CCTMXObjectGroup");
	
	NSUInteger numObjects = [[objectLayer objects] count];
	for (NSUInteger i = 0; i < numObjects; i++)
	{
		NSDictionary* properties = [[objectLayer objects] objectAtIndex:i];
		CGRect rect = [self getRectFromObjectProperties:properties tileMap:tileMap];
		[self drawRect:rect];
	}

	// show center screen position
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CGPoint center = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
	ccDrawCircle(center, 10, 0, 8, NO);
}
#endif//*/

@end
