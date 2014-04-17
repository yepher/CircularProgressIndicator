//  Created by Chris Wilson on 4.17.2014.
//  Copyright (c) 2014 Chris Wilson All rights reserved.
//

#import "YFRCircularProgressIndicator.h"

@interface YFRCircularProgressIndicator()

@property (retain) NSColor* stripesPattern;

@end

@implementation YFRCircularProgressIndicator
@synthesize value;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    
    return self;
}

- (void)awakeFromNib
{
	[self setupDefaults];

	
}

- (void) setupDefaults {
    
    // Initial thickness should probably be based on a ratio of the view size so it is more consistent across
    // large and small views
    self.thickness = 10;
    self.progressColor = [NSColor colorWithCalibratedRed: 0.041 green: 0.373 blue: 0.997 alpha: 1];
    self.overlayColor = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
    self.textColor = [NSColor colorWithCalibratedRed: 0.041 green: 0.373 blue: 0.997 alpha: 1];
    self.showProgressText = YES;
}

-(void)setValue:(CGFloat)aValue
{
	value = aValue;
	[self setNeedsDisplay: YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    //// Frames
    //NSRect frame = NSMakeRect(76, 33, 41, 41);
    NSRect frame = self.bounds;
    CGFloat minVal = MIN(self.bounds.size.width, self.bounds.size.height);
    frame.origin.x = frame.origin.x+0.5;
    frame.origin.y = frame.origin.y+0.5;
    frame.size.height = minVal-0.5f;
    frame.size.width = minVal-0.5f;
    
    
    //// Adjust value so the top of the circle is zero
    CGFloat progressIndicatorStartAngle = 360-((value*360)-90);
    CGFloat progressIndicatorEndAngle = 90;
    
    
    //// progressBackground Drawing
    NSBezierPath* progressBackgroundPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(NSMinX(frame) + 0.5, NSMinY(frame) + 0.5, NSWidth(frame) - 1, NSHeight(frame) - 1)];
    [self.progressColor setFill];
    [progressBackgroundPath fill];
    [self.progressColor setStroke];
    [progressBackgroundPath setLineWidth: 1];
    [progressBackgroundPath stroke];
    
    
    //// progressIndicator Drawing
    NSRect progressIndicatorRect = NSMakeRect(NSMinX(frame) + 1.5, NSMinY(frame) + 1.5, NSWidth(frame) - 3, NSHeight(frame) - 3);
    NSBezierPath* progressIndicatorPath = [NSBezierPath bezierPath];
    [progressIndicatorPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMidX(progressIndicatorRect), NSMidY(progressIndicatorRect)) radius: NSWidth(progressIndicatorRect) / 2 startAngle: progressIndicatorStartAngle endAngle: progressIndicatorEndAngle clockwise: YES];
    [progressIndicatorPath lineToPoint: NSMakePoint(NSMidX(progressIndicatorRect), NSMidY(progressIndicatorRect))];
    [progressIndicatorPath closePath];
    
    [self.overlayColor setFill];
    [progressIndicatorPath fill];
    [self.overlayColor setStroke];
    [progressIndicatorPath setLineWidth: 1];
    [progressIndicatorPath stroke];
    
    
    //// foregroundMask Drawing
    NSRect foregroundFrame = NSMakeRect(NSMinX(frame) + _thickness, NSMinY(frame) + _thickness, NSWidth(frame) - (_thickness*2), NSHeight(frame) - (_thickness*2));
    NSBezierPath* foregroundMaskPath = [NSBezierPath bezierPathWithOvalInRect: foregroundFrame];
    [self.overlayColor setFill];
    [foregroundMaskPath fill];
    [self.overlayColor setStroke];
    [foregroundMaskPath setLineWidth: 1];
    [foregroundMaskPath stroke];
    
    
    if (_showProgressText) {
        //// Abstracted Attributes
        NSString* textContent = [NSString stringWithFormat:@"%.0f %%", value*100];
        
        
        //// Text Drawing
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [textStyle setAlignment: NSCenterTextAlignment];
        
        NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [self fontSizedForAreaSize:foregroundFrame.size withString:@"100 %" usingFont:[NSFont fontWithName: @"Helvetica" size: 12]]  , NSFontAttributeName,
                                            self.textColor, NSForegroundColorAttributeName,
                                            textStyle, NSParagraphStyleAttributeName, nil];

        
        NSSize textSize = [textContent sizeWithAttributes:textFontAttributes];
        CGFloat xPos = frame.origin.x + ((frame.size.width-textSize.width)/2);
        CGFloat yPos = frame.origin.y + ((frame.size.height-textSize.height)/2);
        
        NSRect textRect = NSMakeRect(xPos, yPos, textSize.width, textSize.height);
        
        [textContent drawInRect: NSOffsetRect(textRect, 0, 1) withAttributes: textFontAttributes];

    }
}

-(float)scaleToAspectFit:(CGSize)source into:(CGSize)into padding:(float)padding
{
    return MIN((into.width-padding) / source.width, (into.height-padding) / source.height);
}

// From: http://stackoverflow.com/questions/7272089/how-can-i-calculate-without-search-a-font-size-to-fit-a-rect
-(NSFont*)fontSizedForAreaSize:(NSSize)size withString:(NSString*)string usingFont:(NSFont*)font;
{
    NSFont* sampleFont = [NSFont fontWithDescriptor:font.fontDescriptor size:12.];//use standard size to prevent error accrual
    CGSize sampleSize = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:sampleFont, NSFontAttributeName, nil]];
    float scale = [self scaleToAspectFit:sampleSize into:size padding:10];
    return [NSFont fontWithDescriptor:font.fontDescriptor size:scale * sampleFont.pointSize];
}


@end
