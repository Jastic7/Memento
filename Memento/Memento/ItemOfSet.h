//
//  ItemOfSet.h
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LearnState) {
    Unknown,
    Learnt,
    Mastered
};


@interface ItemOfSet : NSObject <NSCopying>

@property (nonatomic, copy) NSString *term;
@property (nonatomic, copy) NSString *definition;
@property (nonatomic, assign, readonly) LearnState learnProgress;

- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition;
+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition;

- (void)resetLearnProgress;
- (void)increaseLearnProgress;

@end
