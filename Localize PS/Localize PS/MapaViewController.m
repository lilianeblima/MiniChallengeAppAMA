//
//  MapaViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "MapaViewController.h"\


@implementation MapaViewController

-(void)viewDidLoad{
    
    placesLocated = NO;
    searching = NO;
    [self.blurViewOutlet setHidden:YES];
    
    [self.mapView setDelegate:self];
    
    //Pega instancia
    _locationManager = [[CLLocationManager alloc] init];
    
    
    //Define precisão do GPS
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    
    //Define que o delegate sera esta clase
    [_locationManager setDelegate: self];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //Começa monitorar localização
    [_locationManager startUpdatingLocation];
    
    [_atualizarPS setHidden:YES];     // ocultar voltarNav
    
    //Instanciar o MKPointAnnotation
    //_pointMarker = [[MKPointAnnotation alloc] init];
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)findDirectionsFrom:(MKMapItem *) source to: (MKMapItem *) destination {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = source;
    
    request.transportType = MKDirectionsTransportTypeWalking;
    
    request.destination = destination;
    
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         //stop loading animation here
         
         if (error) {
             NSLog(@"Error is %@",error);
         } else {
             //do something about the response, like draw it on map
             MKRoute *route = [response.routes firstObject];
             [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
         }
     }];
    
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static MapaViewController *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D location = [ [locations lastObject] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 800, 800);
    
    if (!searching) {
        searching = YES;
        [self searchLocations:region];
        searching = NO;
    }
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor blueColor];
    return polylineRender;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_locationManager stopUpdatingLocation];
    [_atualizarPS setHidden:NO];     // mostrar voltarNav
}

- (IBAction)atualizarPS:(id)sender {
    [_locationManager startUpdatingLocation];
    [_atualizarPS setHidden:YES];
}

- (void)searchLocations: (MKCoordinateRegion)region {
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    [_mapView removeAnnotations:[_mapView annotations]];
    
    for (NSString *query in _searchQuery){
        
        if (![query isEqual: @""]) {
            
            // Create the search request
            MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init];
            localSearchRequest.region = region;
            localSearchRequest.naturalLanguageQuery = query;
            
            NSLog(@"Perform the search request...");
            MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest: localSearchRequest];
            [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
                NSLog(@"Pontos localizados...");
                if (error){
                    NSLog(@"localSearch startWithCompletionHandlerFailed!  Error: %@", error);
                    return;
                } else {
                    NSMutableArray *places = [NSMutableArray array];
                    
                    CLLocation *loc = self.locationManager.location;
                    
                    for(MKMapItem *mapItem in response.mapItems){           // Show pins, pix, w/e...
                        
                        CLLocation *mapItemLocation = mapItem.placemark.location;
                        CLLocationDistance distancia = [mapItemLocation distanceFromLocation:loc];
                        
                        Place *lugar = [[Place alloc] initWithPlacemark: mapItem.placemark];
                        [lugar setDistancia:(double) distancia];
                        
                        [places addObject: lugar];                          //Inserindo na array places
                    }
                    
                    //Adicionar ordenacao
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distancia" ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
                    NSArray *sortedArray = [places sortedArrayUsingDescriptors: sortDescriptors];
                    
                    for (Place *p in sortedArray){       //Cria array de annotations a partir da "places" ordenada
                        
                        MKPlacemark *pm = [p placemark];
                        
                        NSString *strDistancia = [NSString stringWithFormat: @"%.1f km", (p.distancia/1000)];
                        
                        PointMarker *annot = [[PointMarker alloc] initWithCoordinate:pm.coordinate title:pm.name Subtitle:strDistancia];
                        // [annot setCoordinate:pm.coordinate];
                        //[annot setTitle: [NSString stringWithFormat:@"%@ - %.0fm de distância",pm.name,p.distancia]];
                        //                    [annot setTitle:pm.name];
                        //
                        //                    [annot setSubtitle:strDistancia];
                        //
                        //
                        [annotations addObject: annot];
                        [_mapView addAnnotation:annot];
                        
                        NSLog(@"Name for result: = %@, à %.2fm de distância.", pm.name, p.distancia);
                        
                    }
                }
            }];
            
        }
    }
    
    
    //[_mapView showAnnotations: annotations animated:YES];
    
    
    [_mapView setRegion:region animated:YES];
    
    placesLocated = YES;
}

- (IBAction)rotaBotao:(id)sender {
    
    [self performSegueWithIdentifier:@"routeSegue" sender:sender];
}
#pragma mark dd

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[PointMarker class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        [annotationView setAnimatesDrop:YES];
        [annotationView setPinColor:MKPinAnnotationColorPurple];
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    
    self.nomeLabel.text = [view.annotation title];
    //self.telefoneLabel.text = [view.annotation subtitle];
    self.distanciaLabel.text = [view.annotation subtitle];
    
    self.blurViewOutlet.hidden = NO;
    
    view.pinColor = MKPinAnnotationColorGreen;
    
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[view.annotation coordinate] addressDictionary:nil];
    
    self.routeDestination = [[PointMarker alloc] initWithCoordinate:placemark.coordinate title:[view.annotation title] Subtitle:@""];
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKPinAnnotationView *)view {
    
    self.routeDestination = nil;
    self.blurViewOutlet.hidden = YES;
    view.pinColor = MKPinAnnotationColorPurple;
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"routeSegue"]) {
//        
//        RouteViewController *destRouteView = segue.destinationViewController;
//        
//        destRouteView.destination = self.routeDestination;
//    }
//    
//}



@end
