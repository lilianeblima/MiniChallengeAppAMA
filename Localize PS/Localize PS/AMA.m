//
//  AMA.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "AMA.h"


@implementation AMA

@synthesize nome;
@synthesize endereco;
@synthesize regiao;
@synthesize latitude;
@synthesize longitude;
@synthesize telefone;
@synthesize Hfuncionamento;


- (id) init {
    self = [super init];
    
    if (self) {
        nome = [[NSString alloc] init];
        endereco = [[NSString alloc] init];
        regiao = [[NSString alloc] init];
        latitude = [[NSString alloc]init];
        longitude = [[NSString alloc]init];
        telefone = [[NSString alloc]init];
        Hfuncionamento = [[NSString alloc]init];
    }
    return self;
}
//
//- (void) Hosp:(NSString *)n : (NSString *)e : (NSString *)r : (NSNumber *)lat : (NSNumber *)lon : (Boolean)f : (NSString *)t
//{
//    [self setNome:n];
//    [self setEndereco:e];
//    [self setRegiao:r];
//    [self setLatitude:lat];
//    [self setLongitude:lon];
//    [self setHfuncionamento:f];
//    [self setTelefone:t];
//    
//}

@end
