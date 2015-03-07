//
//  AMA.h
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AMA : NSObject


@property NSString *nome;
@property NSString *endereco;
@property NSString *regiao;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *is24hrs;
@property NSString *telefone;
@property CLLocationDistance distancia;
@property float distanciaMapa;


@end
