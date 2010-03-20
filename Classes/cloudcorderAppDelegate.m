//
//  cloudcorderAppDelegate.m
//  cloudcorder
//
//  Created by Bennett Kolasinski on 3/10/10.
//  Copyright bennettk 2010. All rights reserved.
//

#import "cloudcorderAppDelegate.h"
#import "MainViewController.h"

#import "NSURL+SoundCloudAPI.h"

@implementation cloudcorderAppDelegate


@synthesize window;
@synthesize mainViewController;
@synthesize scAPIConfig;
@synthesize oauthVerifier;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
	NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];	
	if(launchURL && [[launchURL absoluteString] hasPrefix:kCallbackURL]) {
		self.oauthVerifier = [launchURL valueForQueryParameterKey:@"oauth_verifier"];
	}
	
	// global accessible api configuration through application delegate
	// set appDelegate as auth delegate on every api instantiation
	// make shure to register the myapp url scheme to your app :)
	scAPIConfig = [[SCSoundCloudAPIConfiguration alloc] initForProductionWithConsumerKey:kTestAppConsumerKey
																		  consumerSecret:kTestAppConsumerSecret
																			 callbackURL:[NSURL URLWithString:kCallbackURL]];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
{
    if (!url
		|| [[url absoluteString] hasPrefix:kCallbackURL]) {
		return NO;
	}
	
	NSString *verifier = nil;
	if(url
	   && [[url absoluteString] hasPrefix:kCallbackURL]) {
		verifier = [url valueForQueryParameterKey:@"oauth_verifier"];
	}
	SCSoundCloudAPI *scAPI = [[SCSoundCloudAPI alloc] initWithAuthenticationDelegate:self tokenVerifier:verifier];
	[scAPI authorizeRequestToken]; 
	[scAPI release];
	return YES;
}

#pragma mark SoundCloudAPI Authorization Delegate

- (SCSoundCloudAPIConfiguration *)configurationForSoundCloudAPI:(SCSoundCloudAPI *)scAPI;
{
	return scAPIConfig;
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)scAPI requestedAuthenticationWithURL:(NSURL *)inAuthURL;
{
	authURL = [inAuthURL retain];
	safariAlertView = [[UIAlertView alloc] initWithTitle:@"OAuth Authentication"
												 message:@"The application will launch the SoundCloud website in Safari to allow you to authorize it."
												delegate:self
									   cancelButtonTitle:@"Launch Safari"
									   otherButtonTitles:nil];
	[safariAlertView show];
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)_scAPI didChangeAuthenticationStatus:(SCAuthenticationStatus)status;
{
	if (status == SCAuthenticationStatusAuthenticated) {
		NSLog(@"we're in!");
		// authenticated
//		mainViewController.postButton.enabled = YES;
//		mainViewController.trackNameField.enabled = YES;
		// not the most elegant way to enable/disable the ui
		// but this is up to you (the developer of apps) to prove your cocoa skills :)
	} else {
//		viewController.postButton.enabled = NO;
//		viewController.trackNameField.enabled = NO;
	}
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)_scAPI didEncounterError:(NSError *)error;
{
	if ([[error domain] isEqualToString:SCAPIErrorDomain]) {
		if ([error code] == SCAPIErrorHttpResponseError) {
			// inform the user and offer him to retry.
			NSError *httpError = [[error userInfo] objectForKey:SCAPIHttpResponseErrorStatusKey];
			if ([httpError code] == NSURLErrorNotConnectedToInternet) {
				NSLog(@"no internet connection");
				//[mainViewController.postButton setTitle:@"No internet connection" forState:UIControlStateDisabled];
				//[mainViewController.postButton setEnabled:NO];
			} else {
				NSLog(@"error: %@", [httpError localizedDescription]);
			}
		} else if ([error code] == SCAPIErrorNotAuthenticted) {
			[_scAPI requestAuthentication];
		}
	}
}

#pragma mark -

- (void)modalViewCancel:(UIAlertView *)alertView
{
    [alertView release];
}

- (void)modalView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != -1 && authURL) {
       	[[UIApplication sharedApplication] openURL:authURL];
    }
    [alertView release];
}

@end
