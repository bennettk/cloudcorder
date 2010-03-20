//
//  cloudcorderAppDelegate.h
//  cloudcorder
//
//  Created by Bennett Kolasinski on 3/10/10.
//  Copyright bennettk 2010. All rights reserved.
//

#import "SCAPI.h"

#define kTestAppConsumerKey		@"qPsngYVOO6osDacwkaZNRA"
#define kTestAppConsumerSecret	@"B6RjYHxxcyWgzWhPZtIPJLM5DOFqrdz03zAxta7rsH4"

#define kCallbackURL	@"cloudcorder://oauth"	//remember that the myapp protocol also is set in the info.plist

@class MainViewController;

@interface cloudcorderAppDelegate : NSObject <UIApplicationDelegate, SCSoundCloudAPIAuthenticationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	
	SCSoundCloudAPIConfiguration *scAPIConfig;
	NSString *oauthVerifier;
	
	UIAlertView *safariAlertView;
	NSURL *authURL;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@property (nonatomic, readonly) SCSoundCloudAPIConfiguration *scAPIConfig;
@property (nonatomic, retain) NSString *oauthVerifier;

@end

