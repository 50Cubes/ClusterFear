//
//  SGMover.m
//  ClusterFear
//
//  Created by Kevin Stich on 9/14/12.
//
//

#import "SGMover.h"
#import "SGWeapon.h"

#import "SGProjectile.h"

#import "SGSpray.h"

@implementation SGProjectile (SkeazePosition)

-(void)hackForGameJam
{
    float radRot = CC_DEGREES_TO_RADIANS(self->rotation_);
    self->position_.x += 12.0f * cosf(-radRot);
    self->position_.y -= 1.0f * sinf(radRot);
}

@end

@interface SGMover ()

@end

@implementation SGMover

+(float)speed
{
    return 10.0f;
}


//@synthesize velocity = velocity_;
@synthesize currentSpeed = currentSpeed_;

-(BOOL)isEnemy
{
    return YES;
}

-(CGPoint)velocity
{
    return ccpMult([self forwardDirection], currentSpeed_);
}

-(void)fireProjectile:(SGProjectile *)projectile
{
    [projectile setPosition:position_];
    [projectile setRotation:rotation_];
    
    [projectile hackForGameJam];
    
    [[self owner] mover:self firedProjectile:projectile];
}


-(float)facePoint:(CGPoint)pointToFace
{
    float xDirection = pointToFace.x;
    float yDirection = pointToFace.y;
    
    xDirection -= position_.x;
    yDirection -= position_.y;
    
#ifdef DEBUG
    if( isnan(xDirection) || isnan(yDirection) )
        NSLog(@"Invalid position");
#endif
    
    float magnitude = sqrtf(xDirection * xDirection + yDirection * yDirection);
    
    float normXDirection = xDirection / magnitude;
    float normYDirection = yDirection / magnitude;
    
    [self faceRelativePoint:(CGPoint){.x=normXDirection,.y=normYDirection}];
    
    return magnitude;
//    return (CGPoint){.x=xDirection, .y=yDirection};
}

-(CCFiniteTimeAction *)actionToFacePoint:(CGPoint)pointToFace
{
    float xDirection = pointToFace.x;
    float yDirection = pointToFace.y;
    
    xDirection -= position_.x;
    yDirection -= position_.y;
    
#ifdef DEBUG
    if( isnan(xDirection) || isnan(yDirection) )
        NSLog(@"Invalid position");
#endif
    
    float magnitude = sqrtf(xDirection * xDirection + yDirection * yDirection);
    
    float normXDirection = xDirection / magnitude;
    float normYDirection = yDirection / magnitude;
    
    return [self actionToFaceRelativePoint:(CGPoint){.x=normXDirection,.y=normYDirection}];
}

-(void)faceRelativePoint:(CGPoint)normalizedRelativeDirection
{
    CCFiniteTimeAction *rotateAction = [self actionToFaceRelativePoint:normalizedRelativeDirection];
    if( rotateAction != nil )
    {
        //[self setRotation:rotation];
        //        NSLog(@"Rotated to %f degress with x: %f y: %f", CC_RADIANS_TO_DEGREES(rotation), xDirection, yDirection);
        [self runAction:rotateAction];
    }
}

-(CCFiniteTimeAction *)actionToFaceRelativePoint:(CGPoint)normalizedVector
{
    float rotation = atan2f(normalizedVector.y,-normalizedVector.x);
    
    rotation = CC_RADIANS_TO_DEGREES(rotation);
    
    CCFiniteTimeAction *rtnAction = nil;
    if( rotation != rotation_ )
    {
        float delta = sqrtf(fabsf(rotation - rotation_));
        //[self setRotation:rotation];
        //        NSLog(@"Rotated to %f degress with x: %f y: %f", CC_RADIANS_TO_DEGREES(rotation), xDirection, yDirection);
        rtnAction = [CCRotateTo actionWithDuration:0.01f * delta angle:rotation];
    }
    return rtnAction;
}

