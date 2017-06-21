//
//  SpeechServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 21.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeechServiceProtocol <NSObject>

@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *codesToLanguages;
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *languagesToCodes;

- (void)speakText:(NSString *)text withLanguageCode:(NSString *)langCode;

@end
