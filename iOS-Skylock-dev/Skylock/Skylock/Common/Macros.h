//
//  Macros.h
//  Skylock
//
//  Created by Daniel Ondruj on 25.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#ifndef Skylock_Macros_h
#define Skylock_Macros_h

////////////////////////////////////////////////////////////////
// iOS version
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

////////////////////////////////////////////////////////////////
// Localized string

#define _LOC_STR_TRANSLATION(s)	NSLocalizedString(s,@"")
#define _LOC_STR(s)	[[LanguageManager sharedInstance] translationWithID:s]

////////////////////////////////////////////////////////////////
// Value macros

#define _SAFE_STRING_VALUE(s)       ((s) != nil ? (s) : @"")
#define _SAFE_BOOL_VALUE(s)         ((s) != nil ? (s) : @(NO))
#define _SAFE_NUMBER_VALUE(s)       ((s) != nil ? (s) : @(-1))
#define _SAFE_VALUE(s)              ((s) != nil ? (s) : [NSNull null])

#define _DICT_VALUE(s)              ((NSNull*)s == [NSNull null]) ? nil : s;
#define _IS_EMPTY(s)                (((s) == nil) || ([(s) length] == 0))

#define _IS_FILLED_NUMBER(s)        (((s) != nil) && ([(s) integerValue] != 0))

////////////////////////////////////////////////////////////////
// Colors

#define RGBA_R(c) ((((c)>>16) & 0xff) * 1.f/255.f)
#define RGBA_G(c) ((((c)>> 8) & 0xff) * 1.f/255.f)
#define RGBA_B(c) ((((c)>> 0) & 0xff) * 1.f/255.f)
#define RGBA_A(c) ((((c)>>24) & 0xff) * 1.f/255.f)

#define UIColorWithARGB(c)	[UIColor colorWithRed:RGBA_R(c) green:RGBA_G(c) blue:RGBA_B(c) alpha:RGBA_A(c)]
#define UIColorWithRGB(c)	[UIColor colorWithRed:RGBA_R(c) green:RGBA_G(c) blue:RGBA_B(c) alpha:1.0]
#define UIColorWithRGBValues(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define UIColorWithRGBAValues(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]

////////////////////////////////////////////////////////////////
// Rects

#define CGRectMakeFromX(rect, x) \
CGRectMakeIntegral(x, rect.origin.y, rect.size.width, rect.size.height)

#define MoveFrameToX(view, x) \
view.frame = CGRectIntegral(CGRectMake((x), (view).frame.origin.y, (view).frame.size.width, (view).frame.size.height))

#define MoveFrameToY(view, y) \
view.frame = CGRectIntegral(CGRectMake((view).frame.origin.x, (y), (view).frame.size.width, (view).frame.size.height))

#define MoveFrameToYSimple(view, y) \
view.frame = CGRectIntegral(CGRectMake((view).frame.origin.x, (y), (view).frame.size.width, (view).frame.size.height))

#define CenterToY(view, y) \
view.center = CGPointMake((view).center.x, (y))

#define SetWidth(view, width) \
view.frame = CGRectIntegral(CGRectMake((view).frame.origin.x, (view).frame.origin.y, (width), (view).frame.size.height))

#define SetHeight(view, height) \
view.frame = CGRectIntegral(CGRectMake((view).frame.origin.x, (view).frame.origin.y, (view).frame.size.width, (height)))

#define SetHeightSimple(view, height) \
view.frame = CGRectMake((view).frame.origin.x, (view).frame.origin.y, (view).frame.size.width, (height))

#define RightEdge(view) \
(view).frame.origin.x + (view).frame.size.width

#define BottomEdge(view) \
(view).frame.origin.y + (view).frame.size.height

#define CGRectMakeCentered(x, y, width, height) \
CGRectIntegral(CGRectMake((x - width / 2.0f), (y - height / 2.0f), (width), (height)))

#define CGRectMakeIntegral(x, y, width, height) \
CGRectIntegral(CGRectMake((x), (y), (width), (height)))

#endif
