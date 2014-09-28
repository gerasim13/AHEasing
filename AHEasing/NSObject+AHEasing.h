//
//  NSObject+AHEasing.m
//
//  Copyright (c) 2011, Auerhaus Development, LLC
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

@interface NSObject (AHEasing)

- (void)addAnimationWithKey:(NSString*)key
                   function:(AHEasingFunction)function
                   duration:(Float32)duration
                      delay:(Float32)delay
                  fromValue:(Float32)fromValue
                    toValue:(Float32)toValue;

- (void)removeAnimationWithKey:(NSString*)key;

@end

//_______________________________________________________________________________________________________________
