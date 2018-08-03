//
//  ScratchView.m
//  ScratchPadDemo
//	Version 1.0 - Release November 2012
//
//  Created by Amory KC Wong on 2012-10-05.
//  Copyright (c) 2012 Amory KC Wong. All rights reserved.
//	Code Project Open License 1.02
//

#import "ScratchPadView.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>

//------------------------------------------------------------

#pragma mark - ScratchView

@implementation ScratchPadView


#define ERASEWIDTH		30			// width of the eraser
#define REPLAY_FPS		5			// the replay mode frame rate
#define SCRATCH_TAG		700			// in case you are using tags in the 700-750 range
#define SMALL_SP_SCALE	.04			// size to scale the scratchup/down animation
#define SP_SCALE_SPEED	.35			// speed of the scratchup/down animation

// these are for positioning and sizing of the scratchpad buttons
#define SPX		5
#define SPBW	55
#define SPY		5
#define SPBH	35
#define SPBS	5
float sPadXs[] = {0, SPX+0*SPBW, SPX+2*SPBW, 0,
	SPX+1*SPBW, SPX+0*SPBW, SPX+1*SPBW, SPX+2*SPBW, SPX+3*SPBW, SPX+4*SPBW,
	SPX+4*SPBW, SPX+3*SPBW, SPX+3*SPBW, SPX+4*SPBW};
float sPadYs[] = {0, SPY+0*SPBH, SPY+0*SPBH, 0,
	SPY+0*SPBH, SPY+1*SPBH, SPY+1*SPBH, SPY+1*SPBH, SPY+1*SPBH, SPY+1*SPBH,
	SPY+0*SPBH, SPY+0*SPBH, SPY+2*SPBH, SPY+2*SPBH};
NSString *scratchStr[] = {@"", @"Drag", @"Clear", @"Size",
	@"Eraser", @"White", @"Black", @"Red", @"Green", @"Blue",
	@"Hide", @"Replay", @"Undo", @"Redo"};

//------------------------------------------------------------

#pragma mark - init routines

+(Class)layerClass {
	return [CAEAGLLayer class];
}

// unfortunately, there are different ways to handle rotation, so I'm just going to avoid it
// in this demo.

//------------------------------------------------------------

-(id)init {
	CGRect rec = [[UIScreen mainScreen] applicationFrame];
	scrWidth = rec.size.width;					// you should adjust these if you are doing screen rotations
	scrHeight = rec.size.height;
	if (scrWidth > 640 && scrHeight > 640)		// determine if iPad or iPhone
		largeFormat = YES;
	else
		largeFormat = NO;
	CGRect rect;
	rect = CGRectMake(0, 100, 320, 320);
	EAGLContext *cont = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	self = [super initWithFrame:rect context:cont];
    if (self) {
        // Initialization code here.
		colorList[0] = [[UIColor alloc] initWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0]; // lightgray
		colorList[SP_WHITE-SP_ERASER] = [[UIColor alloc] initWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0];
		colorList[SP_BLACK-SP_ERASER] = [[UIColor alloc] initWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0];
		colorList[SP_RED-SP_ERASER] = [[UIColor alloc] initWithRed:(179.0/255.0) green:(79.0/255.0) blue:(10.0/255.0) alpha:1.0];
		colorList[SP_GREEN-SP_ERASER] = [[UIColor alloc] initWithRed:(10.0/255.0) green:(179.0/255.0) blue:(79.0/255.0) alpha:1.0];
		colorList[SP_BLUE-SP_ERASER] = [[UIColor alloc] initWithRed:(0.0/255.0) green:(124.0/255.0) blue:(179.0/255.0) alpha:1.0];
		for (int i = 0; i < SP_HIDE-SP_ERASER; i++) {
			const CGFloat* comps = CGColorGetComponents([colorList[i] CGColor]);
			colors[i] = GLKVector4Make(comps[0], comps[1], comps[2], comps[3]);
		}
		self.backgroundColor = [UIColor redColor];
		currentColorI = SP_BLACK;
		self.userInteractionEnabled = YES;
		self.hidden = NO;
		self.contentMode = UIViewContentModeCenter;
		//context = [cont retain];
        context =  cont ;
		self.delegate = self;
		self.enableSetNeedsDisplay = YES;
		lastMaxUndoP = 0;
		lastMaxUndoT = 0;
		iOSatLeast6 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0");
		[self clear];
	}
	//[cont release];

    return self;
}

