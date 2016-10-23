//
//  MediaListViewController.m
//  Chapter12c
//
//  Created by Jayant Varma on 10/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "MediaListViewController.h"

@interface MediaListViewController ()

@end

@implementation MediaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageManager = [PHImageManager defaultManager];
    
    // Select only Videos (works better on a device as there are no default videos on the simulator)
    [super setTitle:@"Video Browser"];
    self.videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];

    // Select only Images
//    [super setTitle:@"Image Browser"];
//    self.videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    //The Speech Sytnesizer code from the next section in use with a UI
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    NSString *thisSentence = @"This is the Browser and will show you the images or videos on your device in the Photos Album";
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:thisSentence];
    [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    [utterance setRate:0.1];    // You can speed this up with a larger number like 0.3, 0.5, 1.0
    [synthesizer speakUtterance:utterance];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Requires Access to Photos"
                                    message:@"Please allow this app to access your Photos Library from the Settings > Privacy > Photos setting"
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
        [alert addAction:OKButton];
        [[[[UIApplication sharedApplication]keyWindow]rootViewController]presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger count = [self.videos count] ;
    if (!count) {
        count = 0;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    PHAsset *theAsset = [self.videos objectAtIndex:[indexPath row]];
    CGSize theSize = CGSizeMake(150, 150);
    
    [self.imageManager requestImageForAsset:theAsset targetSize:theSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), false, 1);
        //CGContextRef context = UIGraphicsGetCurrentContext();
        [result drawInRect:CGRectMake(0, 0, 100, 100)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cell.accessoryType = theAsset.favorite ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        cell.imageView.image = image;
        NSString *duration = [NSString stringWithFormat:@"%0.1fs", theAsset.duration];
        
        // If you are using iOS 8.1 or lower, this will throw a warning about unsigned long
        // In iOS 8.2+, this works fine
        NSString *details = [NSString stringWithFormat:@"(%d) x (%d) - (%@)", theAsset.pixelWidth, theAsset.pixelHeight, duration];
        cell.textLabel.text = details;
    }];
    
    return cell;
}


// Plays the Video so will not do anything with the Images
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *theAsset = [self.videos objectAtIndex:[indexPath row]];
    if (theAsset.mediaType == PHAssetMediaTypeVideo) {
        [self.imageManager requestPlayerItemForVideo:theAsset options:nil resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
            AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            playerVC.player = player;
            [player play];
            
            [self presentViewController:playerVC animated:YES completion:nil];
        }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
