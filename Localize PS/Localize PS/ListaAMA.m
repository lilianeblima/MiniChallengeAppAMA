//
//  ListaAMA.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "ListaAMA.h"



@implementation ListaAMA
{
    AMA *PS;
    int i;
}

@synthesize AllAMA;

- (id) init {
    self = [super init];
    i=0;
    if (self) {
        AllAMA = [[NSMutableArray alloc] init];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PS" ofType:@"plist"];
        NSArray *amas = [NSArray arrayWithContentsOfFile:filePath];
        
        for (NSDictionary *ama in amas)
        {
            PS = [[AMA alloc]init];
            [PS setNome:[ama valueForKey:@"Nome"]];
            [PS setEndereco:[ama valueForKey:@"Endereco"]];
            [PS setRegiao:[ama valueForKey:@"Regiao"]];
            [PS setIs24hrs:[ama valueForKey:@"is24hrs"]];
            [PS setTelefone:[ama valueForKey:@"Telefone"]];
            [PS setLatitude:[ama valueForKey:@"Latitude"]];
            [PS setLatitude:[ama valueForKey:@"Longitude"]];
            //[AllAMA insertObject:PS atIndex:i];
            
            
            NSLog(@"Nomes = %@",PS.nome);
            NSLog(@"Vetor = %@",AllAMA);
            
            [AllAMA addObject:PS];
            
        
            
            i++;
        }
        
        
        
    }
    return self;
}

-(AMA*)retorno:(NSNumber*)i
{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PS" ofType:@"plist"];
            NSArray *amas = [NSArray arrayWithContentsOfFile:filePath];
    
            for (NSDictionary *ama in amas)
            {
    
                [PS setNome:[ama valueForKey:@"Nome"]];
                [PS setEndereco:[ama valueForKey:@"Endereco"]];
                [PS setRegiao:[ama valueForKey:@"Regiao"]];
                //[PS setIs24hrs:[ama valueForKey:@"is24hrs"]];
                [PS setTelefone:[ama valueForKey:@"Telefone"]];
                [PS setLatitude:[ama valueForKey:@"Latitude"]];
                [PS setLatitude:[ama valueForKey:@"Longitude"]];
                //[AllAMA insertObject:PS atIndex:i];
                NSLog(@"Nomes = %@",PS.nome);
                NSLog(@"Vetor = %@",AllAMA);
                [AllAMA addObject:PS];
                
              
            }
    
    return PS;
    
}

-(void)nomes
{
    NSLog(@"@%@", AllAMA);
    NSLog(@"------");
}


@end
