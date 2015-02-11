//
//  BaseClass.m
//
//  Created by issuser  on 14-8-27
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "BaseClass.h"
#import "Data.h"


NSString *const kBaseClassStatus = @"status";
NSString *const kBaseClassMessg = @"messg";
NSString *const kBaseClassData = @"data";


@interface BaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BaseClass

@synthesize status = _status;
@synthesize messg = _messg;
@synthesize data = _data;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.status = [self objectOrNilForKey:kBaseClassStatus fromDictionary:dict];
            self.messg = [self objectOrNilForKey:kBaseClassMessg fromDictionary:dict];
            self.data = [Data modelObjectWithDictionary:[dict objectForKey:kBaseClassData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kBaseClassStatus];
    [mutableDict setValue:self.messg forKey:kBaseClassMessg];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kBaseClassData];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.status = [aDecoder decodeObjectForKey:kBaseClassStatus];
    self.messg = [aDecoder decodeObjectForKey:kBaseClassMessg];
    self.data = [aDecoder decodeObjectForKey:kBaseClassData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:kBaseClassStatus];
    [aCoder encodeObject:_messg forKey:kBaseClassMessg];
    [aCoder encodeObject:_data forKey:kBaseClassData];
}

- (id)copyWithZone:(NSZone *)zone
{
    BaseClass *copy = [[BaseClass alloc] init];
    
    if (copy) {

        copy.status = [self.status copyWithZone:zone];
        copy.messg = [self.messg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
