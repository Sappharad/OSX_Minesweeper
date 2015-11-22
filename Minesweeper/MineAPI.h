//  According to Wikipedia, Minesweeper has been around since the 1960's.
//  https://en.wikipedia.org/wiki/Minesweeper_(video_game)
//  The game itself is copyright whoever originally created it.
//  This is a free clone, code is released as public domain.
//
//  MineAPI.h
//  Minesweeper
//
//  Created by Paul Kratt on 11/18/15.
//  Copyright © 2015 Paul Kratt. All rights reserved.
//

#ifndef MineAPI_h
#define MineAPI_h

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct Board {
    unsigned char* content;
    int rows;
    int columns;
    int numMines;
} Board;

extern const unsigned char SPACE_MINE;
extern const unsigned char SPACE_HIDDEN;
extern const unsigned char SPACE_FLAG;
unsigned char readCell(int row, int col, Board* board);
unsigned char probe(int row, int col, Board* board);
void setFlag(int row, int col, Board* board);
void revealBoard(Board* board);
Board* makeBoard(int rows, int columns, int bombs);
int getFlagsLeft(Board* board);
int didWin(Board* board);

#endif /* MineAPI_h */
