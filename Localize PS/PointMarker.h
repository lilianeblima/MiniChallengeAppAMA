//
//  PointMarker.h
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/5/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface PointMarker : NSObject <MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D) coord title: (NSString *) title Subtitle: (NSString *)subTitle;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end