//  Created by Chris Wilson on 4.17.2014.
//  Copyright (c) 2014 Chris Wilson All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface YFRCircularProgressIndicator : NSView

@property (assign, nonatomic) CGFloat value;

@property (assign, nonatomic) CGFloat thickness;

@property (nonatomic, strong) NSColor* progressColor;
@property (nonatomic, strong) NSColor* overlayColor;
@property (nonatomic, strong) NSColor* textColor;

@property (nonatomic) BOOL showProgressText;

@end