-(void)dealloc {
	// tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	//for (int i = 0; i < SP_HIDE-SP_ERASER; i++)
		//[colorList[i] release];

	//[context release];
	context = nil;
	//[super dealloc];
}

//------------------------------------------------------------
// This is the custom draw routine
// It clears the view then draws all the line segments
// It also handles the replay mode

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
	glClearColor(colors[0].r, colors[0].g, colors[0].b, colors[0].a);
	glClear(GL_COLOR_BUFFER_BIT);
	GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
	effect.useConstantColor = YES;
	effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.drawableWidth, self.drawableHeight, 0, -2, 2);
	CGFloat scale = self.contentScaleFactor;	// need scale to handle Retina displays
	int firstInd = 0;
	int lastDrawT = lastT;
	int lastDrawP = lastP;
	if (replay) {					// change last index if replay mode
		lastDrawT = lastReplayT;
		lastDrawP = lastReplayP;
	}
	
	// draw all full lines
	for (int i = 0; i < lastDrawT; i++) {
		effect.constantColor = colors[colorsI[i]-SP_ERASER];
		if (colorsI[i] == SP_WHITE)
			glLineWidth(ERASEWIDTH * scale);
		else
			glLineWidth(2.0f * scale);

		// Render the vertex array
		[effect prepareToDraw];
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, &points[firstInd*2]);
		if (lastDrawP < touchEnd[i])
			glDrawArrays(GL_LINE_STRIP, 0, lastDrawP-firstInd);
		else
			glDrawArrays(GL_LINE_STRIP, 0, touchEnd[i]-firstInd);
		glDisableVertexAttribArray(GLKVertexAttribPosition);
		firstInd = touchEnd[i]+1;
	}
	
	// draw last line
	if (firstInd < lastDrawP) {		// determine color and width of last line
		int CI;
		if (lastDrawT < lastT) {	// in replay mode
			effect.constantColor = colors[colorsI[lastDrawT]-SP_ERASER];
			CI = colorsI[lastDrawT];
		} else {					// current touch movement
			effect.constantColor = colors[currentColorI-SP_ERASER];
			CI = currentColorI;
		}
		if (CI == SP_WHITE)
			glLineWidth(ERASEWIDTH * scale);
		else
			glLineWidth(2.0f * scale);
		
		// Render the vertex array
		[effect prepareToDraw];
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, &points[firstInd*2]);
		glDrawArrays(GL_LINE_STRIP, 0, lastDrawP-firstInd);
		glDisableVertexAttribArray(GLKVertexAttribPosition);
	}
	
	//[effect release];
}

//------------------------------------------------------------

// clear the line buffers
// it is still possible redo lines after this call
-(void)clear {
	lastP = 0;
	lastT = 0;
	replay = NO;
	[self setNeedsDisplay];		// this forces the GLKView to redraw
}

// resize the scratchpad
-(void)newSize:(CGSize)ns {
	CGRect frame = self.frame;
	frame.size = ns;
	self.frame = frame;
}

//------------------------------------------------------------

#pragma mark - Scratch Pad and buttons

-(void)adjustNumPad {
	CGRect frame = self.frame;
	if (largeFormat) {	// for iPad, do not allow the scratchpad to go past screen boundaries
		frame.origin.x = MAX(frame.origin.x, 0);
		frame.origin.y = MAX(frame.origin.y, 0);
		frame.origin.x = MIN(frame.origin.x, scrWidth - frame.size.width);
		frame.origin.y = MIN(frame.origin.y, scrHeight - frame.size.height);
	} else {	// for iPhone and iPod, make frame the full window
		frame.size.width = scrWidth;
		frame.size.height = scrHeight;
		[self newSize:frame.size];
		frame.origin.x = 0;
		frame.origin.y = 0;
	}
	self.frame = frame;
}

