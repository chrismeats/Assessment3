//
//  MMMapViewController.m
//  Assessment3_ObjectiveC
//
//  Created by Kevin McQuown on 8/5/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MMMapViewController.h"
#import <MapKit/MapKit.h>

@interface MMMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic, strong) MKPointAnnotation *currentLocationAnnotation;

@end

@implementation MMMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CLLocationCoordinate2D coord;
    coord.latitude = [self.station.divvyLocation[@"latitude"] floatValue];
    coord.longitude = [self.station.divvyLocation[@"longitude"] floatValue];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coord;

    annotation.title = self.station.divvyLocation[@"stationName"];
    
    self.myMapView.showsUserLocation = YES;
    [self.myMapView addAnnotation:annotation];

    CLLocationCoordinate2D centerCoordinate = annotation.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.05;
    coordinateSpan.longitudeDelta = 0.05;
    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.myMapView setRegion:region animated:YES];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    if (annotation != self.myMapView.userLocation) {
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.image = [UIImage imageNamed:@"divvy"];
    } else {
        pin.image = [UIImage imageNamed:@"currentLocation"];
    }
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

    MKPlacemark *mkDest = [[MKPlacemark alloc]
                           initWithCoordinate:view.annotation.coordinate
                           addressDictionary:nil];

    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:mkDest];

    MKDirectionsRequest *request = [MKDirectionsRequest new];

    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = mapItem;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKRoute *route = response.routes.firstObject;
        int stepNumber = 1;
        NSMutableString *directionsString = [NSMutableString string];
        for (MKRouteStep *step in route.steps) {
            [directionsString appendFormat:@"%d: %@\n", stepNumber, step.instructions];
            stepNumber++;
        }

        UIAlertView *alertView = [UIAlertView new];
        alertView.message = directionsString;
        [alertView addButtonWithTitle:@"Thanks!"];
        [alertView show];

    }];


}


@end
