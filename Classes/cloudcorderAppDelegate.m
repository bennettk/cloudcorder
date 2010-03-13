//
//  cloudcorderAppDelegate.m
//  cloudcorder
//
//  Created by Bennett Kolasinski on 3/10/10.
//  Copyright bennettk 2010. All rights reserved.
//

#import "cloudcorderAppDelegate.h"
#import "MainViewController.h"

@implementation cloudcorderAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
