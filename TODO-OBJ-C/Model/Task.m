//
//  Task.m
//  TODO-OBJ-C
//
//  Created by Soha Elgaly on 25/09/2025.
//

#import "Task.h"

@implementation Task

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.descrption forKey:@"descrption"];
    [coder encodeObject:self.priority forKey:@"priority"];
    [coder encodeObject:self.status forKey:@"status"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _descrption = [coder decodeObjectOfClass:[NSString class] forKey:@"descrption"];
        _priority = [coder decodeObjectOfClass:[NSString class] forKey:@"priority"];
        _status = [coder decodeObjectOfClass:[NSString class] forKey:@"status"];
        _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[Task class]]) return NO;
    Task *otherTask = (Task *)object;
    return [self.name isEqualToString:otherTask.name] && [self.date isEqualToDate:otherTask.date];
}

- (NSUInteger)hash {
    return [self.name hash] ^ [self.date hash];
}
@end
