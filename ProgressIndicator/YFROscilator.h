//  Created by Chris Wilson on 4.17.2014.
//  Copyright (c) 2014 Chris Wilson All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFRCircularProgressIndicator;

@interface YFROscilator : NSObject
@property (assign) CGFloat	value;
@property (assign) CGFloat	step;

@property (assign) BOOL running;
@property (retain) IBOutlet  YFRCircularProgressIndicator* progressIndicator;
- (IBAction)start:(id)sender;

@end
