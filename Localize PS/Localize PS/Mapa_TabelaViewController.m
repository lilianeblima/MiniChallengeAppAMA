//
//  Mapa_TabelaViewController.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 06/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "Mapa_TabelaViewController.h"

@interface Mapa_TabelaViewController ()

@end

@implementation Mapa_TabelaViewController

//singleton
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static Mapa_TabelaViewController *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)viewDidLoad{
    
    //Inicializa o _locationManager, para pegar as posiçoes

    searching = NO;
  
    [self.MapView setDelegate:self];
    
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDelegate: self];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //Começa monitorar localização
    [_locationManager startUpdatingLocation];
    
    //Salva a posicao do usuario
    loc = [[_locationManager location]coordinate];

    [super viewDidLoad];
    
    
    
    //Traca a rota logo quando a tela é aberta
    
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(loc.latitude, loc.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@"Location"];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake([self.itemSelecionado.latitude doubleValue],[self.itemSelecionado.longitude doubleValue]) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    [self traceRoute:srcMapItem to:distMapItem];
    [_locationManager startUpdatingLocation];
    [self NearestPS];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //NSLog(@"%@",error.localizedDescription);
    
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Erro" message:@"Falha de coneão" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Adiciona anotaçoes no hospital
-(void)NearestPS {
    
    CLLocationCoordinate2D crd = CLLocationCoordinate2DMake([self.itemSelecionado.latitude doubleValue], [self.itemSelecionado.longitude doubleValue]);
    PointMarker *pin = [[PointMarker alloc] initWithCoordinate:crd title: self.itemSelecionado.nome Subtitle: self.itemSelecionado.endereco Distance:self.itemSelecionado.distancia];
    [_MapView addAnnotation:pin];
    [_MapView selectAnnotation:pin animated:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(crd, 800, 800);
    [_MapView setRegion : region animated:YES];
    
}

//Funcao complementar para traçar a rota
-(void)traceRoute:(MKMapItem *) source to: (MKMapItem *) destination {
    [_MapView removeOverlay:rota.polyline];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    [request setSource:source];
    [request setDestination:destination];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            rota = obj;
            MKPolyline *line = [rota polyline];
            [_MapView addOverlay:line level:MKOverlayLevelAboveRoads];
            
            NSArray *steps = [rota steps];
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
            }];
        }];
        NSInteger t = round(rota.expectedTravelTime/60);
        NSString *tempo = [NSString stringWithFormat:@"Tempo: %ld min",(long)t];
        NSLog(@"tempo %@", tempo);
        if (t == 0) {
            [_LTempo setText:@" Não foi possível gerar a rota"];
        }
        else
        [_LTempo setText:tempo];
        [_labelteste setText:self.itemSelecionado.endereco];
        
    }];
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D location = [ [locations lastObject] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 800, 800);
    
    if (!searching) {
        searching = YES;
        [_MapView setRegion:region animated:YES];
        searching = NO;
    }
}

/*
 * Funcão para desenhar a Rota no Mapa
 *
 */
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor blueColor];
    return polylineRender;
}


// Botão para atualizar achar Posição atual no mapa e para o hospital

- (IBAction)BAtualizar:(id)sender {
    [_locationManager startUpdatingLocation];
    [self NearestPS];
    
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





#pragma mark dd

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //Muda o texto da Annotation de localizacao do usuario
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
         ((MKUserLocation *)annotation).title = @"Posição Atual";
    }
    
   
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
        [annotationView setImage:[UIImage imageNamed:@"ps.png"]];
        //nao deixa legenda encima da imagem
        annotationView.centerOffset = CGPointMake(0,-annotationView.frame.size.height*0.5);
        return annotationView;
    }
    return nil;
}



@end
