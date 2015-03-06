//
//  ListaPSTableViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "ListaPSTableViewController.h"
#import "PSTableViewCell.h"
#import "ListaAMA.h"


@interface ListaPSTableViewController ()
{
    AMA *ama,*ama2;
    ListaAMA *listaAma;
    CLLocationCoordinate2D loc,lat;
    NSArray *locali;
    
    
    //CLLocationManager *locationManager;
    
    
}

@end

@implementation ListaPSTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //locationManager = [[CLLocationManager alloc]init];
    //Inicializando as variaveis
    ama = [[AMA alloc]init];
    listaAma = [[ListaAMA alloc]init];
    //loc = [[CLLocationCoordinate2D alloc]init];
    
    
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
    
    
    
    lat = [_locationManager location].coordinate;
    
    for (int a; a<[listaAma.AllAMA count]; a++) {
        
        double valor = [self DistanceBetweenCoordinate:lat andCoordinate: [ama.latitude doubleValue] andLong:[ama.longitude doubleValue]];
        NSLog(@"Valor = %f",valor);
        
        
    }
    
    
    
    
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //NSLog(@"%@",error.localizedDescription);
    
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Erro" message:@"Falha em localizar sua localização" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}





-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"So Aki");
    //NSLog(@"AKIII%@", [locations lastObject]);
    _armazenar = [locations lastObject];
    //NSLog(@"EITA%@",[self.locationManager.location].coordinate]);
    
    //[self.locationManager.location];
    //[self.locationManager.location.coordinate];
    
    [_locationManager stopUpdatingLocation];
    
    
    // NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = _armazenar;
    
    
    
    if (currentLocation != nil) {
        
        
        
        //  latiduteUM = [currentLocation.coordinate.latitude];
        // longitudeUM = [currentLocation.coordinate.longitude];
        
        
        _longitudeUM  = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
        
        _latiduteUM  = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
    }
    
}

-(CLLocationDistance) DistanceBetweenCoordinate:(CLLocationCoordinate2D)origenCoordinete andCoordinate:(double )LatDestion andLong:(double)LongDestion
{
    CLLocation *originlocation = [[CLLocation alloc]initWithLatitude:origenCoordinete.latitude longitude:origenCoordinete.longitude];
    
    CLLocation *destination = [[CLLocation alloc]initWithLatitude:LatDestion longitude:LongDestion];
    
    CLLocationDistance distance = [originlocation distanceFromLocation:destination];
    
    return distance;
    
}





//-(double)CalculoDistancia :(double)LatitudeUm :(double)LatitudeDois :(double)LongitudeUm :(double)LongitudeDois
//{
//
//    double distancia;
//    double Pi = 3.1415926536;
//
//    distancia = ((acos(cos((90 - LatitudeUm)* Pi/180)*cos((90 - LatitudeDois) * Pi/180)+ sin((90 - LatitudeUm)* Pi/180)*sin((90 - LatitudeDois)* Pi/180) * cos(ABS(((360 + LongitudeUm)* Pi/180) - ((360 + LongitudeDois)* Pi/180)))))*6371.004) * 1000;
//
//    return distancia;
//
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [listaAma.AllAMA count];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSTableCell" forIndexPath:indexPath];
    
    [self sortAllAma];
    
    AMA *currentAma = [listaAma.AllAMA objectAtIndex:[indexPath row]];
    
    if (cell == nil)
    {
        cell = [[PSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PSTableCell"];
    }
    
    
    
    
    cell.HNome.text = currentAma.nome;
    cell.HTelefone.text = currentAma.telefone;
    cell.HEndereco.text = currentAma.endereco;
    cell.HRegiao.text = currentAma.regiao;
    //cell.HHorario.text = currentAma.is24hrs;
    cell.HHorario.text = [NSString stringWithFormat:@"%f", currentAma.distancia];
    
    NSLog(@"%@", cell.HHorario.text);
    
    //
    
    
    
    
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    long row1 = [fromIndexPath row];
    
    long row2 = [toIndexPath row];
    
    
    
    id temp = [listaAma.AllAMA objectAtIndex:row1];
    
    [listaAma.AllAMA removeObjectAtIndex:row1];
    
    [listaAma.AllAMA insertObject:temp atIndex:(row2)];
    
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


-(void)sortAllAma{
    for (int i = 0; i < [listaAma.AllAMA count]; i++) {
        AMA *currentAma = listaAma.AllAMA[i];
        
        
        
        CLLocationDistance auxDistance = [self DistanceBetweenCoordinate:lat andCoordinate: [currentAma.latitude doubleValue] andLong:[currentAma.longitude doubleValue]];
        
        [currentAma setDistancia:auxDistance];
        [listaAma.AllAMA replaceObjectAtIndex:i withObject:currentAma];
    }
    
    NSSortDescriptor *modelDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distancia" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:modelDescriptor];
    NSArray *sortedArray = [listaAma.AllAMA sortedArrayUsingDescriptors:sortDescriptors];
    
    [listaAma setAllAMA:[sortedArray mutableCopy]];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
