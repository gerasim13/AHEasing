//
//  NSObject+AHEasing.m
//
//  Copyright (c) 2014, Auerhaus Development, LLC
//  Copyright (c) 2014, Casual Underground Lab.
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What The Fuck You Want
//  To Public License, Version 2, as published by Sam Hocevar. See
//  http://sam.zoy.org/wtfpl/COPYING for more details.
//

//_______________________________________________________________________________________________________________

#import "NSObject+AHEasing.h"

//_______________________________________________________________________________________________________________

// The larger this number, the smoother the animation
#if !defined(AHEasingDefaultKeyframeCount)
#define AHEasingDefaultKeyframeCount 60
#endif

//_______________________________________________________________________________________________________________

@class AHAnimation;

//_______________________________________________________________________________________________________________

typedef void(^AHAnimationCompletionBlock)(AHAnimation *animation);

//_______________________________________________________________________________________________________________

@interface AHAnimation : NSObject
{
    @package
    NSString *_key;
    id        _target;
    Float32   _currentValue;
    Float32   _startValue;
    Float32   _endValue;
    AHEasingFunction _easing;
    NSTimeInterval   _startTime;
    NSTimeInterval   _delay;
    NSTimeInterval   _duration;
}

@property (nonatomic, copy  ) AHAnimationCompletionBlock completion;
@property (nonatomic, assign) BOOL animating;

+ (instancetype)animationForKey:(NSString*)key
                         target:(id)target
                 easingFunction:(AHEasingFunction)easing
                       duration:(Float32)duration
                          delay:(Float32)delay
                     startValue:(Float32)startVal
                       endValue:(Float32)endValue
                completionBlock:(AHAnimationCompletionBlock)completion;

- (void)start;
- (void)end;

@end

//_______________________________________________________________________________________________________________

@implementation NSObject (AHEasing)

//_______________________________________________________________________________________________________________

static NSMutableDictionary *_animations  = nil;
static CADisplayLink       *_displayLink = nil;

//_______________________________________________________________________________________________________________

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _animations = [NSMutableDictionary dictionary];
    });
}

+ (void)update:(CADisplayLink*)link
{
    // Update animations
    for (AHAnimation *anim in [_animations allValues])
    {
        NSTimeInterval t = link.timestamp - anim->_startTime;
        if (t >= anim->_delay)
        {
            // Start animation
            if (!anim.animating)
            {
                [anim start];
            }
            else
            {
                t = (t - anim->_delay) / anim->_duration;
                // End animation
                if (t >= 1.0)
                {
                    [anim end];
                }
                // Update animation
                else
                {
                    anim->_currentValue = (anim->_endValue - anim->_startValue) * anim->_easing(t);
                    anim->_currentValue = anim->_currentValue > 0 ? anim->_currentValue : anim->_currentValue + 1.0;
                    [anim->_target setValue:@(anim->_currentValue) forKey:anim->_key];
                }
            }
        }
    }
}

- (void)addAnimationWithKey:(NSString*)key
                   function:(AHEasingFunction)function
                   duration:(Float32)duration
                      delay:(Float32)delay
                  fromValue:(Float32)fromValue
                    toValue:(Float32)toValue
{
    // Init timer
    if (!_displayLink)
    {
        _displayLink = [CADisplayLink displayLinkWithTarget:[self class] selector:@selector(update:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    // Init animation
    __weak NSObject *weakSelf = self;
    AHAnimation *anim = [AHAnimation animationForKey:key
                                              target:self
                                      easingFunction:function
                                            duration:duration
                                               delay:delay
                                          startValue:fromValue
                                            endValue:toValue
                                     completionBlock:^(AHAnimation *animation){
                                         [weakSelf removeAnimationWithKey:animation->_key];
                                     }];
    // Add animation to dictionary
    NSUInteger hash = [key hash] ^ [self hash];
    _animations[@(hash)] = anim;
}

- (void)removeAnimationWithKey:(NSString*)key
{
    NSUInteger   hash = [key hash] ^ [self hash];
    AHAnimation *anim = _animations[@(hash)];
    // Check if animation exists
    if (anim)
    {
        // Remove animation from dictionary
        [_animations removeObjectForKey:@(hash)];
    }
    // invelidate timer if needed
    if ([_animations count] == 0)
    {
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

@end

//_______________________________________________________________________________________________________________

@implementation AHAnimation
@synthesize completion = _completion;
@synthesize animating  = _animating;

//_______________________________________________________________________________________________________________

- (instancetype)initWithKey:(NSString*)key
                     target:(id)target
             easingFunction:(AHEasingFunction)easing
                   duration:(Float32)duration
                      delay:(Float32)delay
                 startValue:(Float32)startVal
                   endValue:(Float32)endValue
            completionBlock:(AHAnimationCompletionBlock)completion
{
    if (self = [super init])
    {
        _key            = key;
        _target         = target;
        _easing         = easing;
        _startValue     = startVal;
        _endValue       = endValue;
        _duration       = duration;
        _delay          = delay;
        _startTime      = CACurrentMediaTime();
        self.completion = completion;
    }
    return self;
}

+ (instancetype)animationForKey:(NSString*)key
                         target:(id)target
                 easingFunction:(AHEasingFunction)easing
                       duration:(Float32)duration
                          delay:(Float32)delay
                     startValue:(Float32)startVal
                       endValue:(Float32)endValue
                completionBlock:(AHAnimationCompletionBlock)completion
{
    return [[self alloc] initWithKey:key
                              target:target
                      easingFunction:easing
                            duration:duration
                               delay:delay
                          startValue:startVal
                            endValue:endValue
                     completionBlock:completion];
}

- (void)start
{
    _animating = YES;
    _startTime = CACurrentMediaTime();
    [_target setValue:@(_startValue) forKey:_key];
}

- (void)end
{
    _animating = NO;
    [_target setValue:@(_endValue) forKey:_key];
    // Call completion block
    if (_completion)
    {
        _completion(self);
        _completion = nil;
    }
}

@end

//_______________________________________________________________________________________________________________
