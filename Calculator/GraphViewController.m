//
//  GraphViewController.m
//  Calculator
//
//  Created by Trent Ellingsen on 11/26/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController() <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize brain = _brain;
@synthesize graphView = _graphView;
@synthesize origin = _origin;

- (CalculatorBrain *)programForGraphView:(GraphView *)sender
{
	return self.brain;
}

- (void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    [self.graphView setNeedsDisplay]; // any time our Model changes, redraw our View
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    // enable pinch gestures in the GraphView using its pinch: handler
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOriginGesture:)]];  // gesture to modify our Model
    self.graphView.dataSource = self;
}

- (void)handleOriginGesture:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphView];
		CGPoint newOrigin;
		newOrigin.x = self.origin.x + translation.x;
		newOrigin.y = self.origin.y + translation.y;
        self.origin = newOrigin;
        [gesture setTranslation:CGPointZero inView:self.graphView];
    }
}

- (CGPoint)originForGraphView:(GraphView *)sender
{
    return self.origin; // translate Model for View
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
	[super loadView];
	self.title = [self.brain descriptionOfProgram];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
