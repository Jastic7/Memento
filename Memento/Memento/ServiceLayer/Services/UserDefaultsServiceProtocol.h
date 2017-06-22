//
//  UserDefaultsServiceProtocol.h
//  Memento
//
//  Created by Andrey Morozov on 23.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDefaultsServiceProtocol <NSObject>

@property (nonatomic, assign) BOOL isAudioEnabled;

@end
