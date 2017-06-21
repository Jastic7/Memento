//
//  SpeechServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 21.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SpeechStartBlock)();
typedef void (^SpeechEndBlock)();


@protocol SpeechServiceProtocol <NSObject>

@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *codesToLanguages;
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *languagesToCodes;

- (void)speakWords:(NSArray <NSString *> *)words
 withLanguageCodes:(NSArray <NSString *> *)langCodes
  speechStartBlock:(SpeechStartBlock)startBlock
    speechEndBlock:(SpeechEndBlock)endBlock;

@end
