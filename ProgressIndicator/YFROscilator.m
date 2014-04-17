//  Created by Chris Wilson on 4.17.2014.
//  Copyright (c) 2014 Chris Wilson All rights reserved.
//

#import "YFROscilator.h"
#import "YFRCircularProgressIndicator.h"

#define CLAMP(x, minimum, maximum) \
MIN((maximum), MAX((minimum), (x)))

@interface YFROscilator()
@property (weak) NSTimer* timer;
@property (assign) BOOL incrementing;
@end

@implementation YFROscilator


- (id)init
{
	self = [super init];
    if (self) {
        // Initialization code here.
		self.running = FALSE;
		self.timer = nil;
		self.value = 0;
		self.step = 0.001;
    }
    
    return self;
	
}

- (IBAction)start:(id)sender
{
		
	  if ([sender state] == NSOnState)
	  {
		 [self.timer invalidate]; 
	  }
	  else
	  {
		  NSThread* timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(timerStart) object:nil]; //Create a new thread
		  [timerThread start]; 

	  }
}


-(void)timerStart
{
	@autoreleasepool
	{
	    NSRunLoop *TimerRunLoop = [NSRunLoop currentRunLoop];

			self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
														  target:self selector:@selector(targetMethod:)
													userInfo:nil repeats:YES] ;
		[TimerRunLoop run];
    }
	

}



- (void)targetMethod:(NSTimer*)theTimer
{

	if (self.incrementing)
		self.value=CLAMP(self.value + self.step, 0, 1);
	else
		self.value=CLAMP(self.value - self.step, 0, 1);
		
		if (self.value >= 1.0f)
			self.incrementing = FALSE;
		
		if (self.value <= 0.0f)
				self.incrementing = TRUE;
	
	self.progressIndicator.value = self.value;
}

- (void)dealloc
{
	[self.timer invalidate];
}

@end
