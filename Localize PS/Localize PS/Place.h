//
//  Place.h
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/5/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Place : NSObject

-(instancetype) initWithPlacemark:(MKPlacemark *)placemark;

@property MKPlacemark *placemark;
@property double distancia;

@end
