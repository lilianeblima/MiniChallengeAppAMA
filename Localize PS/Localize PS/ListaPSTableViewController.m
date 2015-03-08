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
#import "Mapa_TabelaViewController.h"


@interface ListaPSTableViewController ()


@end

@implementation ListaPSTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    //Inicializando as variaveis
    ama = [[AMA alloc]init];
    listaAma = [[ListaAMA alloc]init];

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
    
    //Salva as coordenadas do cliente na variavel loc
    loc = [_locationManager location].coordinate;
    
}



#pragma mark - Table view data source

//Configuracoes da Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [listaAma.AllAMA count];
}


//Preenchimento da tabela

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
    cell.HHorario.text = currentAma.is24hrs;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    long row1 = [fromIndexPath row];
    
    long row2 = [toIndexPath row];
    
    id temp = [listaAma.AllAMA objectAtIndex:row1];
    
    [listaAma.AllAMA removeObjectAtIndex:row1];
    
    [listaAma.AllAMA insertObject:temp atIndex:(row2)];
    
    
}

//Configurações para passar os dados para a proxima view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    itemSelecionado = [listaAma.AllAMA objectAtIndex:[indexPath row]];
    
    [self performSegueWithIdentifier:@"showMapSegue" sender:tableView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Mapa_TabelaViewController *proximaView = segue.destinationViewController;
    
    proximaView.loc = &(loc);
    
    proximaView.itemSelecionado = itemSelecionado;
    
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

//Calculo para determinar a distancia entre o usuario e um Hospital

-(CLLocationDistance) DistanceBetweenCoordinate:(CLLocationCoordinate2D)origenCoordinete andCoordinate:(double )LatDestion andLong:(double)LongDestion
{
    CLLocation *originlocation = [[CLLocation alloc]initWithLatitude:origenCoordinete.latitude longitude:origenCoordinete.longitude];
    
    CLLocation *destination = [[CLLocation alloc]initWithLatitude:LatDestion longitude:LongDestion];
    
    CLLocationDistance distance = [originlocation distanceFromLocation:destination];
    
    return distance;
    
}

//Ordenando o vetor
-(void)sortAllAma{
    for (int i = 0; i < [listaAma.AllAMA count]; i++) {
        AMA *currentAma = listaAma.AllAMA[i];
        
        
        
        CLLocationDistance auxDistance = [self DistanceBetweenCoordinate:loc andCoordinate: [currentAma.latitude doubleValue] andLong:[currentAma.longitude doubleValue]];
        
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
