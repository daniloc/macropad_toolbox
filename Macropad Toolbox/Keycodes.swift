//
//  Keycodes.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/20/21.
//

import Foundation

//Ported from https://github.com/adafruit/Adafruit_CircuitPython_HID/blob/main/adafruit_hid/keycode.py

enum AdafruitPythonHIDKeycode: String, CaseIterable, Identifiable {
    
    var id: String {
        return rawValue
    }
    
    case
    COMMAND = "0xE3",
    OPTION  = "0xE2",
    CONTROL  = "0xE0",
    SHIFT  = "0xE1",
    ENTER  = "0x28",
    ESCAPE  = "0x29",
    BACKSPACE  = "0x2A",
    TAB  = "0x2B",
    CAPS_LOCK  = "0x39",
    PRINT_SCREEN  = "0x46",
    SCROLL_LOCK  = "0x47",
    PAUSE  = "0x48",
    INSERT  = "0x49",
    HOME  = "0x4A",
    PAGE_UP  = "0x4B",
    DELETE  = "0x4C",
    END  = "0x4D",
    PAGE_DOWN  = "0x4E",
    RIGHT_ARROW  = "0x4F",
    LEFT_ARROW  = "0x50",
    DOWN_ARROW  = "0x51",
    UP_ARROW  = "0x52",
    KP_NUMLOCK  = "0x53",
    KP_FWD_SLASH  = "0x54",
    KP_ASTERISK  = "0x55",
    KP_MINUS  = "0x56",
    KP_PLUS  = "0x57",
    KP_ENTER  = "0x58",
    KP_ONE  = "0x59",
    KP_TWO  = "0x5A",
    KP_THREE  = "0x5B",
    KP_FOUR  = "0x5C",
    KP_FIVE  = "0x5D",
    KP_SIX  = "0x5E",
    KP_SEVEN  = "0x5F",
    KP_EIGHT  = "0x60",
    KP_NINE  = "0x61",
    KP_ZERO  = "0x62",
    KP_PERIOD  = "0x63",
    KP_BACKSLASH  = "0x64",
    APPLICATION  = "0x65",
    POWER  = "0x66",
    KP_EQUALS  = "0x67",
    F1  = "0x3A",
    F2  = "0x3B",
    F3  = "0x3C",
    F4  = "0x3D",
    F5  = "0x3E",
    F6  = "0x3F",
    F7  = "0x40",
    F8  = "0x41",
    F9  = "0x42",
    F10  = "0x43",
    F11  = "0x44",
    F12  = "0x45",
    F13  = "0x68",
    F14  = "0x69",
    F15  = "0x6A",
    F16  = "0x6B",
    F17  = "0x6C",
    F18  = "0x6D",
    F19  = "0x6E",
    F20  = "0x6F",
    F21  = "0x70",
    F22  = "0x71",
    F23  = "0x72",
    F24  = "0x73",
    RIGHT_CTRL  = "0xE4",
    RIGHT_SHIFT  = "0xE5",
    RIGHT_ALT  = "0xE6",
    RIGHT_CMD  = "0xE7"
    
}

enum AdafruitHIDPythonMediaControlCode: String, CaseIterable, Identifiable {
    
    var id: String {
        return rawValue
    }
    
    case
    RECORD = "0xB2",
    FAST_FWD = "0xB3",
    REWIND = "0xB4",
    SCAN_NEXT = "0xB5",
    SCAN_PREV = "0xB6",
    STOP = "0xB7",
    EJECT = "0xB8",
    PLAY_PAUSE = "0xCD",
    MUTE = "0xE2",
    VOLUME_UP = "0xEA",
    VOLUME_DOWN = "0xE9",
    BRIGHT_UP = "0x70",
    BRIGHT_DOWN = "0x6F"
}
