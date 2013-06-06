//
//  Product.h
//  EncryptedCoreDataSample
//
//  Created by Ronan on 05/06/2013.
//  Copyright (c) 2013 Mobile Genius LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) id cost;
@property (nonatomic, retain) id price;
@property (nonatomic, retain) id name;

@end
