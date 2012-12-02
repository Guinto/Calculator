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
@property (nonatomic) UIBarButtonItem *splitViewBarButtonItem;
@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graphView = _graphView;
@synthesize origin = _origin;
@synthesize delagate = _delagate;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    [self.graphView setNeedsDisplay]; // any time our Model changes, redraw our View
}

- (void)setProgram:(id)program
{
	_program = program;
	NSLog(@"yo");
	[self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    // enable pinch gestures in the GraphView using its pinch: handler
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOriginGesture:)]];  // gesture to modify our Model
	UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapToOriginGesture:)];
	tapGesture.numberOfTapsRequired = 3;
	
	[self.graphView addGestureRecognizer:tapGesture];
	
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

- (void)tripleTapToOriginGesture:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture locationInView:self.graphView];
		CGPoint newOrigin;
		newOrigin.x = translation.x;
		newOrigin.y = translation.y;
        self.origin = newOrigin;
	}
}

- (CGPoint)originForGraphView:(GraphView *)sender
{
    return self.origin; // translate Model for View
}

- (double)yCoordForGraphView:(GraphView *)sender usingVariableValues:(NSDictionary *)variableValues
{
	return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
	[super loadView];
	self.title = [CalculatorBrain descriptionOfProgram:self.program];
	
	CGPoint initOrigin;
	initOrigin.x = self.graphView.bounds.size.width / 2;
	initOrigin.y = self.graphView.bounds.size.height / 2;
	
	self.origin = initOrigin;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.delagate = self;
	// Do any additional setup after loading the view.
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
	return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
	if (self.splitViewBarButtonItem) {
		[toolbarItems removeObject:self.splitViewBarButtonItem];
	}
	if (barButtonItem) {
		[toolbarItems insertObject:barButtonItem atIndex:0];
	}
	self.toolbar.items = toolbarItems;
	self.splitViewBarButtonItem	= barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
	barButtonItem.title = @"Calculator";
	[self setSplitViewBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	[self setSplitViewBarButtonItem:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
