//
//  AMA.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "AMA.h"

@implementation AMA

- (id) init {
    self = [super init];
    
    if (self) {
        _nome = [[NSString alloc] init];
        _endereco = [[NSString alloc] init];
        _regiao = [[NSString alloc] init];
        _latitude = [[NSNumber alloc]init];
        _longitude = [[NSNumber alloc]init];
        _telefone = [[NSString alloc]init];
    }
    return self;
}

- (void) Hosp:(NSString *)n : (NSString *)e : (NSString *)r : (NSNumber *)lat : (NSNumber *)lon : (Boolean)f : (NSString *)t
{
    [self setNome:n];
    [self setEndereco:e];
    [self setRegiao:r];
    [self setLatitude:lat];
    [self setLongitude:lon];
    [self setHfuncionamento:f];
    [self setTelefone:t];
    
}

@end
