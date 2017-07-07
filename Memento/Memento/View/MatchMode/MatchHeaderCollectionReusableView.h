//
//  MatchHeaderCollectionReusableView.h
//  Memento
//
//  Created by Andrey Morozov on 01.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, copy) void (^cancelBlock)();

- (NSString *)stopTimer;

@end
