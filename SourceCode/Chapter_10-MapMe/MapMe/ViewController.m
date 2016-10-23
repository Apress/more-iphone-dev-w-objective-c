//
//  ViewController.m
//  MapMe
//
//  Created by Jayant Varma on 17/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ViewController.h"

#import "MapLocation.h"
//@import MapKit;

@interface ViewController ()
-(void) openCallout:(id<MKAnnotation>)annotation;
-(void)reverseGeocode:(CLLocation *)location;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.mapType = MKMapTypeHybrid;
    
    self.mapView.showsUserLocation = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method

- (IBAction)findMe:(id)sender {
    if (manager == nil)
        manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [manager requestWhenInUseAuthorization];
    
    [manager startUpdatingLocation];
    
    self.progressBar.hidden = NO;
    self.progressBar.progress = 0.0;
    self.progressLabel.text = NSLocalizedString(@"Determining Current Location", @"Determining Current Location");
    self.button.hidden = YES;
}

#pragma mark - (Private) Instance Methods

-(void) openCallout:(id<MKAnnotation>)annotation {
    self.progressBar.progress = 1.0;
    self.progressLabel.text = NSLocalizedString(@"Showing Annotation", @"Showing Annotation");
    [self.mapView selectAnnotation:annotation animated:YES];
    
    self.button.hidden = YES;
    self.progressBar.hidden = YES;
    self.progressLabel.text = @"";
}


-(void)reverseGeocode:(CLLocation *)location{
    if(!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(nil != error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error translating coordinates into location", @"Error translating coordinates into location") message:NSLocalizedString(@"Geocoder did not recognize coordinates", @"Geocoder did not recognize coordinates") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:OKAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else if ([placemarks count] > 0) {
            placemark = [placemarks objectAtIndex:0];
            
            self.progressBar.progress = 0.5;
            self.progressLabel.text = NSLocalizedString(@"Location Determined", @"Location Determined");

            MapLocation *annotation = [[MapLocation alloc] init];
            annotation.street = placemark.thoroughfare;
            annotation.city = placemark.locality;
            annotation.state = placemark.administrativeArea;
            annotation.zip = placemark.postalCode;
            annotation.coordinate = location.coordinate;
            
            [self.mapView addAnnotation:annotation];
        }
    }];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //CLLocation *oldLocation = [locations firstObject];
    CLLocation *newLocation = [locations lastObject];
    if([newLocation.timestamp timeIntervalSince1970] < [NSDate timeIntervalSinceReferenceDate] - 60)
        return;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    manager.delegate = nil;
    [manager stopUpdatingLocation];
    
    self.progressBar.progress = 0.25;
    self.progressLabel.text = NSLocalizedString(@"Reverse Geocoding Location", @"Reverse Geocoding Location");
    [self reverseGeocode:newLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *errorType = (error.code == kCLErrorDenied)
                        ? NSLocalizedString(@"Access Denied", @"Access Denied")
                        : NSLocalizedString(@"Unknown Error", @"Unknown Error");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                NSLocalizedString(@"Error Getting Location", @"Error Getting Location")
                                message:errorType
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:OKButton];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - MKMapViewDelegate Methods

-(MKAnnotationView *) mapView:(MKMapView *) aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *placemarkIdentifier = @"Map Location Identifier";
    if ([annotation isKindOfClass:[MapLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier: placemarkIdentifier];
        if (nil == annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
        } else
            annotationView.annotation = annotation;
        
        annotationView.enabled = YES;
        annotationView.animatesDrop = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
        [self performSelector:@selector(openCallout:) withObject:annotation afterDelay:0.5];
        
        self.progressBar.progress = 0.75;
        self.progressLabel.text = NSLocalizedString(@"Creating Annotation", @"Creating Annotation");
        
        return annotationView;
    }
    return nil;
}


-(void) mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                NSLocalizedString(@"Error loading map", @"Error loading map")
                                                                   message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKButton = [UIAlertAction
                               actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * alert) {
                                           self.progressLabel.text = @"";
                                           self.progressBar.hidden = YES;
                                           self.button.hidden = NO;
                                       }];
    [alert addAction:OKButton];
    [self presentViewController:alert animated:YES completion:nil];

}

@end
