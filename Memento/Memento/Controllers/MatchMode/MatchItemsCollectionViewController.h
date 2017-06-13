//
//  MatchItemsCollectionViewController.h
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MatchOrganizerProtocol.h"

@interface MatchItemsCollectionViewController : UICollectionViewController <MatchOrganizerDelegate>

@property (nonatomic, strong) id <MatchOrganizerProtocol> organizer;
@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, copy) void (^finishMatchBlock)();

@end
