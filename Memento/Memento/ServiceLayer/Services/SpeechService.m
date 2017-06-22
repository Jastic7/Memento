//
//  SpeechService.m
//  Memento
//
//  Created by Andrey Morozov on 21.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "SpeechService.h"
#import <AVFoundation/AVFoundation.h>

@interface SpeechService () <AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@property (nonatomic, copy) SpeechStartBlock startBlock;
@property (nonatomic, copy) SpeechEndBlock endBlock;

@property (nonatomic, assign) NSUInteger currentUtterance;
@property (nonatomic, assign) NSUInteger totalUtterance;

@end


@implementation SpeechService

@synthesize codesToLanguages = _codesToLanguages;
@synthesize languagesToCodes = _languagesToCodes;

#pragma mark - Getters

- (AVSpeechSynthesizer *)synthesizer {
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    
    return _synthesizer;
}

- (NSDictionary<NSString *, NSString *> *)languagesToCodes {
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


#pragma mark - SpeechServiceProtocol implementation

- (void)speakWords:(NSArray<NSString *> *)words
 withLanguageCodes:(NSArray<NSString *> *)langCodes
  speechStartBlock:(SpeechStartBlock)startBlock
    speechEndBlock:(SpeechEndBlock)endBlock {
    
    if (!self.synthesizer.isSpeaking) {
        self.startBlock = startBlock;
        self.endBlock = endBlock;
        
        self.currentUtterance = 0;
        self.totalUtterance = words.count;
        
        for (int i = 0; i < words.count; i++) {
            NSString *word = words[i];
            NSString *lang = langCodes[i];
            
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:word];
            utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
            
            [self.synthesizer speakUtterance:utterance];
        }
        
    } else {
        [self.synthesizer continueSpeaking];
    }
}


#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    if ((self.currentUtterance == 0) && (self.startBlock) ){
        self.startBlock();
    }
    
    self.currentUtterance += 1;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if ((self.currentUtterance == self.totalUtterance) && (self.endBlock)) {
        self.endBlock();
    }
}

@end
