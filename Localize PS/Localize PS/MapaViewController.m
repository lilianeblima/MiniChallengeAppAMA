//
//  MapaViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "MapaViewController.h"


@implementation MapaViewController

-(void)viewDidLoad{
    
    amas = [ListaAMA ItensCompartilhado];
    auxiliar = [[AMA alloc]init];
    
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
    CLLocationCoordinate2D loc;
    loc = [[_locationManager location]coordinate];
    [self calculoDistancia: loc];
    
    PointMarker *ps = [[PointMarker alloc] init];
    [_mapView addAnnotation:ps];
    [_mapView selectAnnotation:ps animated: YES];
    
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
                       
                        [annotations addObject: annot];
                        [_mapView addAnnotation:annot];
                        
                        NSLog(@"Name for result: = %@, à %.2fm de distância.", pm.name, p.distancia);
                        
                    }
                }
            }];
            
        }
    }
    
    
    [_mapView setRegion:region animated:YES];
    
    placesLocated = YES;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            MKAnnotationView* annotationView = aV;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
    }
}

- (void) calculoDistancia : (CLLocationCoordinate2D) loc{
    CLLocation *inicial = [[CLLocation alloc] initWithLatitude:loc.latitude longitude: loc.longitude];
    CLLocationDistance distancia;
    CLLocation *coordenadas;
    
    NSLog(@"Inicial%@", inicial);
    for (int i=0; i < [amas.AllAMA count]; i++){
        auxiliar = [amas.AllAMA objectAtIndex:i];
        coordenadas = [[CLLocation alloc] initWithLatitude:[auxiliar.latitude doubleValue]  longitude: [auxiliar.longitude doubleValue]];
        distancia = [inicial distanceFromLocation: coordenadas];
        [auxiliar setDistanciaMapa:distancia/1000];
    
    }
    
}

- (IBAction)rotaBotao:(id)sender {
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:thePlacemark];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark: thePlacemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        }
    }];
}

#pragma mark dd

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

//    if ([annotation isKindOfClass:[MKUserLocation class]]){
//        
//        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation                                                                           reuseIdentifier:nil];
//        annotationView.image = [UIImage imageNamed:@"standing39-3.png"];
//        annotationView.enabled=NO;
//        return annotationView;
//    }
//    else
   if ([annotation isKindOfClass:[PointMarker class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        if ( annotationView == nil){
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: identifier];
        }
        else
            annotationView.annotation = annotation;
        
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return nil;
}
//
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
//{
//    
//    self.nomeLabel.text = [view.annotation title];
//    self.telefoneLabel.text = [view.annotation subtitle];
//    self.distanciaLabel.text = [view.annotation subtitle];
//    
//    self.blurViewOutlet.hidden = NO;
//    view.pinColor = MKPinAnnotationColorGreen;
//    
//    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[view.annotation coordinate] addressDictionary:nil];
//    
//    self.routeDestination = [[PointMarker alloc] initWithCoordinate:placemark.coordinate title:[view.annotation title] Subtitle:@""];
//    
//    
//}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKPinAnnotationView *)view {
    
    self.routeDestination = nil;
    self.blurViewOutlet.hidden = YES;
    //view.pinColor = MKPinAnnotationColorPurple;
    
}



@end
