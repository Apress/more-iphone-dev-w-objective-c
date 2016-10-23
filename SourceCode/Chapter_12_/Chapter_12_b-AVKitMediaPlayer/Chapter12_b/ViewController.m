//
//  ViewController.m
//  Chapter12_b
//
//  Created by Jayant Varma on 10/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ViewController.h"
#import "PlayerViewController.h"
@import Photos;

@interface ViewController ()
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    Load a File from the Device
//--------------------------------
//    NSString *thePath = [[NSBundle mainBundle]pathForResource:@"stackofCards" ofType:@"mp4"];
//    AVPlayer *player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:thePath]];
//    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
//    playerViewController.player = player;
//    
//    [self addChildViewController:playerViewController];
//    [self.view addSubview:playerViewController.view];
//    playerViewController.view.frame = self.view.frame;
//    [player play];
//
    
    
    // Load a Video from your Photos Album
//    PHFetchResult *videoAssets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
//    
//    PHAsset *videoAsset = [videoAssets firstObject];
//    //PHAsset *videoAsset = [videoAssets objectAtIndex:0];
//    
//    PHImageManager *imageManager = [PHImageManager defaultManager];
//    [imageManager requestPlayerItemForVideo:videoAsset options:nil resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
//        self.player = [AVPlayer playerWithPlayerItem:playerItem];
//        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
//        playerViewController.player = self.player;
//        
//        [self addChildViewController:playerViewController];
//        [self.view addSubview:playerViewController.view];
//        playerViewController.view.frame = self.view.frame;
//        [self.player play];
//    }];
//    
//    [imageManager requestImageForAsset:videoAsset
//                            targetSize:CGSizeMake(150, 150)
//                           contentMode:PHImageContentModeAspectFill
//                               options:nil
//                         resultHandler:^(UIImage *result, NSDictionary *info) {
//        // This is an UIImage, use it as you want
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//// Play the Apple Watch video from an online source
//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    PlayerViewController *videoPlayer = [segue destinationViewController];
//    
//    NSString *AppleWatch = @"http://images.apple.com/media/us/watch/2014/videos/e71af271_d18c_4d78_918d_d008fc4d702d/tour/reveal/watch-reveal-cc-us-20140909_r848-9dwc.mov";
//    NSURL *theURL = [[NSURL alloc]initWithString:AppleWatch];
//    videoPlayer.player = [[AVPlayer alloc]initWithURL:theURL];
//    
//    [videoPlayer.player play];
//}


// Play a local video and disable the Playback Controls
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PlayerViewController *videoPlayer = [segue destinationViewController];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"stackofCards" ofType:@"mp4"];
    if (filePath){
        NSURL *theURL = [NSURL fileURLWithPath:filePath];
        videoPlayer.player = [[AVPlayer alloc]initWithURL:theURL];
        
        [videoPlayer setShowsPlaybackControls:NO];
        [videoPlayer.player play];
    }
}



@end
