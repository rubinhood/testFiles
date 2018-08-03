//
//  ScratchView.h
//  ScratchPadDemo
//	Version 1.0 - Release November 2012
//
//  Created by Amory KC Wong on 2012-10-05.
//  Copyright (c) 2012 Amory KC Wong. All rights reserved.
//	Code Project Open License 1.02
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

/*
 *  System Versioning Preprocessor Macros
 */ 

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 *  Usage
 */ 

#define MAXT	300				// maximum number of lines (adjust these if you want more/less)
#define MAXP	3000			// maximum number of line segments

typedef enum {SP_VIEW, SP_DRAG, SP_CLEAR, SP_SIZE, SP_ERASER, SP_WHITE, SP_BLACK, SP_RED, SP_GREEN, SP_BLUE, SP_HIDE, SP_REPLAY, SP_UNDO, SP_REDO, NUM_SP_KEYS} SP_KEYS;	// button enumerations

@interface ScratchPadView : GLKView <GLKViewDelegate, UIAlertViewDelegate> {
	EAGLContext *context;
	int			lastP;				// current last line segment
	int			lastT;				// current last line
	int			lastReplayP;		// replay index line segment
	int			lastReplayT;		// replay index line
	int			lastMaxUndoP;		// maximum line segment undo index
	int			lastMaxUndoT;		// maximum line undo index
	int			currentColorI;		// current index color
	int			scrWidth;			// adjust this if you have screen rotations
	int			scrHeight;
	BOOL		replay;				// active replay flag
	BOOL		largeFormat;		// if iPhone no dragging/sizing allowed
	BOOL		iOSatLeast6;
	
	GLfloat		points[MAXP*2];		// keeps track of all the points for line segments
	int			touchStart[MAXT];	// start of a line
	int			touchEnd[MAXT];		// end of a line
	int			colorsI[MAXT];		// color index for each line
	
	UIColor		*colorList[SP_HIDE-SP_ERASER];	// modify the colors if you wish
	GLKVector4	colors[SP_HIDE-SP_ERASER];		// color vector for each line
}

//@property (nonatomic, retain) UIColor	*currentColor;

-(void)scaleScratchDown;			// make scratchpad disappear
-(void)scaleScratchUp;				// make scratchpad appear
- (void) undoLastScratch ;
- (void) redoLastScratch ;
- (void) replayLastScratch ;
- (void) useEraser ;
- (void) userColor ;
- (int) getCurrentColor;

@end
