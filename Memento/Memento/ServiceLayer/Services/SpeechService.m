//
//  SpeechService.m
//  Memento
//
//  Created by Andrey Morozov on 21.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SpeechService.h"

@interface SpeechService ()

@end

@implementation SpeechService

@synthesize codesToLanguages = _codesToLanguages;
@synthesize languagesToCodes = _languagesToCodes;

#pragma mark - Getters

- (NSDictionary<NSString *,NSString *> *)languagesToCodes {
    if (!_languagesToCodes) {
        _languagesToCodes = @{@"Arabic" : @"ar-SA",
                              @"Chinese": @"zh-CN",
                              @"Czech"  : @"cs-CZ",
                              @"Danish" : @"da-DK",
                              @"English": @"en-US",
                              @"French" : @"fr-FR",
                              @"German" : @"de-DE",
                              @"Italian": @"it-IT",
                              @"Polish" : @"pl-PL",
                              @"Russian": @"ru-RU",
                              @"Spanish": @"es-ES",
                              @"Swedish": @"sv-SE",
                              @"Turkish": @"tr-TR",};
    }
    
    return _languagesToCodes;
}

- (NSDictionary<NSString *,NSString *> *)codesToLanguages {
    if (!_codesToLanguages) {
        NSArray *languages = self.languagesToCodes.allKeys;
        NSArray *codes     = self.languagesToCodes.allValues;
        
        _codesToLanguages = [NSDictionary dictionaryWithObjects:languages forKeys:codes];
    }
    
    return _codesToLanguages;
}

@end
