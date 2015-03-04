//
//  MapaViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "MapaViewController.h"

@interface MapaViewController () {
        MKCoordinateRegion region;
        CLPlacemark *thePlacemark;
        MKRoute *routeDetails;
}

@property CLLocationManager *locationManager;

@end

@implementation MapaViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    CLLocationManager *locationManager;
    //Alocar memória para o locationManager
    self.locationManager = [[CLLocationManager alloc]init];
    
    //Mostrar ao locationManager o quão exata deve ser a localização encontrada
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //Determinar que a propriedade delegate do locationManager seja a instância da ViewController
    [self.locationManager setDelegate:self];
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    NSLog(@"%@", [locations lastObject]);
    //Encontrar as coordenadas de localização atual
    CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
    
    //Determinar região com as coordenadas de localização atual e os limites N/S e L/O no zoom em metros
    region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [_mapView setRegion:region animated:YES];
    
}


//- (IBAction)routeButtonPressed:(UIBarButtonItem *)sender {
//    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
//    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:thePlacemark];
//    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
//    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
//    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
//    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
//    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//        if (error) {
//            NSLog(@"Error %@", error.description);
//        } else {
//            
//            routeDetails = response.routes.lastObject;
//            [self.mapView addOverlay:routeDetails.polyline];
//            self.destinationLabel.text = [placemark.addressDictionary objectForKey:@"Street"];
//            self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f Kilometros", routeDetails.distance/1000];
//            self.transportLabel.text = [NSString stringWithFormat:@"%u" ,routeDetails.transportType];
//            self.allSteps = @"";
//            for (int i = 0; i < routeDetails.steps.count; i++) {
//                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
//                NSString *newStep = step.instructions;
//                self.allSteps = [self.allSteps stringByAppendingString:newStep];
//                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
//                self.steps.text = self.allSteps;
//            }
//        }
//    }];
//}
//
//
//- (IBAction)clearRoute:(UIBarButtonItem *)sender {
//    self.destinationLabel.text = nil;
//    self.distanceLabel.text = nil;
//    self.transportLabel.text = nil;
//    self.steps.text = nil;
//    [self.mapView removeOverlay:routeDetails.polyline];
//}

- (IBAction)addressSearch:(UITextField *)sender {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:sender.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            thePlacemark = [placemarks lastObject];
            float spanX = 1.00725;
            float spanY = 1.00725;
            MKCoordinateRegion region;
            region.center.latitude = thePlacemark.location.coordinate.latitude;
            region.center.longitude = thePlacemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
            [self addAnnotation:thePlacemark];
        }
    }];
}

- (void)addAnnotation:(CLPlacemark *)placemark {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    point.title = [placemark.addressDictionary objectForKey:@"Street"];
    point.subtitle = [placemark.addressDictionary objectForKey:@"City"];
    [self.mapView addAnnotation:point];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}



- (IBAction)mostraRota:(id)sender {
    
}


/*
 * Mostrar localização atual
 *
 */
- (IBAction)localizacaoAtual:(id)sender {
    //Dizer ao locationManager para começar a procurar pela localização imediatamente
    [self.locationManager startUpdatingLocation];
    [_mapView setRegion:region animated:YES];
    
 }

@end
