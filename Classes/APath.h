//
//  APath.h
//  APath
//
//  Created by mac on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface OBJECT : NSObject
{
	CGRect rect;
	OBJECT * parent;
	int priority; 
	int F;
	int G;
	int H;
}
@property(nonatomic,assign) CGRect rect;
@property(nonatomic,retain) OBJECT * parent;
@property(nonatomic,assign) int priority;
@property(nonatomic,assign) int F;
@property(nonatomic,assign) int G;
@property(nonatomic,assign) int H;

-(BOOL) ShouldCross:(OBJECT *) object;
-(id) initWithRect:(CGRect) newRect Parent:(OBJECT *) newParent priority:(int) newPriority ;
@end

@interface APath : NSObject 
{
	BOOL isScearching;
	BOOL isDead;
	CGRect worldRect;
	NSMutableArray * openList;
	NSMutableArray * closeList;
	NSMutableArray * finalList;
	NSMutableArray * blockList;
	
	OBJECT * start;
	OBJECT * purpose;
	
	int loopNum;
	int scearchTimes;
}
@property(nonatomic,retain) OBJECT * start;
@property(nonatomic,retain) OBJECT * purpose;
@property(nonatomic,assign) int loopNum;
@property(nonatomic,assign) int scearchTimes;
@property(nonatomic,assign)	BOOL isScearching;
@property(nonatomic,assign)	BOOL isDead;
@property(nonatomic,retain) NSMutableArray * blockList;
@property(nonatomic,readonly) NSMutableArray * finalList;
-(id) initWithWorld:(CGRect) world;
-(void) makeStart:(CGRect) newRect priority:(int) i;// 设置开始目标
-(void) makePurpose:(CGRect) newRect priority:(int) i; //设置结束目标
-(void) addBlock:(CGRect) newRect priority:(int) i;  //设置障碍物
-(NSMutableArray *) scearch; //  开始查找 返回包含 CGRect的 NSValue指针

-(void) clearList;
-(void) clearBlockList;
-(void) scearchChildren:(OBJECT *) parentOb;
-(int) creatChildRect:(CGRect) newRect ParentOb:(OBJECT *) parentOb;
-(void) makeFinalList:(OBJECT *) object;
-(void) reverse:(NSMutableArray *) array; //数组顺序反转


@end
