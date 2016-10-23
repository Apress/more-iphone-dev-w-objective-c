//
//  ViewController.m
//  Camera_2
//
//  Created by Jayant Varma on 16/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ViewController.h"

@import MapKit;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == AVCaptureDevicePositionBack){
            theCamera = camera;
            break;
        }
    }
    
    session = [[AVCaptureSession alloc]init];
    if (theCamera != nil){
        theInputSource = [AVCaptureDeviceInput deviceInputWithDevice:theCamera error:nil];
        if ([session canAddInput:theInputSource])
            [session addInput:theInputSource];
        
        theOutputSource = [[AVCaptureMetadataOutput alloc]init];
        if ([session canAddOutput:theOutputSource])
            [session addOutput:theOutputSource];
        
        NSArray *options = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
        [theOutputSource setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [theOutputSource setMetadataObjectTypes:options];
        
        
        thePreview = [AVCaptureVideoPreviewLayer layerWithSession:session];
        [[self.view layer] addSublayer:thePreview];
        [thePreview setFrame:[self.view bounds]];
        [thePreview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
    
    [session startRunning];
}

#pragma mark AVCaptureMetadataObjectsDelegate Function

-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    for (AVMetadataMachineReadableCodeObject *theItem in metadataObjects) {
        NSLog(@"We read %@ from a barcode of type %@", [theItem stringValue], [theItem type]);
        
        [self showAlert:[NSString stringWithFormat:@"We got %@", [theItem stringValue]] Message:[NSString stringWithFormat:@"Barcode type %@", [theItem type]] Button:@"OK" handler:nil];
    }
}

-(void)showAlert:(NSString *)theTitle Message:(NSString *)theMessage Button:(NSString *)theButton handler:(void (^)(UIAlertAction *action)) completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:theTitle message:theMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:theButton style:UIAlertActionStyleDefault handler: completionHandler];
    [alert addAction:OKButton];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void) dummy {

    NSString *theText = @"This is the Sample Text";
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [theText dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
 
    CIImage *outputImage = filter.outputImage;
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationUp];
    
    CGFloat scaleRef = [self.view bounds].size.width  / [image size].width;
    CGFloat width = [image size].width * scaleRef;
    CGFloat height = [image size].height * scaleRef;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    //UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Now assign this image in temp to the imageView instead
    
    
    UIAlertController *alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Power Error",
                                                                            @"Power Error")
                                                  message:NSLocalizedString(@"Error trying to show Power",
                                                                            @"Error trying to show Power")
                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKButton = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Aw Nuts",
                                                                   @"Aw Nuts")
                                           style:UIAlertActionStyleDefault
                                         handler:nil];
    [alert addAction:OKButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void) dummdumm {
/*
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    
    _mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coords = _mapView.userLocation.location.coordinate;
    
    float latitude;
    float longitude;
    
    double longitudeMiles = ((M_PI / 180.0) * 3963.1676 * cos(latitude));
    
    double longitudeKilometers = ((M_PI / 180.0) * 6378.1 * cos(latitude));
    
    MKCoordinateRegion viewRegion;
    MKCoordinateRegion adjustRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustRegion animated:YES];
    
    
    CLLocationDegrees leftDegrees = _mapView.region.center.longitude - (_mapView.region.span.longitudeDelta / 2.0);
    CLLocationDegrees rightDegrees = _mapView.region.center.longitude + (_mapView.region.span.longitudeDelta / 2.0);
    CLLocationDegrees bottomDegrees = _mapView.region.center.latitude - (_mapView.region.span.latitudeDelta / 2.0);
    CLLocationDegrees topDegrees = _mapView.region.center.latitude + (_mapView.region.span.latitudeDelta / 2.0);
    
    if (leftDegrees > rightDegrees) { // Int'l Date Line in View
        leftDegrees = -180.0 - leftDegrees;
        if (coords.longitude > 0) // coords to West of Date Line
            coords.longitude = -180 - coords.longitude;
    }
    
    if (leftDegrees <= coords.longitude && coords.longitude <= rightDegrees && bottomDegrees <= coords.latitude && coords.latitude <= topDegrees) {
        // Coordinates are being displayed
    }
    
    MKAnnotationView *annotation;

    [_mapView addAnnotation:annotation];
    
    [_mapView addAnnotations:[NSArray arrayWithObjects:annotation1, annotation2, nil]];
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        // process the location or errors
        ...
    }]
    
*/
    
}

/*
-(MKAnnotationView *) mapView:(MKMapView *) theMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *placemarkIdentifier = @"my annotation identifier";
    if ([annotation isKindOfClass:[MyAnnotation class]]){
        MKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
            annotationView.image = [UIImage imageNamed:@"shocked_cat.png"];
        } else
            annotationView.annotation = annotation;

        return annotationView;
    }
    return nil;
}
*/


-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
