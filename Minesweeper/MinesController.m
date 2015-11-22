//  According to Wikipedia, Minesweeper has been around since the 1960's.
//  https://en.wikipedia.org/wiki/Minesweeper_(video_game)
//  The game itself is copyright whoever originally created it.
//  This is a free clone, code is released as public domain.
//
//  MinesController.m
//  Minesweeper
//
//  Created by Paul Kratt on 11/18/15.
//  Copyright © 2015 Paul Kratt. All rights reserved.
//

#import "MinesController.h"

@implementation MinesController

-(void)onStartup{
    self.NumColumns = 10;
    self.NumRows = 10;
    self.NumMines = 10;
    _txtYouWon.hidden = YES;
    [_txtMinesLeft setStringValue:[NSString stringWithFormat:@"%d",getFlagsLeft(_vwMines.myboard)]];
    __weak MinesController* weakSelf = self;
    _vwMines.onBoardChanged = ^(){
        [weakSelf boardHasChanged];
    };
}

- (IBAction)mnuFileNew:(id)sender {
    _txtYouWon.hidden = YES;
    [_vwMines restartGame];
    [self boardHasChanged];
}

- (IBAction)mnuFileNewPlus:(id)sender {
    [_wndGame beginSheet:_pnlNewGamePlus completionHandler:^(NSModalResponse returnCode) {
        if(returnCode == NSModalResponseOK){
            _txtYouWon.hidden = YES;
            [_vwMines restartGameWithRows:self.NumRows andColumns:self.NumColumns andMines:self.NumMines];
            [self boardHasChanged];
        }
    }];
}

- (IBAction)btnNewGameOK:(id)sender {
    [_wndGame endSheet:_pnlNewGamePlus returnCode:NSModalResponseOK];
}

- (IBAction)btnNewGameCancel:(id)sender {
    [_wndGame endSheet:_pnlNewGamePlus returnCode:NSModalResponseCancel];
}

-(void)boardHasChanged{
    [_txtMinesLeft setStringValue:[NSString stringWithFormat:@"%d",getFlagsLeft(_vwMines.myboard)]];
    if(didWin(_vwMines.myboard)){
        _txtYouWon.hidden = NO;
    }
}

@end
