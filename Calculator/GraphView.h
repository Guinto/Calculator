//
//  GraphView.h
//  Calculator
//
//  Created by Trent Ellingsen on 11/26/12.
//  Copyright (c) 2012 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@protocol GraphViewDataSource
//- (float)smileForFaceView:(FaceView *)sender;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;  // resizes the graph

// set this property to whatever object will provide this View's data
// usually a Controller using a GraphView in its View
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;


@end
