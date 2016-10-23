//
//  ViewController.h
//  Camera_1
//
//  Created by Jayant Varma on 16/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface ViewController : UIViewController

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *theCamera;
@property (strong, nonatomic) AVCaptureDeviceInput *theInputSource;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *thePreview;

@end

