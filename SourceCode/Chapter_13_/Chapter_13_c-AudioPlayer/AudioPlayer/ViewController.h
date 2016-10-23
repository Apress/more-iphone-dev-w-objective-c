//
//  ViewController.h
//  AudioPlayer
//
//  Created by Jayant Varma on 16/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface ViewController : UIViewController<AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *theTime;
@property (weak, nonatomic) IBOutlet UILabel *PMPO;
@property (weak, nonatomic) IBOutlet UIButton *theButton;


- (IBAction)play:(id)sender;

- (IBAction)record:(id)sender;

@end

