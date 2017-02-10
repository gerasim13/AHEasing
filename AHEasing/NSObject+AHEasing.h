//
//  NSObject+AHEasing.m
//
//  Copyright (c) 2014, Casual Underground Lab.
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What The Fuck You Want
//  To Public License, Version 2, as published by Sam Hocevar. See
//  http://sam.zoy.org/wtfpl/COPYING for more details.
//

//_______________________________________________________________________________________________________________

#import <QuartzCore/QuartzCore.h>
#include "easing.h"

//_______________________________________________________________________________________________________________

typedef Float32 (^AHAnimationAnimationBlock )(id, Float32);
typedef void    (^AHAnimationCompletionBlock)(id, BOOL   );

//_______________________________________________________________________________________________________________

@interface NSObject (AHEasing)

- (void)addAnimationWithKey:(NSString*)key
                     easing:(AHEasingFunction)easing
                   duration:(Float32)duration
                      delay:(Float32)delay
                  fromValue:(Float32)fromValue
                    toValue:(Float32)toValue
                 usingBlock:(AHAnimationAnimationBlock)block
                 completion:(AHAnimationCompletionBlock)completion;

- (void)addAnimationWithKey:(NSString*)key
                     easing:(AHEasingFunction)easing
                   duration:(Float32)duration
                      delay:(Float32)delay
                  fromValue:(Float32)fromValue
                    toValue:(Float32)toValue
                 usingBlock:(AHAnimationAnimationBlock)block;

- (void)addAnimationWithKey:(NSString*)key
                     easing:(AHEasingFunction)easing
                   duration:(Float32)duration
                      delay:(Float32)delay
                  fromValue:(Float32)fromValue
                    toValue:(Float32)toValue
                 completion:(AHAnimationCompletionBlock)completion;

- (void)addAnimationWithKey:(NSString*)key
                   duration:(Float32)duration
                      delay:(Float32)delay
                  fromValue:(Float32)fromValue
                    toValue:(Float32)toValue;

- (void)addAnimationWithKey:(NSString*)key
                   duration:(Float32)duration
                  fromValue:(Float32)fromValue
                    toValue:(Float32)toValue;

- (void)removeAnimationWithKey:(NSString*)key;

@end

//_______________________________________________________________________________________________________________
