//
//  ViewController.h
//  Chapter_12
//
//  Created by Jayant Varma on 11/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate> //, MPPlayableContentDataSource>

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *song;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


- (IBAction)rewindPressed:(id)sender;
- (IBAction)playPausePressed:(id)sender;
- (IBAction)fastForwardPressed:(id)sender;
- (IBAction)addPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *play;
@property (strong, nonatomic) UIBarButtonItem *pause;


@property (strong, nonatomic) MPMusicPlayerController *player;
@property (strong, nonatomic) MPMediaItemCollection *collection;

-(void)nowPlayingItemChanged:(NSNotification *) notification;
@end

