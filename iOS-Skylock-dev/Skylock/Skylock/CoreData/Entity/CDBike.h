//
//  CDBike.h
//  Skylock
//
//  Created by Daniel Ondruj on 14.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDUser;

@interface CDBike : NSManagedObject

@property (nonatomic, retain) NSString * bike_id;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * frame;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * purchase_date;
@property (nonatomic, retain) NSString * serial_number;
@property (nonatomic, retain) NSString * speeds;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) CDUser *owner;

@end
