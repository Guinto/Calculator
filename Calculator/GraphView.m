//
//  GraphView.m
//  Calculator
//
//  Created by Trent Ellingsen on 11/26/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "GraphView.h"

@interface GraphView()
@property (nonatomic) CGPoint origin;
@end

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

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
	self.scale = 35;
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

- (double)getRealX:(NSNumber *)x
{
	return [x doubleValue] * self.scale + self.origin.x;
}

- (double)getRealY:(double)y
{
	return -(y * self.scale - self.origin.y);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	self.origin = [self.dataSource originForGraphView:self];
	CGRect bounds = self.bounds;
	
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
	
	// Initial point
	NSNumber *x = [NSNumber numberWithDouble:-(bounds.size.width / 2) - self.origin.x];
	NSDictionary *xCoord = [NSDictionary dictionaryWithObject:x forKey:@"x"];
	double y = [self.dataSource yCoordForGraphView:self usingVariableValues:xCoord];
	
	// Get context to draw
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIGraphicsPushContext(context);
	
	// Draw initial point
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, [self getRealX:x], [self getRealY:y]);
	
	// Draw subsequent points
	for (double i = [x doubleValue]; i < (bounds.size.width - self.origin.x); i++) {
		x = [NSNumber numberWithDouble:i / self.scale];
		xCoord = [NSDictionary dictionaryWithObject:x forKey:@"x"];
		y = [self.dataSource yCoordForGraphView:self usingVariableValues:xCoord];
		CGContextAddLineToPoint(context, [self getRealX:x], [self getRealY:y]);
	}
	
	CGContextStrokePath(context);
	
	UIGraphicsPopContext();
}

@end
