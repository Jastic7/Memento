//
//  CreationalNewSetDelegate.h
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Set;

@protocol CreationalNewSetDelegate <NSObject>

-(void)cancelCreationalNewSet;
-(void)saveNewSet:(Set *)set;

@end
