//
//  GraphViewController.h
//  Calculator
//
//  Created by Trent Ellingsen on 11/26/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController

@property (nonatomic) CGPoint origin;
@property (weak, nonatomic) CalculatorBrain *brain;

@end
