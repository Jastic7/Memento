//
//  ItemOfSet.h
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @brief Describe some stage of learning process.
 */
typedef NS_ENUM(NSInteger, LearnState) {
    //User enters incorrect definition.
    Mistake = -1,
    
    //Initial state of the item.
    //After mistake, user gets at this stage.
    Unknown,
    
    //User once enters correct definition.
    Learnt,
    
    //User twice in a row enters correct definition.
    Mastered
};


/*!
 * @brief Responsible for one learning item from  whole Set.
 */
@interface ItemOfSet : NSObject <NSCopying>

/*!
 * @brief Term of the current item.
 * User will learn this term.
 */
@property (nonatomic, copy) NSString *term;

/*!
 * @brief Definition of the current item
 * for the term.
 */
@property (nonatomic, copy) NSString *definition;

/*!
 * @brief Represent state of the learning process
 * of current item.
 */
@property (nonatomic, assign, readonly) LearnState learnProgress;

/**
 * @brief Initialize the new item with data.
 * @param term - Term of the new item.
 * @param definition - Defenition for the @term.
 * @return New item with term and definition.
 */
- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition;
- (instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition learnProgress:(LearnState)progress;

+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition;
+ (instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition learnProgress:(LearnState)progress;

/**
 * @brief Set learnProgress of the item to Mistake.
 */
- (void)failLearnProgress;

/**
 * @brief Set learnProgress of the item to Unknown.
 */
- (void)resetLearnProgress;

/**
 * @brief Increase learnProgress of the item by one.
 */
- (void)increaseLearnProgress;

@end
