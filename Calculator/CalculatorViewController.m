//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Trent Ellingsen on 11/6/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) NSMutableDictionary *testVariableValues;

@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;
@synthesize variableValues = _variableValues;
@synthesize description = _description;

- (CalculatorBrain *)brain
{
	if (!_brain) {
		_brain = [[CalculatorBrain alloc] init];
	}
	return _brain;
}

- (IBAction)testPressed:(UIButton *)sender {
	NSString *test = sender.currentTitle;
	
	self.testVariableValues = [[NSMutableDictionary alloc] init];
	
	if ([test isEqualToString:@"test1"]) {
		[self.testVariableValues setObject:[NSNumber numberWithDouble:3] forKey:@"x"];
		self.variableValues.text = @"x = 3";
	} else if ([test isEqualToString:@"test2"]) {
		[self.testVariableValues setObject:[NSNumber numberWithDouble:44.5] forKey:@"x"];
		[self.testVariableValues setObject:[NSNumber numberWithDouble:4] forKey:@"y"];
		[self.testVariableValues setObject:[NSNumber numberWithDouble:-14] forKey:@"foo"];
		self.variableValues.text = @"x = 44.5 y = 4 foo = -14";
	} else {
		self.testVariableValues = nil;
		self.variableValues.text = @"nil";
	}
		
	double result = [self.brain runTestUsingVariableValues:self.testVariableValues];

	self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)variablePressed:(UIButton *)sender {
	self.userIsInTheMiddleOfEnteringANumber = NO;
	
	NSString *variable = sender.currentTitle;
	[self.brain pushOperand:variable];
	
	self.display.text = variable;
	self.description.text = [self.brain descriptionOfProgram];
}

- (IBAction)clearPressed {
	self.display.text = @"0";
	self.variableValues.text = @"";
	self.description.text = @"";
	self.userIsInTheMiddleOfEnteringANumber = NO;
	[self.brain clearStack];
}

- (IBAction)undoPressed {
	if (self.userIsInTheMiddleOfEnteringANumber) {
		self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
		if (self.display.text.length == 0) {
			self.userIsInTheMiddleOfEnteringANumber = NO;
			self.display.text = [[NSNumber numberWithDouble:[self.brain runTestUsingVariableValues:nil]] stringValue];
		}
	} else {
		id previous = [self.brain undo];
		if (![previous isKindOfClass:[NSString class]]) {
			if (previous) {
				self.display.text = [previous stringValue];
				self.userIsInTheMiddleOfEnteringANumber = YES;
			} else {
				self.display.text = @"0";
			}
		}
	}
	self.description.text = [self.brain descriptionOfProgram];
}

- (IBAction)digitPressed:(UIButton *)sender {
	NSString *digit = sender.currentTitle;
	if ([digit isEqualToString:@"."]) {
		BOOL isDouble = [self.display.text doubleValue] != [self.display.text intValue];
		if (isDouble) {
			return;
		}
	}
	if (self.userIsInTheMiddleOfEnteringANumber) {
		self.display.text = [self.display.text stringByAppendingString:digit];
	} else {
		self.display.text = digit;
		self.userIsInTheMiddleOfEnteringANumber = YES;
	}
}
- (IBAction)operationPressed:(UIButton *)sender {
	if (self.userIsInTheMiddleOfEnteringANumber) {
		[self enderPressed];
	}
	double result = [self.brain performOperation:sender.currentTitle];
	NSString *resultString = [NSString stringWithFormat:@"%g", result];
	self.display.text = resultString;
	self.description.text = [self.brain descriptionOfProgram];
}

- (IBAction)enderPressed {
	NSNumber *operand = [NSNumber numberWithDouble:[self.display.text doubleValue]];
	[self.brain pushOperand:operand];
	self.userIsInTheMiddleOfEnteringANumber = NO;
	self.description.text = [self.brain descriptionOfProgram];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