//------------------------------------------------------------

// draw a label inside a UIButton
-(void)buttonLabelFull:(UIButton *)but text:(NSString *)txt color:(UIColor *)col font:(NSString *)fnt fontsize:(float)fntsz xborder:(float)xb yborder:(float)yb {
	CGRect rec = but.frame;
	rec.origin.x = xb;
	rec.origin.y = yb;
	rec.size.width -= xb*2;
	UILabel *lab = [[UILabel alloc] initWithFrame:rec];
	lab.font = [UIFont fontWithName:fnt size:fntsz];
	if (iOSatLeast6)
		lab.minimumScaleFactor = .5;
	else
		lab.minimumFontSize = 4;
	lab.adjustsFontSizeToFitWidth = YES;
	lab.numberOfLines = 1;
	lab.textAlignment = NSTextAlignmentCenter;
	lab.textColor = col;
	lab.backgroundColor = [UIColor clearColor];
	lab.shadowColor = [UIColor colorWithRed:(57/255.0) green:(57/255.0) blue:(57/255.0) alpha:1.0];
	lab.shadowOffset = CGSizeMake(1.0, 1.5);
	lab.text = txt;
	[but addSubview:lab];
	//[lab release];
}

//------------------------------------------------------------

// recursively clear tags in a view
-(void)clearTagsR:(UIView *)vw low:(int)tg high:(int)htg {
	for (UIView *view in vw.subviews)
		if (view.tag >= tg && view.tag <= htg)
			[view removeFromSuperview];
		else
			[self clearTagsR:view low:tg high:htg];
}

//------------------------------------------------------------

// draw the scratchpad buttons
-(void)drawScratch {
	UIView *spvw = [self superview];
	[self clearTagsR:self low:SCRATCH_TAG high:SCRATCH_TAG+50];		// clear old UI first
	self.transform = CGAffineTransformIdentity;
	[self adjustNumPad];
	//[spvw bringSubviewToFront:self];
	for (int q = 1; q < NUM_SP_KEYS; q++)
		if (largeFormat || (q != SP_DRAG && q != SP_SIZE)) {
			UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
			if (q == SP_SIZE)
				but.frame = CGRectMake(self.frame.size.width-SPBW, self.frame.size.height-SPBH, SPBW-SPBS, SPBH-SPBS);
			else
				but.frame = CGRectMake(sPadXs[q], sPadYs[q], SPBW-SPBS, SPBH-SPBS);
			if (q > SP_ERASER && q <= SP_BLUE)
				but.backgroundColor = colorList[q-SP_ERASER];
			else
				but.backgroundColor = [UIColor grayColor];
			but.layer.cornerRadius = 7;
			but.layer.masksToBounds = YES;
			but.layer.borderWidth = 1.5f;
			but.layer.borderColor = [[UIColor colorWithRed:(57/255.0) green:(57/255.0) blue:(57/255.0) alpha:1.0] CGColor];
			but.tag = q + SCRATCH_TAG;
			but.clipsToBounds = YES;
			
			[self buttonLabelFull:but text:scratchStr[q] color:colorList[0] font:@"Verdana-Bold" fontsize:12 xborder:2 yborder:-2];
			if (q == SP_DRAG) {		// different handler for dragging
				UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragSPBut:)];
				[but addGestureRecognizer:gesture];
				//[gesture release];
			}
			if (q == SP_SIZE) {		// different handler for sizing
				UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sizeSPBut:)];
				[but addGestureRecognizer:gesture];
				//[gesture release];
			}
			[but addTarget:self action:@selector(handleScratch:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:but];
		}
}

//------------------------------------------------------------

// drag button handler
-(void)dragSPBut:(UIPanGestureRecognizer *)gesture {
	UIButton *button = (UIButton *)gesture.view;
	CGPoint translation = [gesture translationInView:button];
	CGRect frame = self.frame;
	frame.origin.x += translation.x;
	frame.origin.y += translation.y;
	self.frame = frame;
	[self adjustNumPad];
	[gesture setTranslation:CGPointZero inView:button];
	[self setNeedsDisplay];
}

