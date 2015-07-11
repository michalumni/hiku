//
//  Constants.h
//  Skylock
//
//  Created by Daniel Ondruj on 20.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#ifndef Skylock_Constants_h
#define Skylock_Constants_h

//API
#define API_URL @"http://skylock-development.azurewebsites.net/"

//IDs
#define RELOAD_MENU_NOTIFICATION @"ReloadMenuNotification"
#define LOCK_CHANGED_STATE_NOTIFICATION @"LockChangedStateNotification"
#define RELOAD_PIN_NOTIFICATION @"ReloadPinNotification"
#define LOCK_UPDATED_NOTIFICATION @"lockStateUpdated"

#define MENU_TEXT_NORMAL_COLOR UIColorWithRGBValues(122,144,171)
#define MENU_TEXT_NUMBER_NORMAL_COLOR UIColorWithRGBValues(135,152,174)
#define MENU_TEXT_SELECTED_COLOR [UIColor whiteColor]

#define BATTERY_OK_COLOR UIColorWithRGBValues(153,208,255)
#define BATTERY_CRITICAL_COLOR UIColorWithRGBValues(253,131,128)

#define SETTINGS_TEXT_NORMAL_COLOR UIColorWithRGBValues(34, 79, 96)
#define SETTINGS_DETAIL_TEXT_NORMAL_COLOR UIColorWithRGBValues(158, 178 , 192)

#define KEYSHARE_TEXT_NORMAL_COLOR UIColorWithRGBValues(4, 54, 74)

#define APP_BLUE_COLOR_TINT UIColorWithRGBValues(70, 156, 207)

#define FACEBOOK_KEY @"551117418341780"

//PonyDebugger on device
//#define kPonyDebuggerURL                        @"ws://192.168.1.234:9000/device"
//PonyDebugger on Simulator
#define kPonyDebuggerURL                      @"ws://127.0.0.1:9000/device"

typedef enum {
    eUndefined,
    eLocked,
    eUnlocked,
} LockState;

typedef enum {
    eCritical,
    eLow,
    eOK,
    eFull,
} BatteryState;

#endif
