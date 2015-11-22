//  According to Wikipedia, Minesweeper has been around since the 1960's.
//  https://en.wikipedia.org/wiki/Minesweeper_(video_game)
//  The game itself is copyright whoever originally created it.
//  This is a free clone, code is released as public domain.
//
//  MineAPI.c
//  Minesweeper
//
//  Created by Paul Kratt on 11/18/15.
//  Copyright © 2015 Paul Kratt. All rights reserved.
//

#include "MineAPI.h"

const unsigned char SPACE_MINE = 0x80;
const unsigned char SPACE_HIDDEN = 0x10;
const unsigned char SPACE_FLAG = 0x20;

unsigned char readCell(int row, int col, Board* board){
    if(row >=0 && col >= 0 && row < board->rows && col < board->columns){
        return board->content[(row*board->columns)+col];
    }
    return 0;
}

unsigned char countBombs(int row, int col, Board* board){
    unsigned char retval = 0;
    retval += (readCell(row-1, col-1, board) & SPACE_MINE) ? 1 : 0;
    retval += (readCell(row-1, col, board) & SPACE_MINE) ? 1 : 0;
    retval += (readCell(row-1, col+1, board) & SPACE_MINE) ? 1 : 0;
    retval += (readCell(row, col+1, board) & SPACE_MINE) ? 1 : 0;
    retval += (readCell(row+1, col+1, board) & SPACE_MINE) ? 1 : 0;
    retval += (readCell(row+1, col, board) & SPACE_MINE) ? 1 : 0;
    retval += (readCell(row+1, col-1, board) & SPACE_MINE) ? 1 : 0;
    retval += (readCell(row, col-1, board) & SPACE_MINE) ? 1 : 0;
    return retval;
}

unsigned char probe(int row, int col, Board* board){
    unsigned char cellVal = readCell(row, col, board);
    if(cellVal & SPACE_HIDDEN){
        cellVal = cellVal & (~(SPACE_HIDDEN|SPACE_FLAG));
        board->content[(row*board->columns)+col] = cellVal;
        if(cellVal == 0){
            probe(row-1, col-1, board);
            probe(row-1, col, board);
            probe(row-1, col+1, board);
            probe(row, col+1, board);
            probe(row+1, col+1, board);
            probe(row+1, col, board);
            probe(row+1, col-1, board);
            probe(row, col-1, board);
        }
    }
    return cellVal;
}

void setFlag(int row, int col, Board* board){
    board->content[(row*board->columns)+col] ^= SPACE_FLAG;
}
void revealBoard(Board* board){
    for (int i=0; i<board->rows*board->columns; i++) {
        board->content[i] &= (board->content[i] & ~SPACE_HIDDEN);
    }
}

Board* makeBoard(int rows, int columns, int bombs){
    Board* myboard = malloc(sizeof(Board));
    
    myboard->content = malloc(rows*columns);
    myboard->rows = rows;
    myboard->columns = columns;
    for(int i=0; i<rows*columns; i++){
        myboard->content[i] = SPACE_HIDDEN;
    }
    
    srand((unsigned int)time(NULL));
    
    int bombsLeft = bombs;
    if(bombsLeft > rows*columns){
        bombsLeft = rows*columns;
    }
    myboard->numMines = bombsLeft;
    while(bombsLeft > 0){
        int loc = rand()%(rows*columns);
        if(!(myboard->content[loc] & SPACE_MINE)){
            myboard->content[loc] |= SPACE_MINE;
            bombsLeft--;
        }
    }
    for(int r=0; r<rows; r++){
        for(int c=0; c<columns; c++){
            if(!(myboard->content[(r*columns)+c] & SPACE_MINE)){
                myboard->content[(r*columns)+c] |= countBombs(r, c, myboard);
            }
        }
    }
    
    return myboard;
}

int getFlagsLeft(Board* board){
    int flags = board->numMines;
    
    for (int i=0; i<board->rows*board->columns; i++) {
        if(board->content[i] & SPACE_FLAG){
            flags--;
        }
    }
    
    return flags;
}

int didWin(Board* board){
    int foundMines = board->numMines;
    
    for (int i=0; i<board->rows*board->columns; i++) {
        if((board->content[i] & SPACE_FLAG) && (board->content[i] & SPACE_MINE)){
            foundMines--;
        }
    }
    
    return foundMines==0;
}