-(CCFiniteTimeAction *)moveToPointActions:(CGPoint)targetPoint
{
    CCFiniteTimeAction *faceAction = [self actionToFacePoint:targetPoint];
    
    ccTime moveTime = 1.0f;
    
    float mySpeed = [[self class] speed];
    
    
    currentSpeed_ = ccpDistance(position_, targetPoint) / moveTime;
    
    if( currentSpeed_ > mySpeed )
    {
        moveTime *= (currentSpeed_ / mySpeed);
        currentSpeed_ = mySpeed;
    }
    
    destination_ = targetPoint;
    
    return [CCSequence actionOne:faceAction two:[CCMoveTo actionWithDuration:moveTime position:targetPoint]];
}

-(void)moveToPoint:(CGPoint)targetPoint
{
    float distance = [self facePoint:targetPoint];
    
    ccTime moveTime = 1.0f;
    
    float mySpeed = [[self class] speed];
    
    
    currentSpeed_ = distance / moveTime;
    
    if( currentSpeed_ > mySpeed )
    {
        moveTime *= (currentSpeed_ / mySpeed);
        currentSpeed_ = mySpeed;
    }
    
    [self runAction:[CCMoveTo actionWithDuration:moveTime position:targetPoint]];
}

-(void)moveByAmount:(CGPoint)movementVector
{
    [self moveToPoint:ccpAdd(position_, movementVector)];
}

-(void)die
{
//    [[self owner] moverPerished:self];
    
    //[super die];
    [self stopAllActions];
    
    //CCFiniteTimeAction *dieSequence = [CCSequence actionOne:[CCFadeOut actionWithDuration:0.5f] two:[CCCallFunc actionWithTarget:self selector:@selector(removeFromParentAndDoCleanup)]];
    //[self runAction:dieSequence];
    [self removeFromParentAndDoCleanup];
}

-(void)didDestroy:(SGDestroyable *)destroyable
{
    //yay i killed something
}

-(void)hitForDamage:(int)damage
{
    health_ -= damage;
    
    NSString *string = nil;
    if(health_ <= 0){
        [self die];
        string = @"DEAD";
    }else{
        string = [NSString stringWithFormat:@"%d", health_];
    }
    
    if( string != nil )
        [healthLabel setString:string];
}

-(void)collideWithDestroyable:(SGDestroyable *)other{
    //return;
    
    if( health_ > 0 )
    {
        [self stopAllActions];
        
        if( [other isKindOfClass:[SGProjectile class]] )
        {
            [self getHitFromProjectile:(SGProjectile *)other];
        }
        if([other respondsToSelector:@selector(weapon)]){
            SGProjectile *p = (SGProjectile *)other;
            if(![p spent]){
                [self getHitFromWeapon:[p weapon]];
            }
        }else{
            //return;
            [self hitForDamage:[other damage]];
        }
    }
}

-(void)getHitFromWeapon:(SGWeapon *)weapon{
    if([[weapon owner] isEqual:self]){
        return;
    }
    [super getHitFromWeapon:weapon];
    if(health_ > 0){
        [healthLabel setString:[NSString stringWithFormat:@"%d", health_]];
    }
}

#pragma mark initialization

+(id)moverWithFile:(NSString *)file andHealth:(int)startingHealth{
    SGMover *m = [self spriteWithFile:file];
    [m initializeHealth:startingHealth];
    return m;
}

-(void)initializeHealth:(int)health{
    [super initializeHealth:health];
    healthLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", health_]
                                   dimensions:CGSizeMake(64, 24)
                                   hAlignment:kCCTextAlignmentCenter
                                lineBreakMode:kCCLineBreakModeWordWrap
                                     fontName:@"Arial"
                                     fontSize:24];
    healthLabel.position = CGPointMake(0, 0);
    healthLabel.color = ccRED;
    [self addChild:healthLabel];
}

#pragma mark - collision

-(void)bounce{
    CCAction *bounceAction = [CCSequence actionOne:[CCMoveBy actionWithDuration:0.2 position:[self backwardDirection]] two:[CCCallFunc actionWithTarget:self selector:@selector(afterBounce)]];
    [self runAction:bounceAction];
}

-(void)afterBounce{
    
}

@end
