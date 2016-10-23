//
//  ViewController.h
//  MapMe
//
//  Created by Jayant Varma on 17/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@import MapKit;

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)findMe:(id)sender;

@end

CLLocationManager *manager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
