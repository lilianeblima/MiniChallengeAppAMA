//
//  Place.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/5/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "Place.h"

@implementation Place

- (instancetype)initWithPlacemark: (MKPlacemark *)placemark{
    self = [super init];
    
    if (self){
        _placemark = placemark;
    }
    
    return self;
}

@end
