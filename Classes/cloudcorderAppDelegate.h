//
//  cloudcorderAppDelegate.h
//  cloudcorder
//
//  Created by Bennett Kolasinski on 3/10/10.
//  Copyright bennettk 2010. All rights reserved.
//

@class MainViewController;

@interface cloudcorderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

