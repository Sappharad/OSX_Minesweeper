//  According to Wikipedia, Minesweeper has been around since the 1960's.
//  https://en.wikipedia.org/wiki/Minesweeper_(video_game)
//  The game itself is copyright whoever originally created it.
//  This is a free clone, code is released as public domain.
//
//  MinesView.h
//  Minesweeper
//
//  Created by Paul Kratt on 11/18/15.
//  Copyright © 2015 Paul Kratt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MineAPI.h"

@interface MinesView : NSView
@property Board* myboard;
@property (nonatomic, copy) void (^onBoardChanged)();

-(void)restartGame;
-(void)restartGameWithRows:(int)rows andColumns:(int)cols andMines:(int)mines;

@end
