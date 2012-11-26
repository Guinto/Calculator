//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Trent Ellingsen on 11/6/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *variableValues;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end
