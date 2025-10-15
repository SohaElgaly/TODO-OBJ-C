//
//  Task.h
//  TODO-OBJ-C
//
//  Created by Soha Elgaly on 25/09/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descrption;
@property (nonatomic, strong) NSString *priority;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *date;

@end

NS_ASSUME_NONNULL_END
