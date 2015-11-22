//  According to Wikipedia, Minesweeper has been around since the 1960's.
//  https://en.wikipedia.org/wiki/Minesweeper_(video_game)
//  The game itself is copyright whoever originally created it.
//  This is a free clone, code is released as public domain.
//
//  AppDelegate.h
//  Minesweeper
//
//  Created by Paul Kratt on 11/18/15.
//  Copyright © 2015 Paul Kratt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MinesController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet MinesController *controller;

@end

