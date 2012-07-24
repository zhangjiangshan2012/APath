//
//  APath.m
//  APath
//
//  Created by mac on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APath.h"
@implementation OBJECT
@synthesize priority,rect,parent,F,G,H;
-(id) initWithRect:(CGRect) newRect Parent:(OBJECT *) newParent priority:(int) newPriority  
{
	if(self=[super init])
	{
		self.rect=newRect;
		self.parent=newParent;
		self.priority=newPriority;
	}
	return self;
}
-(BOOL) ShouldCross:(OBJECT *) object
{
	if(self.priority<=object.priority&&CGRectIntersectsRect(self.rect,object.rect))  //权限小于等于障碍物且相交则不能过去
		return NO;		
	else 
		return YES;
	
}
-(BOOL) isEqualToOBJECT:(OBJECT *) object
{	if(CGRectEqualToRect(self.rect,object.rect)&&self.priority==object.priority)
		return YES;
	else 
		return NO;
	
}
- (NSString *)description
{ 
	return [NSString stringWithFormat:@"%@",NSStringFromCGRect(self.rect)];
}
-(void) dealloc
{
	[parent release];
	[super dealloc];
}
@end


@implementation APath
@synthesize start,purpose,loopNum,scearchTimes,isScearching,blockList,isDead,finalList;
-(id) initWithWorld:(CGRect) world
{
	if(self=[super init])
	{
		worldRect=world;
		isScearching=NO;
		isDead=NO;
		openList=[[NSMutableArray alloc] init];
		closeList=[[NSMutableArray alloc] init];
		finalList=[[NSMutableArray alloc] init];
		blockList=[[NSMutableArray alloc] init];
	}
	return self;
}
-(void) makeStart:(CGRect) newRect priority:(int) i
{
	OBJECT * ob=[[OBJECT alloc] initWithRect:newRect Parent:nil priority:i];
	self.start=ob;
	[ob release];
}
-(void) makePurpose:(CGRect) newRect priority:(int) i
{
	OBJECT * ob=[[OBJECT alloc] initWithRect:newRect Parent:nil priority:i];
	self.purpose=ob;
	[ob release];
}
-(void) addBlock:(CGRect) newRect priority:(int) i
{
	OBJECT * block=[[OBJECT alloc] initWithRect:newRect Parent:nil priority:i];
	[blockList addObject:block];
	[block release];
}
-(void) clearList
{
	[openList removeAllObjects];
	[closeList removeAllObjects];
	[finalList removeAllObjects];
	
}
-(void) clearBlockList
{
	[blockList removeAllObjects];
}
-(NSMutableArray *) scearch
{
	[self clearList];
    scearchTimes=0;
	isScearching=YES;
	[self scearchChildren:start];
	isScearching=NO;
	return finalList;
	
}
-(void) scearchChildren:(OBJECT *) parentOb
{
	scearchTimes++;
	float x=parentOb.rect.origin.x;
	float y=parentOb.rect.origin.y;
	float w=parentOb.rect.size.width;
	float h=parentOb.rect.size.height;
	CGRect rect1={x-w,y,w,h};
	CGRect rect2={x+w,y,w,h};
	CGRect rect3={x,y-h,w,h};
	CGRect rect4={x,y+h,w,h};
	
	CGRect rect5={x-w,y-h,w,h};
	CGRect rect6={x-w,y+h,w,h};
	CGRect rect7={x+w,y-h,w,h};
	CGRect rect8={x+w,y+h,w,h};
	
	if([self creatChildRect:rect1 ParentOb:parentOb]==1) return;  //等于1则已寻路到终点
	if([self creatChildRect:rect2 ParentOb:parentOb]==1) return;
	if([self creatChildRect:rect3 ParentOb:parentOb]==1) return;
	if([self creatChildRect:rect4 ParentOb:parentOb]==1) return;
	if([self creatChildRect:rect5 ParentOb:parentOb]==1) return;
	if([self creatChildRect:rect6 ParentOb:parentOb]==1) return;
	if([self creatChildRect:rect7 ParentOb:parentOb]==1) return;
	if([self creatChildRect:rect8 ParentOb:parentOb]==1) return;
	[closeList addObject:parentOb];
	[openList removeObject:parentOb];
	
	if(openList.count==0)   //如果开启列表无值
	{
		isDead=YES;
		NSLog(@"无路可走");
		//[self endMethod];	//无路可走
		return ;
		
	}
	
	//从小到大排序
	
	[openList sortUsingComparator: ^(id obj1, id obj2) {
		OBJECT * ob1=(OBJECT *)obj1;
		OBJECT * ob2=(OBJECT *)obj2;
		if (ob1.H > ob2.H) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		
		if (ob1.H < ob2.H) {
			return (NSComparisonResult)NSOrderedAscending;
		}
		return (NSComparisonResult)NSOrderedSame;
	}];	
	OBJECT * parent=[openList objectAtIndex:0];
		
	
	[self scearchChildren:parent];	
	
	
}
-(int) creatChildRect:(CGRect) newRect ParentOb:(OBJECT *) parentOb
{
	loopNum++;
	if(!CGRectContainsRect(worldRect, newRect)) return 0;  //是否超出边界
	OBJECT *ob=[[OBJECT alloc] initWithRect:newRect Parent:parentOb priority:parentOb.priority];
	
	ob.G=abs(start.rect.origin.x-ob.rect.origin.x)+abs(start.rect.origin.y-ob.rect.origin.y);
	ob.H=abs(purpose.rect.origin.x-ob.rect.origin.x)+abs(purpose.rect.origin.y-ob.rect.origin.y);
	ob.F=ob.G+ob.H;
	
	for(OBJECT * blockObject in blockList) //是否为障碍物
	{
		loopNum++;
		if(![ob ShouldCross:blockObject]) 
		{
			goto state;
		}
	}
	for(OBJECT * openObject in openList)   //是否在开启列表
	{
		loopNum++;
		if([ob isEqualToOBJECT:openObject]) 
		{
			goto state;
		}
	}
	for(OBJECT * closeObject in closeList)   //是否在关闭列表
	{
		loopNum++;
		if([ob isEqualToOBJECT:closeObject]) 
		{
			goto state;
		}
	}
	if(abs(parentOb.rect.origin.y-ob.rect.origin.y)+abs(parentOb.rect.origin.x-ob.rect.origin.x)==2) //斜走判断两边
	{
		CGRect rect1={parentOb.rect.origin.x,ob.rect.origin.y,ob.rect.size.width,ob.rect.size.height};
		CGRect rect2={ob.rect.origin.x,parentOb.rect.origin.y,ob.rect.size.width,ob.rect.size.height};
		OBJECT *ob1=[[OBJECT alloc] initWithRect:rect1 Parent:nil priority:parentOb.priority];
		OBJECT *ob2=[[OBJECT alloc] initWithRect:rect2 Parent:nil priority:parentOb.priority];
		int sign=0;
		for(OBJECT * openObject in openList)
		{
			loopNum++;
			if([ob1 isEqualToOBJECT:openObject]) 
			{
				sign++;
			}
			if([ob2 isEqualToOBJECT:openObject]) 
			{
				sign++;
			}
		}
		[ob1 release];
		[ob2 release];
		if(sign!=2)
		{
			NSLog(@"sign:%d",sign);
			goto state;
		}
	}
	if(CGRectIntersectsRect(ob.rect,purpose.rect))//到达终点
	{
		loopNum++;
		[closeList addObject:parentOb];
		[openList removeObject:parentOb];
		isDead=NO;
		[self makeFinalList:ob];		
		return 1;
	}
	[openList addObject:ob];	
state:
	[ob release];
	return 0;
}
-(void) makeFinalList:(OBJECT *) object
{
	[finalList addObject:[NSValue valueWithCGRect:object.rect]];
	if(object.parent!=nil) 
	{	
		[self makeFinalList:object.parent];
	}
	else 
	{
		NSLog(@"获取FinalList成功");
		[self reverse:finalList];
	}
	
}
-(void) reverse:(NSMutableArray *) array
{
	int i = 0;	
    int j = [array count] - 1;
    while (i < j) 
	{	
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;		
        j--;		
    }
}

-(void) dealloc
{
	[start release];
	[purpose release];
	[openList release];
	[closeList release];
	[finalList release];	
	[blockList release];
    [super dealloc];
}
@end
