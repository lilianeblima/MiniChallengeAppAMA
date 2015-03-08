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

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static Mapa_TabelaViewController *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelteste.text = self.itemSelecionado.latitude;
    _AtualizarPosicao=0;
    [super viewDidLoad];
    //CLLocationManager *locationManager;
    
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
    
    
    //Dizer ao locationManager para começar a procurar pela localização imediatamente
    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view, typically from a nib.
    
   
}




-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    MKPointAnnotation *pm = [[MKPointAnnotation alloc]init];
    
    NSLog(@"%@", [locations lastObject]);
    //Encontrar as coordenadas de localização atual
    CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
    
    //Determinar região com as coordenadas de localização atual e os limites N/S e L/O no zoom em metros
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    
    //    //Mudar a região atual para visualização de forma animada
    if(_AtualizarPosicao==0)
    {
        // [_Mapa removeAnnotations:[_Mapa annotations]];
        [_MapView setRegion:region animated:YES ];
        
        
        [pm setCoordinate:CLLocationCoordinate2DMake(loc.latitude, loc.longitude)];
        pm.title = [NSString stringWithFormat:@"Posicao Atual"];
        [_MapView addAnnotation:pm];
        _AtualizarPosicao=1;
    }
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

//----------------------------------------------------

@end
