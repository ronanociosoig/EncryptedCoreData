//
//  DetailViewController.h
//  EncryptedCoreDataSample
//
//  Created by Ronan on 30/05/2013.
//  Copyright (c) 2013 Mobile Genius LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
