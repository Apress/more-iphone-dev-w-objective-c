//
//  ViewController.m
//  Camera_1
//
//  Created by Jayant Varma on 16/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *theButton;
@property (weak, nonatomic) IBOutlet UIButton *picButton;
@property (weak, nonatomic) IBOutlet UIImageView *theImage;

@end

AVCaptureDevice *theFrontCamera;
AVCaptureDevice *theBackCamera;
NSInteger theSource = 0;

AVCaptureStillImageOutput *theOutputSource;

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *allCameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
//    for (AVCaptureDevice *camera in allCameras) {
//        if ([camera position] == AVCaptureDevicePositionBack){
//            self.theCamera = camera;
//            break;
//        }
//    }

        for (AVCaptureDevice *camera in allCameras) {
            if ([camera position] == AVCaptureDevicePositionBack) {
                theBackCamera = camera;
            } else if ([camera position] == AVCaptureDevicePositionFront) {
                theFrontCamera = camera;
            }
        }

    self.theCamera = theBackCamera;
    
    
    self.session = [[AVCaptureSession alloc]init];
    self.theInputSource = [AVCaptureDeviceInput deviceInputWithDevice:self.theCamera error:nil];
    
    if ([self.session canAddInput:self.theInputSource]) {
        [self.session addInput:self.theInputSource];
    }

    self.thePreview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [self.thePreview setFrame:self.view.bounds];
    [self.thePreview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer addSublayer:self.thePreview];
    
    theOutputSource = [[AVCaptureStillImageOutput alloc]init];
    [self.session addOutput:theOutputSource];
    
    [self.session startRunning];
    
    [self.theButton setTitle:@"Switch Cameras" forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.theButton];
    [self.view bringSubviewToFront:self.picButton];
    
    //[self.view bringSubviewToFront:self.theImage];
    
    
/*
    NSArray *devices = AVCaptureDevice.devices;
    AVCaptureDevice *device;
    for (device in devices) {
        if (device.hasTorch) {
            // Code to work with the Flash
        }
    }
    
    if (device.torchAvailable){
        //
    }
    
    device.torchMode = AVCaptureTorchModeOn;
    
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    [session addInput:input];
    [session startRunning];
    
    UIView *theView;
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayer setFrame:theView.frame];
    [theView.layer addSublayer:previewLayer];
    
    if ([device hasMediaType:AVMediaTypeVideo] && [device supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080] && [device position] == AVCaptureDevicePositionBack)  {
        // This device has the capabilites you require
    }
    
    [device lockForConfiguration:nil];
    //Change the settings here
    [device unlockForConfiguration];
    
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        CGPoint autoFocusPoint = CGPointMake(0.5, 0.5);
        [device lockForConfiguration:nil];
        [device setFocusPointOfInterest:autoFocusPoint];
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [device unlockForConfiguration];
    }

    AVCapture
*/
    
}

- (IBAction)takePicture:(id)sender {
//    AVCaptureConnection *theConnection = [theOutputSource connectionWithMediaType:AVMediaTypeVideo];
//    
//    [theOutputSource captureStillImageAsynchronouslyFromConnection:theConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        UIImage *theImage = [UIImage imageWithData:imageData];
//        [_theImage setImage:theImage];
//    }];


    AVCaptureConnection *theConnection = [theOutputSource connectionWithMediaType:AVMediaTypeVideo];
    
    [theOutputSource captureStillImageAsynchronouslyFromConnection:theConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *theImage = [UIImage imageWithData:imageData];
        
        UIGraphicsBeginImageContext([theImage size]);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [theImage drawAtPoint:CGPointMake(0, 0)];
        UIColor *theColor = [[UIColor alloc]initWithWhite:0.5f alpha:0.5f];
        CGContextSetFillColorWithColor(context, [theColor CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, [theImage size].width, 20));
        
        UIFont *font = [UIFont systemFontOfSize:18];
        NSDictionary *attr = @{
                    NSForegroundColorAttributeName:[UIColor whiteColor],
                    NSFontAttributeName: font
                    };
        NSString *message = [NSString stringWithFormat:@"Taken on : %@", [[NSDate date]description]];
        [message drawAtPoint:CGPointMake(0, 0) withAttributes:attr];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        //[_theImage setImage:theImage];
        [_theImage setImage:image];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);        
    }];

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if ([error code] != 0) {
        NSLog(@"Error : %@", [error localizedDescription]);
    } else {
        NSLog(@"Saved Image");
    }
}

- (IBAction)switchCamera:(id)sender {
    theSource = 1 - theSource;
    if (theSource == 1) {
        self.theCamera = theFrontCamera;
    } else {
        self.theCamera = theBackCamera;
    }
    
    [self.session beginConfiguration];
    
    [self.session removeInput:self.theInputSource];
    
    self.theInputSource = [AVCaptureDeviceInput deviceInputWithDevice:self.theCamera error:nil];
    [self.session addInput:self.theInputSource];
    
    [self.session commitConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
