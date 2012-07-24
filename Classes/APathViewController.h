//
//  APathViewController.h
//  APath
//
//  Created by mac on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APath.h"
#define BLOCK_NUM 100.0
#define START_W 10
#define START_H 10
#define END_W 10
#define END_H 10
#define BLOCK_W 10
#define BLOCK_H 10
@interface APathViewController : UIViewController 
{
	IBOutlet UIBarButtonItem * clearScreen;
	IBOutlet UIBarButtonItem * randomBlock;
	IBOutlet UISegmentedControl * segment;
	APath * aPath;
	
	UIView * startView;
	UIView * endView;
	NSMutableArray * blocks;
	NSMutableArray * pathViews;
	
	NSMutableArray * path;
}
-(IBAction) clickClearScreen:(UIBarButtonItem *) sender;
-(IBAction) clickRandomBlock:(UIBarButtonItem *) sender;
-(IBAction) clickBeganScearch:(UIBarButtonItem *) sender;
-(void) beginAnimate;
@end

