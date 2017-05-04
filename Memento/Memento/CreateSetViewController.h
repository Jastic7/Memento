//
//  CreateSetViewController.h
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreationalNewSetDelegate.h"

@interface CreateSetViewController : UIViewController

@property (nonatomic, weak) id<CreationalNewSetDelegate> delegate;

@end
