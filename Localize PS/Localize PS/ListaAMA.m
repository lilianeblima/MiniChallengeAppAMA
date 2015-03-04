//
//  ListaAMA.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "ListaAMA.h"


@implementation ListaAMA

@synthesize AllAMA;

- (id) init {
    self = [super init];
    
    if (self) {
        AllAMA = [[NSMutableArray alloc] init];
    }
    return self;
}

//Singleton
+ (id)ItensCompartilhado {
    static ListaAMA *ItensCompartilhado = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ItensCompartilhado = [[self alloc] init];
    });
    return ItensCompartilhado;
}

- (AMA *) itenForIndex: (NSInteger)index {
    if([AllAMA count] <= index){
        return nil;
    }
    return AllAMA[index];
}

-(void)removeItem:(NSInteger)index{
    [AllAMA removeObjectAtIndex:index];
}

-(void)exibirInfo {
    AMA *auxiliar = [[AMA alloc] init];
    for (int i = 0; i < [AllAMA count]; i++)
    {
        auxiliar = [AllAMA objectAtIndex:i];
        NSLog(@"Nome: %@", auxiliar.nome);
        NSLog(@"Endereço: %@", auxiliar.endereco);
        NSLog(@"Regiao: %@", auxiliar.regiao);
        NSLog(@"Trabalha por 24hrs ?: %hhu", auxiliar.Hfuncionamento);
        NSLog(@"Telefone: %@", auxiliar.telefone);
       

        
    }
}

@end
