//
//  MainViewController.h
//  cloudcorder
//
//  Created by Bennett Kolasinski on 3/10/10.
//  Copyright bennettk 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, AVAudioPlayerDelegate> {
	IBOutlet UIButton *recordButton;
	IBOutlet UIButton *playButton;
	
	AVAudioRecorder *recorder;
	AVAudioPlayer *player;
	NSURL *recordFile;
}

@property (nonatomic, retain) UIButton *recordButton;
@property (nonatomic, retain) UIButton *playButton;

- (IBAction)showInfo;
- (IBAction)recordPressed;
- (IBAction)playPressed;

@end
