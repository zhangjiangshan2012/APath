//
//  APathAppDelegate.h
//  APath
//
//  Created by mac on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APathViewController;

@interface APathAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    APathViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet APathViewController *viewController;

@end