//------------------------------------------------------------

// size button handler
-(void)sizeSPBut:(UIPanGestureRecognizer *)gesture {
	UIButton *button = (UIButton *)gesture.view;
	CGPoint translation = [gesture translationInView:button];
	CGRect frame = self.frame;
	float sizeX = frame.size.width;
	float sizeY = frame.size.height;
	sizeX += translation.x;
	sizeY += translation.y;
	sizeX = MIN(frame.origin.x+sizeX, scrWidth) - frame.origin.x;
	sizeY = MIN(frame.origin.y+sizeY, scrHeight) - frame.origin.y;
	sizeX = MAX(sizeX, 300);			// minimum size required to buttons
	sizeY = MAX(sizeY, 300);
	sizeX = MIN(sizeX, scrWidth);		// in case you need to set a maximum view size
	sizeY = MIN(sizeY, scrHeight);
	frame.size.width = sizeX;
	frame.size.height = sizeY;
	[self newSize:frame.size];
	
	// only the size button needs to move, the rest stay put
	for (UIView *vw in self.subviews) {
		if (vw.tag == SCRATCH_TAG+SP_SIZE) {
			CGRect frame = vw.frame;
			frame.origin = CGPointMake(self.frame.size.width-SPBW, self.frame.size.height-SPBH);
			vw.frame = frame;
		}
	}
	[gesture setTranslation:CGPointZero inView:button];
	[self setNeedsDisplay];
}

//------------------------------------------------------------

// this interrupt controls the replay mode
-(void)replayInt {
	if (lastReplayP >= lastP) {
		replay = NO;
		[self setNeedsDisplay];
	} else {
		lastReplayP++;
		if (lastReplayP > touchEnd[lastReplayT])
			lastReplayT++;
		[self setNeedsDisplay];
		[NSTimer scheduledTimerWithTimeInterval:1/REPLAY_FPS target:self selector:@selector(replayInt) userInfo:nil repeats:NO];
	}
}

//------------------------------------------------------------
// scratchpadup/down calculations and animations

-(void)calcScratchTrans:(float *)tx ty:(float *)ty {
	float butX = scrWidth/4;		// this is the position the button animates from/to
	float butY = scrHeight/4;		// you can adjust to wherever you like
	*tx = self.frame.origin.x - butX + self.frame.size.width/2;
	*ty = self.frame.origin.y - butY + self.frame.size.height/2;
}

-(void)scaleScratchDown {
	float tx, ty;
	[self calcScratchTrans:&tx ty:&ty];
	self.transform = CGAffineTransformIdentity;
	[UIView animateWithDuration:SP_SCALE_SPEED
					 animations:^{CGAffineTransform t = CGAffineTransformMakeTranslation(-tx, -ty);
							self.transform = CGAffineTransformScale(t, SMALL_SP_SCALE, SMALL_SP_SCALE);}
					 completion:^(BOOL finished) {[self drawScratch];
							[self removeFromSuperview];}];
}

-(void)scaleScratchUp {
	[self drawScratch];
	float tx, ty;
	[self calcScratchTrans:&tx ty:&ty];
	self.transform = CGAffineTransformMakeTranslation(-tx, -ty);
	self.transform = CGAffineTransformScale(self.transform, SMALL_SP_SCALE, SMALL_SP_SCALE);
	[UIView animateWithDuration:SP_SCALE_SPEED
					 animations:^{self.transform = CGAffineTransformIdentity;}];
}

- (void) undoLastScratch {
    if (lastT > 1) {
        lastT--;
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = colorsI[lastT] + SCRATCH_TAG;
        [self handleScratch:but];
        lastP = touchEnd[lastT-1];
    } else {
        lastT = 0;
        lastP = 0;
    }
    [self setNeedsDisplay];
    
    
    
}
- (void) redoLastScratch {
    if (lastT < lastMaxUndoT) {
        lastT++;
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = colorsI[lastT] + SCRATCH_TAG;
        [self handleScratch:but];
        lastP = touchEnd[lastT-1];
    }
    [self setNeedsDisplay];
    
}


