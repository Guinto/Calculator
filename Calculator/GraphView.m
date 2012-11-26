//
//  GraphView.m
//  Calculator
//
//  Created by Trent Ellingsen on 11/26/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

#define DEFAULT_SCALE 0.90

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGPoint origin = [self.dataSource originForGraphView:self];
	CGRect bounds = self.bounds;
	
    [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:self.scale];
	
	CalculatorBrain *brain = [self.dataSource programForGraphView:self];
	
	NSNumber *x = [NSNumber numberWithDouble:origin.x];
	NSDictionary *xCoord = [NSDictionary dictionaryWithObject:x forKey:@"x"];
	double y = [brain runTestUsingVariableValues:xCoord];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIGraphicsPushContext(context);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, [x doubleValue], y);
	
	for (int i = 0; i < bounds.size.width; i++) {
		x = [NSNumber numberWithDouble:i];
		xCoord = [NSDictionary dictionaryWithObject:x forKey:@"x"];
		y = [brain runTestUsingVariableValues:xCoord];
		CGContextAddLineToPoint(context, [x doubleValue], y);
	}
	
	CGContextStrokePath(context);
	
	UIGraphicsPopContext();
}

@end
