//
//  MainViewController.m
//  cloudcorder
//
//  Created by Bennett Kolasinski on 3/10/10.
//  Copyright bennettk 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"


@implementation MainViewController

@synthesize recordButton, playButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}



 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 [playButton setAlpha:0.6];
	 [playButton setEnabled:NO]; // don't enable play until a recording's been made...
	 
	 
	 // set up our recorder. 
	 recordFile = [[NSURL fileURLWithPath:
					[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"recordFile.caf"]] retain];
	 
	 // NSLog(@"recording to %@", [recordFile path]);
	 
	 NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							   [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							   [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							   [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							   [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							   nil];
	 
	 NSError *error;
	 
	 recorder = [[AVAudioRecorder alloc] initWithURL:recordFile settings:settings error:&error];
	 player = [AVAudioPlayer alloc]; // we'll init with the appropriate URL when the recording's been made.
	 if (recorder) {
		 [recorder prepareToRecord];
	 } else {
		 NSLog(@"%@" ,[error localizedDescription]);
	 }
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

-(IBAction)recordPressed {

	if ([recorder isRecording]) {
		NSError *error;
		[recorder stop];
		//[player initWithContentsOfURL:recordFile error:error];
		[recordButton setTitle:@"record" forState:UIControlStateNormal];
		[player initWithContentsOfURL:recordFile error:&error];
		[player setDelegate:self];
		[playButton setEnabled:YES];
		[playButton setAlpha:1.0];

	} else {
		[recorder record];
		[recordButton setTitle:@"stop" forState:UIControlStateNormal];
	}
	
	NSLog(@"recordPressed.");
}

-(IBAction)playPressed {
	
	if ([player isPlaying]) {
		[player stop];
		[playButton setTitle:@"play" forState:UIControlStateNormal];
	} else {
		[player setCurrentTime:0.0];
		[player play];
		[playButton setTitle:@"stop" forState:UIControlStateNormal];
	}
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog(@"player finished.");
	[playButton setTitle:@"play" forState:UIControlStateNormal];	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
	[recorder release];
	[player release];
	[recordFile release];
    [super dealloc];
}


@end
