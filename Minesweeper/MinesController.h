//  According to Wikipedia, Minesweeper has been around since the 1960's.
//  https://en.wikipedia.org/wiki/Minesweeper_(video_game)
//  The game itself is copyright whoever originally created it.
//  This is a free clone, code is released as public domain.
//
//  MinesController.h
//  Minesweeper
//
//  Created by Paul Kratt on 11/18/15.
//  Copyright © 2015 Paul Kratt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "MinesView.h"

@interface MinesController : NSObject
@property int NumRows;
@property int NumColumns;
@property int NumMines;

@property IBOutlet NSTextField *txtMinesLeft;
@property IBOutlet NSTextField *txtYouWon;
@property IBOutlet MinesView *vwMines;
@property (weak) IBOutlet NSWindow *wndGame;
@property IBOutlet NSPanel *pnlNewGamePlus;
- (IBAction)mnuFileNew:(id)sender;
- (IBAction)mnuFileNewPlus:(id)sender;
- (IBAction)btnNewGameOK:(id)sender;
- (IBAction)btnNewGameCancel:(id)sender;

- (void)onStartup;

@end
