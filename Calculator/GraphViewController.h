//
//  GraphViewController.h
//  Calculator
//
//  Created by Trent Ellingsen on 11/26/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic) CGPoint origin;
@property (strong, nonatomic) id program;
@property (nonatomic) IBOutlet UIToolbar *toolbar;

@end
