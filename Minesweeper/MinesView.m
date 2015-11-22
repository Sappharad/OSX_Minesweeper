//  According to Wikipedia, Minesweeper has been around since the 1960's.
//  https://en.wikipedia.org/wiki/Minesweeper_(video_game)
//  The game itself is copyright whoever originally created it.
//  This is a free clone, code is released as public domain.
//
//  MinesView.m
//  Minesweeper
//
//  Created by Paul Kratt on 11/18/15.
//  Copyright © 2015 Paul Kratt. All rights reserved.
//

#import "MinesView.h"

@implementation MinesView

NSPoint _lastMouse;
bool _mouseDown;
id _rightClickEvent;

-(id)initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder:coder]){
        _myboard = makeBoard(10, 10, 10);
        _lastMouse = CGPointMake(0, 0);
        
        _rightClickEvent = [NSEvent addLocalMonitorForEventsMatchingMask:(NSRightMouseDownMask | NSRightMouseUpMask | NSRightMouseDraggedMask) handler:^NSEvent * _Nullable(NSEvent * _Nonnull theEvent) {
            if(theEvent.type == NSRightMouseDown){
                [self mouseDown:theEvent];
            }
            else if(theEvent.type == NSRightMouseUp){
                [self mouseUp:theEvent];
            }
            else if(theEvent.type == NSRightMouseDragged){
                [self mouseDragged:theEvent];
            }
            return theEvent;
        }];
    }
    return self;
}

-(void)dealloc{
    [NSEvent removeMonitor:_rightClickEvent];
}

-(void)restartGame{
    [self restartGameWithRows:10 andColumns:10 andMines:10];
}

-(void)restartGameWithRows:(int)rows andColumns:(int)cols andMines:(int)mines{
    free(_myboard);
    _myboard = makeBoard(rows, cols, mines);
    [self display];
}

-(BOOL)mouseDownCanMoveWindow{
    return NO;
}

-(void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    _lastMouse = [self.window.contentView convertPoint:theEvent.locationInWindow toView:self];
    _mouseDown = YES;
    [self display];
}

-(void)mouseDragged:(NSEvent *)theEvent{
    _lastMouse = [self.window.contentView convertPoint:theEvent.locationInWindow toView:self];
    [self display];
}

-(void)mouseUp:(NSEvent *)theEvent{
    [super mouseUp:theEvent];
    _mouseDown = NO;
    BOOL flagClick = (theEvent.buttonNumber>0) || (theEvent.modifierFlags & NSAlternateKeyMask);
    [self handleCellAtMouse:flagClick];
    if(self.onBoardChanged){
        self.onBoardChanged();
    }
    [self display];
}

-(void)handleCellAtMouse:(BOOL)rightClick{
    CGFloat rectWidth = self.bounds.size.width / _myboard->columns;
    CGFloat rectHeight = self.bounds.size.height / _myboard->rows;
    int row = _lastMouse.y/rectHeight;
    int col = _lastMouse.x/rectWidth;
    if(rightClick){
        unsigned char result = readCell(row, col, _myboard);
        if(result & SPACE_HIDDEN){
            setFlag(row, col, _myboard);
        }
    }
    else{
        unsigned char result = probe(row, col, _myboard);
        if(result & SPACE_MINE){
            revealBoard(_myboard);
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    //This isn't very complex, so let's ignore dirtyRect and draw the whole thing.
    
    CGContextRef context = NSGraphicsContext.currentContext.CGContext;
    CGFloat rectWidth = self.bounds.size.width / _myboard->columns;
    CGFloat rectHeight = self.bounds.size.height / _myboard->rows;
    CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0, 0, 0, 1));
    NSDictionary* fontAttributes = @{NSFontAttributeName:[NSFont fontWithName:@"Helvetica" size:rectHeight*0.8f]};
    
    for(int r=0;r<_myboard->rows; r++){
        for(int c=0;c<_myboard->columns; c++){
            unsigned char probed = readCell(r, c, _myboard);
            CGFloat x = c*rectWidth;
            CGFloat y = r*rectHeight;
            CGContextStrokeRect(context, CGRectMake(x, y, rectWidth, rectHeight));
            if((probed & SPACE_HIDDEN) == 0){
                if(probed & SPACE_MINE){
                    CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.4f, 0, 0, 1));
                    CGContextFillEllipseInRect(context, CGRectMake(x+4, y+4, rectWidth-8, rectHeight-8));
                }
                else if(probed > 0){
                    NSString* numbers = [NSString stringWithFormat:@"%d", probed&0xF];
                    NSSize textSize = [numbers sizeWithAttributes:fontAttributes];
                    [numbers drawAtPoint:CGPointMake(x+(rectWidth/2)-(textSize.width/2), y) withAttributes:fontAttributes];
                }
            }
            else if(probed & SPACE_FLAG){
                CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.5f, 0.5f, 0.5f, 1.0f));
                CGContextFillRect(context, CGRectMake(x+1, y+1, rectWidth-2, rectHeight-2));
                
                NSSize textSize = [@"X" sizeWithAttributes:fontAttributes];
                [@"X" drawAtPoint:CGPointMake(x+(rectWidth/2)-(textSize.width/2), y) withAttributes:fontAttributes];
            }
            else{
                if(_mouseDown && CGRectContainsPoint(CGRectMake(x, y, rectWidth, rectHeight), _lastMouse)){
                    CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.0f, 0.8f, 0.8f, 1.0f));
                }
                else{
                    CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.5f, 0.5f, 0.5f, 1.0f));
                }
                CGContextFillRect(context, CGRectMake(x+1, y+1, rectWidth-2, rectHeight-2));
            }
        }
    }
}

@end
