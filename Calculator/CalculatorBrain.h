//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Trent Ellingsen on 11/7/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(id)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearStack;
- (double)runTestUsingVariableValues:(NSDictionary *)variableValues;
- (NSString *)descriptionOfProgram;
- (id)undo;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

@end
