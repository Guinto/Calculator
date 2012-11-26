//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Trent Ellingsen on 11/7/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

+ (BOOL)isOperation:(NSString *)operand
{
	return [operand isEqualToString:@"sqrt"] || [operand isEqualToString:@"sin"] || [operand isEqualToString:@"cos"] || [operand isEqualToString:@"π"] || [operand isEqualToString:@"*"] || [operand isEqualToString:@"/"] || [operand isEqualToString:@"+"] || [operand isEqualToString:@"-"];
}

+ (BOOL)isDoubleOperandOperation:(NSString *)operation
{
	return [operation isEqualToString:@"*"] || [operation isEqualToString:@"/"] || [operation isEqualToString:@"+"] || [operation isEqualToString:@"-"];
}

+ (BOOL)isSingleOperandOperation:(NSString *)operation
{
	return [operation isEqualToString:@"sqrt"] || [operation isEqualToString:@"sin"] || [operation isEqualToString:@"cos"];
}

+ (BOOL)isNoOperandOperation:(NSString *)operation
{
	return [operation isEqualToString:@"π"];
}

- (NSMutableArray *)programStack
{
	if (_programStack == nil) {
		_programStack = [[NSMutableArray alloc] init];
	}
	return _programStack;
}

- (void)clearStack
{
	self.programStack = nil;
}

- (id)undo
{
	[self.programStack removeLastObject];
	id object = [self.programStack lastObject];
	if (!object) {
		self.programStack = nil;
	}
	return object;
}

- (void)setOperandStack:(NSMutableArray *)programStack
{
	_programStack = programStack;
}

- (void)pushOperand:(id)operand
{
	// If it is an operand do not accept
	if ([operand isKindOfClass:[NSString class]] && [[self class] isOperation:operand]) {
		return;
	}
	// Can be a number or string for variable
	[self.programStack addObject:operand];
}

- (double)performOperation:(NSString *)operation
{
	[self.programStack addObject:operation];
	return [[self class] runProgram:self.programStack];
}

- (double)runTestUsingVariableValues:(NSDictionary *)variableValues
{
	return [[self class] runProgram:self.programStack usingVariableValues:variableValues];
}

- (NSString *)descriptionOfProgram
{
	return [[self class] descriptionOfProgram:self.programStack];
}

- (id)program
{
	return [self.programStack copy];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
	NSMutableSet *variables = [[NSMutableSet alloc] init];
	
	for (int i = 0; i < [program count]; i++) {
		if ([[program objectAtIndex:i] isKindOfClass:[NSString class]]) {
			[variables addObject:[program objectAtIndex:i]];
		}
	}
	
	return [variables count] == 0 ? nil : variables;
}

+ (int)commasNeeded:(NSMutableArray *)stack
{
	int commasNeeded = -1;
	
	for (int i = 0; i < [stack count]; i++) {
		id item = [stack objectAtIndex:i];
		
		if ([item isKindOfClass:[NSString class]]) {
			if ([self isDoubleOperandOperation:item]) {
				commasNeeded--;
			} else if ([self isSingleOperandOperation:item]) {
				commasNeeded--;
			} else if ([self isNoOperandOperation:item]) {
				commasNeeded++;
			} else {
				// variable
				commasNeeded++;
			}
		} else {
			// digit
			commasNeeded++;
		}
	}
	
	return commasNeeded;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack withCommas:(int)numCommas
{
	NSString *result = @"";
			
	id topOfStack = [stack lastObject];
	if (topOfStack) {
		[stack removeLastObject];
	}
	
	if ([topOfStack isKindOfClass:[NSNumber class]]) {
		result = [topOfStack stringValue];
	} else if ([topOfStack isKindOfClass:[NSString class]]) {
		NSString *operation = topOfStack;
		
		if ([self isDoubleOperandOperation:operation]) {
			result = [NSString stringWithFormat:@"(%@ %@ %@)", [self descriptionOfTopOfStack:stack withCommas:(numCommas - 1)], topOfStack, [self descriptionOfTopOfStack:stack withCommas:(numCommas - 1)]];
		} else if ([self isSingleOperandOperation:operation]) {
			result = [NSString stringWithFormat:@"%@(%@)", topOfStack, [self descriptionOfTopOfStack:stack withCommas:(numCommas - 1)]];
		} else if ([self isNoOperandOperation:operation]) {
			result = topOfStack;
		} else {
			// variable
			result = topOfStack;
		}
	}
	
	NSString *resultWithCommas = result;
	if (numCommas > 0) {
		NSString *ammend = [self descriptionOfTopOfStack:stack withCommas:(numCommas - 1)];
		resultWithCommas = [NSString stringWithFormat:@"%@, %@", result, ammend];
	}
	
	return resultWithCommas;
}

+ (NSString *)descriptionOfProgram:(id)program
{
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}

	int commasNeeded = [self commasNeeded:stack];
	
	return [self descriptionOfTopOfStack:stack withCommas:commasNeeded];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
	double result = 0;
	
	id topOfStack = [stack lastObject];
	if (topOfStack) {
		[stack removeLastObject];
	}
	
	if ([topOfStack isKindOfClass:[NSNumber class]]) {
		result = [topOfStack doubleValue];
	} else if ([topOfStack isKindOfClass:[NSString class]]) {
		NSString *operation = topOfStack;
		if ([operation isEqualToString:@"+"]) {
			result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
		} else if ([operation isEqualToString:@"-"]) {
			result = [self popOperandOffStack:stack] - [self popOperandOffStack:stack];
		} else if ([operation isEqualToString:@"*"]) {
			result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
		} else if ([operation isEqualToString:@"/"]) {
			double divisor = [self popOperandOffStack:stack];
			if (divisor) {
				result = [self popOperandOffStack:stack] / divisor;
			}
		} else if ([operation isEqualToString:@"π"]) {
			result = M_PI;
		} else if ([operation isEqualToString:@"sin"]) {
			result = sin([self popOperandOffStack:stack]);
		} else if ([operation isEqualToString:@"cos"]) {
			result = cos([self popOperandOffStack:stack]);
		} else if ([operation isEqualToString:@"sqrt"]) {
			result = sqrt([self popOperandOffStack:stack]);
		} 
	}
	
	return result;
}

+ (double)runProgram:(id)program
{
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}
	
	return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}
	
	if (variableValues) {
		for (int i = 0; i < [program count]; i++) {
			id operand = [program objectAtIndex:i];
			// checks if variable
			if ([operand isKindOfClass:[NSString class]] && ![[self class] isOperation:operand]) {
				// replaces variable with actual double
				if ([variableValues objectForKey:operand]) {
					[stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:operand]];
				}
			}
		}
	}
	
	return [self popOperandOffStack:stack];
}

@end
