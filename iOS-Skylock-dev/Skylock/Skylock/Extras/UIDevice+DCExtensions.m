//
//  UIDevice+DCExtensions.m
//  AAA
//
//  Created by Dan on 03.05.13.
//  Copyright (c) 2013 uLikeIT. All rights reserved.
//

#import "UIDevice+DCExtensions.h"

@implementation UIDevice (DCExtensions)

+ (BOOL)isIPhone5Screen
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 568) return YES;
    }
    
    return NO;
}

@end
