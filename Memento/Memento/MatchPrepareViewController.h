//
//  MatchPrepareViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchOrganizerProtocol.h"

@protocol MatchModeDelegate;


@interface MatchPrepareViewController : UIViewController

@property (nonatomic, strong) id <MatchOrganizerProtocol> organizer;
@property (nonatomic, weak) id <MatchModeDelegate> delegate;

@end
