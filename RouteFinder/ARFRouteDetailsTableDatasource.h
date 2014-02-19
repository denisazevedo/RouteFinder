//
//  ARFRouteDetailsTableDatasource.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 19/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARFRoute.h"

@protocol ARFRouteDetailsTableDatasource <NSObject>
- (ARFRoute *)route;
@end
