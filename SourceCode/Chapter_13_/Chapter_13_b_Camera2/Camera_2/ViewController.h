//
//  ViewController.h
//  Camera_2
//
//  Created by Jayant Varma on 16/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@end

AVCaptureSession *session;
AVCaptureDevice *theCamera;
AVCaptureDeviceInput *theInputSource;
AVCaptureMetadataOutput *theOutputSource;
AVCaptureVideoPreviewLayer *thePreview;


