//
//  ViewController.m
//  Chapter_12
//
//  Created by Jayant Varma on 11/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize player;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPausePressed:)];
    [self.pause setStyle:UIBarButtonItemStylePlain];
    
    if (self.player == nil) {
        self.player = [[MPMusicPlayerController alloc]init];
    }
    
//    MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
//    mpc.delegate = self;
//    [mpc setAllowsPickingMultipleItems:NO];
//    mpc.prompt = @"Select items to play";
//    [self presentViewController:mpc animated:YES completion:nil];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:self.player];
    [self.player beginGeneratingPlaybackNotifications];
}

-(void) playPausePressed:(id)sender{

    MPMusicPlaybackState playbackState = [self.player playbackState];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    if(playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        [self.player play];
        [items replaceObjectAtIndex:2 withObject:self.pause];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.player pause];
        [items replaceObjectAtIndex:2 withObject:self.play];
    }
    
    [self.toolbar setItems:items animated:NO];
}

-(void)rewindPressed:(id)sender{
    if ([self.player indexOfNowPlayingItem] == 0){
        [self.player skipToBeginning];
    } else {
        [self.player endSeeking];
        [self.player skipToPreviousItem];
    }
}

-(void)fastForwardPressed:(id)sender{
    NSUInteger nowPlayingIndex = [self.player indexOfNowPlayingItem];
    [self.player endSeeking];
    [self.player skipToNextItem];
    if ([self.player nowPlayingItem] == nil){
        if ([self.collection count] > nowPlayingIndex + 1) {
            // added more songs while playing
            [self.player setQueueWithItemCollection:self.collection];
            MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex+1];
            [self.player setNowPlayingItem:item];
            [self.player play];
        } else {
            // No more songs
            [self.player stop];
            NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
            [items replaceObjectAtIndex:2 withObject:self.play];
            [self.toolbar setItems:items];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object:self.player];
}

#pragma mark - Media Picker Delegates

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)theCollection {
    [self dismissViewControllerAnimated:YES completion:nil];

    if (self.collection == nil){
        self.collection = theCollection;
        [self.player setQueueWithItemCollection:self.collection];
        MPMediaItem *item = [[self.collection items] objectAtIndex:0];
        [self.player setNowPlayingItem:item];
        [self playPausePressed:self];
    } else {
        NSArray *oldItems = [self.collection items];
        NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[theCollection items]];
        self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
    }
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification Methods

-(void) nowPlayingItemChanged:(NSNotification *)notification{
    MPMediaItem *currentItem = [self.player nowPlayingItem];
    if(currentItem == nil) {
        [self.imageView setImage:nil];
        [self.imageView setHidden:YES];
        [self.status setText:NSLocalizedString(@"Tap + to Add more music", @"Add more music")];
        [self.artist setText:@""];
        [self.song setText:@""];
    } else {
        MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork){
            UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
            [self.imageView setImage:artworkImage];
            [self.imageView setHidden:NO];
        } else {
            [self.imageView setImage:nil];
            [self.imageView setHidden:YES];
        }
        
        //Display the artist and song name
        [self.status setText:NSLocalizedString(@"Now Playing", @"Now Playing")];
        [self.artist setText:[currentItem valueForProperty:MPMediaItemPropertyArtist]];
        [self.song setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    }
}


- (IBAction)addPressed:(id)sender {
    MPMediaType mediaType = MPMediaTypeMusic;
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:mediaType];
    picker.delegate = self;
    [picker setAllowsPickingMultipleItems:YES];
    picker.prompt = NSLocalizedString(@"Select items to play", @"Select items to play");
    [self presentViewController:picker animated:YES completion:nil];
}
@end
