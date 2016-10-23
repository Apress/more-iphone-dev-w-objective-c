//
//  MediaListViewController.h
//  Chapter12c
//
//  Created by Jayant Varma on 10/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
@import AVKit;
@import Photos;

@interface MediaListViewController : UITableViewController <AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) PHImageManager *imageManager;
@property (nonatomic, strong) PHFetchResult *videos;
@end
