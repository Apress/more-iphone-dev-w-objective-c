//
//  ViewController.m
//  AudioPlayer
//
//  Created by Jayant Varma on 16/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

AVAudioPlayer *thePlayer;
AVAudioRecorder *recorder;

@implementation ViewController

BOOL isPlaying = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *file = [[NSBundle mainBundle]pathForResource:@"megamix" ofType:@"mp3"];
    NSURL *theURL = [NSURL fileURLWithPath:file];
    thePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:theURL error:nil];

    [thePlayer setRate:2.5f];
    [thePlayer setEnableRate:YES];
    [thePlayer setDelegate:self];
    
    [thePlayer setMeteringEnabled:YES]; // Set this to NO if you do not want metering
    
    //[thePlayer setNumberOfLoops:10]; // Set this to the number of loops you want
    
    
    [thePlayer prepareToPlay];

    // [thePlayer play];
    //[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(playFile:) userInfo:nil repeats:NO];
    
    //If you want to update the data to the UI
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    
    //Prep the device for Playback and recording
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

-(void) update:(id)sender {
    if (isPlaying == YES){
    [thePlayer updateMeters];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *curr = [NSString
                          stringWithFormat:@"Time: %0.2f / %0.2f",
                          thePlayer.currentTime/60.0,
                          thePlayer.duration/60.0];
        self.theTime.text = curr;
        self.PMPO.text = [NSString
                          stringWithFormat:@"%0.2f/%0.2f",
                          [thePlayer peakPowerForChannel:0],
                          [thePlayer peakPowerForChannel:1]];
    });
    } else {
        self.theTime.text = @"";
        self.PMPO.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [recorder deleteRecording];
}

-(IBAction)record:(id)sender {

    AVAudioRecorder *recorder;
    
    NSDictionary *settings = @{AVSampleRateKey:@44100,
                               AVNumberOfChannelsKey:@2,
                               AVEncoderBitRateKey:@16,
                               AVEncoderAudioQualityKey:[NSNumber numberWithLong: AVAudioQualityHigh]
                               };
    
    NSURL *docsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
    NSURL *theFile = [NSURL URLWithString:@"recording.wav" relativeToURL:docsDir];
    recorder = [[AVAudioRecorder alloc] initWithURL:theFile settings:settings error:nil];
    [recorder recordForDuration:10.0];
    
    //[recorder deleteRecording]; // to remove the recording
}


- (IBAction)play:(id)sender {
    if (isPlaying == NO) {
        [thePlayer setRate:1];
        [thePlayer play];
        [self.theButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [thePlayer pause];
        [self.theButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    
    isPlaying = !isPlaying;
}


@end
