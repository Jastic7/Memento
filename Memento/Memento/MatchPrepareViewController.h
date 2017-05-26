//
//  MatchPrepareViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Set;
@class MatchModeOrganizer;
@protocol MatchModeDelegate;


@interface MatchPrepareViewController : UIViewController

@property (nonatomic, strong) Set *set;
@property (nonatomic, strong) MatchModeOrganizer *organizer;
@property (nonatomic, weak) id<MatchModeDelegate> delegate;

@end
