//
//  APathViewController.m
//  APath
//
//  Created by mac on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APathViewController.h"

@implementation APathViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    NSLog(@"self.frame:%@",NSStringFromCGRect(self.view.frame));
	aPath=[[APath alloc] initWithWorld:self.view.frame];
	blocks=[[NSMutableArray alloc] init];
	pathViews=[[NSMutableArray alloc] init];

	startView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, START_W,  START_H)];
	startView.backgroundColor=[UIColor redColor];
	
	endView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, END_W,  END_H)];
	endView.backgroundColor=[UIColor blueColor];

}

-(IBAction) clickClearScreen:(UIBarButtonItem *) sender
{
	for(UIView * myView in self.view.subviews)
	{
		if([NSStringFromClass([myView class]) isEqualToString:@"UIView"])
			[myView removeFromSuperview];
	}
	[blocks removeAllObjects];
	[pathViews removeAllObjects];

}
-(IBAction) clickRandomBlock:(UIBarButtonItem *) sender
{

	//[blocks removeAllObjects];
	int i=0;
	while(i<BLOCK_NUM)
	{
		UIView *block =[[UIView alloc] initWithFrame:CGRectMake(arc4random()%768,arc4random()%1004,BLOCK_W,BLOCK_H)];
		block.backgroundColor=[UIColor cyanColor];
		if(CGRectContainsRect(self.view.frame, block.frame))
		{
			[self.view insertSubview:block atIndex:0];
			[blocks addObject:block];
			i++;
		}
		[block release];
		
	}
}
int step=0;
-(IBAction) clickBeganScearch:(UIBarButtonItem *) sender
{
	[aPath clearBlockList];
	[aPath makeStart:startView.frame priority:1];
	[aPath makePurpose:endView.frame priority:1];
	for(UIView * block in blocks)
	{
		[aPath addBlock:block.frame priority:1];
	}
	if(path!=nil)
	{
		[path removeAllObjects];
		[path release];
	}
	path=[[aPath scearch] retain];
	if(path.count!=0)
	{
		NSLog(@"path.count:%d",path.count);
		step=0;
		[self beginAnimate];
	}
	else if(aPath.isDead==YES)
	{
		UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"是死路" message:@"悲剧" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil	];
		[alert show];
		[alert release];
	}
}

-(void) beginAnimate
{
	if(step<path.count)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[startView setFrame:[[path objectAtIndex:step] CGRectValue]];
		[UIView commitAnimations];
	}
	else 
	{
		UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"寻路完成" message:[NSString stringWithFormat:@"所走步数:%d\t搜索次数:%d",aPath.finalList.count,aPath.scearchTimes] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if([finished boolValue]==NO) return;
	
	UIView * pathView=[[UIView alloc] initWithFrame:[[path objectAtIndex:step] CGRectValue]];
	pathView.backgroundColor=[UIColor greenColor];
	[self.view insertSubview:pathView belowSubview:startView];
	[pathViews addObject:pathView];
	[pathView release];
	step++;
	[self beginAnimate];
	
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch=[touches anyObject];
	CGPoint location=[touch locationInView:self.view];
	if(segment.selectedSegmentIndex==0)
	{
		if(startView.superview==nil)
		{
			[self.view addSubview:startView];
		}
		startView.frame=CGRectMake(location.x, location.y, START_W, START_H);
		
	}
	else if(segment.selectedSegmentIndex==1)
	{
		if(endView.superview==nil)
		{
			[self.view addSubview:endView];
		}
		endView.frame=CGRectMake(location.x, location.y, END_W, END_H);
	}
	else if(segment.selectedSegmentIndex==2)
	{
		UIView * block=[[UIView alloc] initWithFrame:CGRectMake(0, 0, BLOCK_W ,BLOCK_H)];
		block.backgroundColor=[UIColor cyanColor];
		block.frame=CGRectMake(location.x, location.y, END_W, END_H);
		//[self.view addSubview:block];
		[self.view insertSubview:block atIndex:0];
		[blocks addObject:block];
		[block release];
	}

}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation==UIInterfaceOrientationPortrait||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	if(path!=nil)
		[path release];
	[startView release];
	[endView release];
	[aPath release];
	[pathViews release];
    [super dealloc];
}

@end
