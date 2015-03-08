//
//  PointMarker.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/5/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "PointMarker.h"

@implementation PointMarker


@synthesize coordinate, title;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coord title: (NSString *) t Subtitle:(NSString *)subTitle Distance:(float)distancia  {
    self = [super init];
    
    if(self){
        coordinate = coord;
        [self setTitle:t];
        [self setSubtitle:subTitle];
        [self setDistance:distancia];
        
    }
    
    return self;
}



@end