- (void) replayLastScratch {
    replay = YES;
    lastReplayT = 0;
    lastReplayP = 0;
    [NSTimer scheduledTimerWithTimeInterval:1/REPLAY_FPS target:self selector:@selector(replayInt) userInfo:nil repeats:NO];
    [self setNeedsDisplay];
    
}

- (void) useEraser {
    currentColorI = SP_WHITE;
    [self setNeedsDisplay];
}

- (void) userColor {
    currentColorI = SP_BLACK;
    [self setNeedsDisplay];
}



//------------------------------------------------------------

// handle all the scratchpad buttons except dragging and sizing
-(void)handleScratch:(UIButton *)button {
	int dig = button.tag - SCRATCH_TAG;
	if (dig == SP_CLEAR) {
		[self clear];
		[self drawScratch];
	} else if (dig >= SP_ERASER && dig <= SP_BLUE) {
		currentColorI = dig;
	} else if (dig == SP_REPLAY) {
		replay = YES;
		lastReplayT = 0;
		lastReplayP = 0;
		[NSTimer scheduledTimerWithTimeInterval:1/REPLAY_FPS target:self selector:@selector(replayInt) userInfo:nil repeats:NO];
		[self setNeedsDisplay];
	} else if (dig == SP_HIDE) {
		[self scaleScratchDown];
	} else if (dig == SP_UNDO) {
		if (lastT > 1) {
			lastT--;
			UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
			but.tag = colorsI[lastT] + SCRATCH_TAG;
			[self handleScratch:but];
			lastP = touchEnd[lastT-1];
		} else {
			lastT = 0;
			lastP = 0;
		}
		[self setNeedsDisplay];
	} else if (dig == SP_REDO) {
		if (lastT < lastMaxUndoT) {
			lastT++;
			UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
			but.tag = colorsI[lastT] + SCRATCH_TAG;
			[self handleScratch:but];
			lastP = touchEnd[lastT-1];
		}
		[self setNeedsDisplay];
	}
}

//------------------------------------------------------------
// handle the buffer full alerts

-(void)askClear {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scratch Pad" message:@"The buffer is full.\n\nWould you like to clear the scratch pad?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	//[alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1)
		[self clear];
}

//------------------------------------------------------------
// handle all the touch events

// start a new line
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	if (lastP < MAXP-1) {
		CGFloat scale = self.contentScaleFactor;
		points[lastP*2] = p.x * scale;
		points[lastP*2+1] = p.y * scale;
		touchStart[lastT] = lastP;
		lastP++;
		lastMaxUndoP = lastP;		// reset undo/redo buffer
		lastMaxUndoT = lastT;
		replay = NO;				// turn off replay
	} else {
		[self askClear];			// end of buffer has been reached, prompt user
		return;
	}
}

// continue line
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	
	if (lastP < MAXP-1) {
		CGFloat scale = self.contentScaleFactor;
		points[lastP*2] = p.x * scale;
		points[lastP*2+1] = p.y * scale;
		lastP++;
		lastMaxUndoP = lastP;
		lastMaxUndoT = lastT;
	} else {
		[self askClear];			// end of buffer has been reached, prompt user
		return;
	}
	[self setNeedsDisplay];
}

// end the line
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	if (lastP < MAXP-1) {
		CGFloat scale = self.contentScaleFactor;
		points[lastP*2] = p.x * scale;
		points[lastP*2+1] = p.y * scale;
		lastP++;
		lastMaxUndoP = lastP;
		if (lastT < MAXT-1) {
			touchEnd[lastT] = lastP;
			colorsI[lastT++] = currentColorI;
		} else {
			[self askClear];		// end of buffer has been reached, prompt user
			return;
		}
		lastMaxUndoT = lastT;
	}
	[self setNeedsDisplay];
}

- (int) getCurrentColor {
    return currentColorI;
}

@end
