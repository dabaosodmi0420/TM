//
//  TM_Object.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_Object.h"
#import <objc/runtime.h>

@implementation TM_Object

+ (NSArray *)propertysFromClass
{
    unsigned int number = 0;
    NSMutableArray *propertys = [NSMutableArray array];
    
    objc_property_t *propertyList = class_copyPropertyList(self, &number);
    for (NSInteger i = 0; i < number; i++) {
        objc_property_t *property = &propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(*property)];
        if ([TM_Object containWithProperty:propertyName]) {
            continue;
        }
        [propertys addObject:propertyName];
    }
    free(propertyList);
    return propertys;
}

+(NSArray *)modelArrayFromJsonArray:(NSArray *)jsonArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < jsonArray.count; i++) {
        
        NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
        id object = [self modelDictionaryFromJsonDictionary:jsonDic];
        if (object) {
            [modelArray addObject:object];
        }
    }
    
    return modelArray;
}

+ (id)modelDictionaryFromJsonDictionary:(NSDictionary *)jsonDictionary
{
    id object = [[[self class] alloc] init];
    
    NSArray *propertys = [self propertysFromClass];
    
    if (jsonDictionary && [jsonDictionary isKindOfClass:[NSDictionary class]]) {
        for (NSString *property in propertys) {
            id value = [jsonDictionary objectForKey:property];
            if (value && ![value isEqual:[NSNull null]]) {
                [object setValue:value forKeyPath:property];
            }
        }
    }
    else
    {
        return nil;
    }
    
    return object;
}

+ (BOOL)containWithProperty:(NSString *)property
{
    NSArray *propertys = [NSArray arrayWithObjects:@"superclass",@"hash",@"description",@"debugDescription", nil];
    if (property) {
        for (NSString *p in propertys) {
            if ([p isEqualToString:property]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    Class cls = [self class];
    
    while (cls != [NSObject class]){
        unsigned int propertyCount = 0;
        
        objc_property_t *properties = class_copyPropertyList([cls class], &propertyCount);
        
        for(unsigned int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            const char *type = property_getAttributes(property);
            NSString *typeString = [NSString stringWithUTF8String:type];
            NSArray *attributes = [typeString componentsSeparatedByString:@","];
            NSString *typeAttribute = [attributes objectAtIndex:0];
            NSString *propertyType = [typeAttribute substringFromIndex:1];
            const char *rawPropertyType = [propertyType UTF8String];
            if ([TM_Object containWithProperty:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]]) {
                continue;
            }
            if(strcmp(rawPropertyType, @encode(float)) == 0)
            {
                //it's a float
                SEL selector = sel_registerName(name);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    [invocation invoke];
                    float returnValue;
                    [invocation getReturnValue:&returnValue];
                    
                    [aCoder encodeFloat:returnValue forKey:[NSString stringWithUTF8String:name]];
                }
            }
            else if (strcmp(rawPropertyType, @encode(int)) == 0 || strcmp(rawPropertyType, @encode(NSInteger)) == 0 || strcmp(rawPropertyType, @encode(NSUInteger)) == 0)
            {
                //it's an int
                SEL selector = sel_registerName(name);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    [invocation invoke];
                    NSInteger returnValue;
                    [invocation getReturnValue:&returnValue];
                    
                    [aCoder encodeInteger:returnValue forKey:[NSString stringWithUTF8String:name]];
                }
            }
            else if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
            {
                //it's an bool
                SEL selector = sel_registerName(name);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    [invocation invoke];
                    BOOL returnValue;
                    [invocation getReturnValue:&returnValue];
                    
                    [aCoder encodeBool:returnValue forKey:[NSString stringWithUTF8String:name]];
                }
            }
            else if (strcmp(rawPropertyType, @encode(int32_t)) == 0 || strcmp(rawPropertyType, @encode(long)) == 0)
            {
                //it's an long
                SEL selector = sel_registerName(name);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    [invocation invoke];
                    int32_t returnValue;
                    [invocation getReturnValue:&returnValue];
                    
                    [aCoder encodeInt32:returnValue forKey:[NSString stringWithUTF8String:name]];
                }
            }
            else if (strcmp(rawPropertyType, @encode(int64_t)) == 0 || strcmp(rawPropertyType, @encode(long long)) == 0)
            {
                //it's an long long
                SEL selector = sel_registerName(name);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    [invocation invoke];
                    int64_t returnValue;
                    [invocation getReturnValue:&returnValue];
                    
                    [aCoder encodeInt64:returnValue forKey:[NSString stringWithUTF8String:name]];
                }
            }
            else if (strcmp(rawPropertyType, @encode(double)) == 0)
            {
                //it's an double
                SEL selector = sel_registerName(name);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    [invocation invoke];
                    double returnValue;
                    [invocation getReturnValue:&returnValue];
                    
                    [aCoder encodeDouble:returnValue forKey:[NSString stringWithUTF8String:name]];
                }
            }
            else
            {
                //it's some sort of object
                SEL selector = sel_registerName(name);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    [invocation retainArguments];
                    [invocation invoke];
                    void *returnValue;
                    [invocation getReturnValue:&returnValue];
                    
                    [aCoder encodeObject:(__bridge id)(returnValue) forKey:[NSString stringWithUTF8String:name]];
                }
            }
        }
        free(properties);
        cls = class_getSuperclass(cls);
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self != nil)
    {
        Class cls = [self class];
        
        while (cls != [NSObject class]) {
            unsigned int propertyCount = 0;
            objc_property_t *properties = class_copyPropertyList([cls class], &propertyCount);
            
            for(unsigned int i = 0; i < propertyCount; i++)
            {
                objc_property_t property = properties[i];
                const char *name = property_getName(property);
                const char *type = property_getAttributes(property);
                NSString *typeString = [NSString stringWithUTF8String:type];
                NSArray *attributes = [typeString componentsSeparatedByString:@","];
                NSString *typeAttribute = [attributes objectAtIndex:0];
                NSString *propertyType = [typeAttribute substringFromIndex:1];
                const char *rawPropertyType = [propertyType UTF8String];
                
                const char *setterName = property_copyAttributeValue(property, "S");
                if(setterName == NULL)
                {
                    NSString *nameString = [NSString stringWithUTF8String:name];
                    NSString *leftString = [NSString stringWithFormat:@"set%@", [[nameString substringToIndex:1] uppercaseString]];
                    NSString *rightString = [NSString stringWithFormat:@"%@:", [nameString substringFromIndex:1]];
                    setterName = [[leftString stringByAppendingString:rightString] UTF8String];
                }
                
                if(strcmp(rawPropertyType, @encode(float)) == 0)
                {
                    //it's a float
                    SEL selector = sel_registerName(setterName);
                    if ([self respondsToSelector:selector]) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                    [[self class] instanceMethodSignatureForSelector:selector]];
                        [invocation setSelector:selector];
                        [invocation setTarget:self];
                        
                        float value = [aDecoder decodeFloatForKey:[NSString stringWithUTF8String:name]];
                        [invocation setArgument:&value atIndex:2];
                        [invocation invoke];
                    }
                }
                else if (strcmp(rawPropertyType, @encode(int)) == 0 || strcmp(rawPropertyType, @encode(NSInteger)) == 0 || strcmp(rawPropertyType, @encode(NSUInteger)) == 0)
                {
                    //it's an int
                    SEL selector = sel_registerName(setterName);
                    if ([self respondsToSelector:selector]) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                    [[self class] instanceMethodSignatureForSelector:selector]];
                        [invocation setSelector:selector];
                        [invocation setTarget:self];
                        
                        NSInteger value = [aDecoder decodeIntegerForKey:[NSString stringWithUTF8String:name]];;
                        [invocation setArgument:&value atIndex:2];
                        [invocation invoke];
                    }
                }
                else if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
                {
                    //it's an bool
                    SEL selector = sel_registerName(setterName);
                    if ([self respondsToSelector:selector]) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                    [[self class] instanceMethodSignatureForSelector:selector]];
                        [invocation setSelector:selector];
                        [invocation setTarget:self];
                        
                        BOOL value = [aDecoder decodeBoolForKey:[NSString stringWithUTF8String:name]];;
                        [invocation setArgument:&value atIndex:2];
                        [invocation invoke];
                    }
                }
                else if (strcmp(rawPropertyType, @encode(int32_t)) == 0 || strcmp(rawPropertyType, @encode(long)) == 0)
                {
                    //it's an long
                    SEL selector = sel_registerName(setterName);
                    if ([self respondsToSelector:selector]) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                    [[self class] instanceMethodSignatureForSelector:selector]];
                        [invocation setSelector:selector];
                        [invocation setTarget:self];
                        
                        int32_t value = [aDecoder decodeInt32ForKey:[NSString stringWithUTF8String:name]];;
                        [invocation setArgument:&value atIndex:2];
                        [invocation invoke];
                    }
                }
                else if (strcmp(rawPropertyType, @encode(int64_t)) == 0 || strcmp(rawPropertyType, @encode(long long)) == 0)
                {
                    //it's an long long
                    SEL selector = sel_registerName(setterName);
                    if ([self respondsToSelector:selector]) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                    [[self class] instanceMethodSignatureForSelector:selector]];
                        [invocation setSelector:selector];
                        [invocation setTarget:self];
                        
                        int64_t value = [aDecoder decodeInt64ForKey:[NSString stringWithUTF8String:name]];;
                        [invocation setArgument:&value atIndex:2];
                        [invocation invoke];
                    }
                }
                else if (strcmp(rawPropertyType, @encode(double)) == 0)
                {
                    //it's an double
                    SEL selector = sel_registerName(setterName);
                    if ([self respondsToSelector:selector]) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                    [[self class] instanceMethodSignatureForSelector:selector]];
                        [invocation setSelector:selector];
                        [invocation setTarget:self];
                        
                        double value = [aDecoder decodeDoubleForKey:[NSString stringWithUTF8String:name]];;
                        [invocation setArgument:&value atIndex:2];
                        [invocation invoke];
                    }
                }
                else
                {
                    //it's some sort of object
                    SEL selector = sel_registerName(setterName);
                    if ([self respondsToSelector:selector]) {
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                    [[self class] instanceMethodSignatureForSelector:selector]];
                        [invocation setSelector:selector];
                        [invocation setTarget:self];
                        
                        void *value = (__bridge void *)([aDecoder decodeObjectForKey:[NSString stringWithUTF8String:name]]);;
                        [invocation setArgument:&value atIndex:2];
                        [invocation invoke];
                    }
                }
            }
            free(properties);
            cls = class_getSuperclass(cls);
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    
    NSLog(@"%s",__func__);
    NSObject* copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        Class cls = [self class];
        while (cls != [NSObject class]) {
            /*判断是自身类还是父类*/
            BOOL bIsSelfClass = (cls == [self class]);
            unsigned int iVarCount = 0;
            unsigned int propVarCount = 0;
            unsigned int sharedVarCount = 0;
            Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/
            objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/
            sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;
            
            for (int i = 0; i < sharedVarCount; i++) {
                const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
                NSString *key = [NSString stringWithUTF8String:varName];
                /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/
                id varValue = [self valueForKey:key];
                NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"];
                if (varValue && [filters containsObject:key] == NO) {
                    
                    [copy setValue:varValue forKey:key];
                }
            }
            free(ivarList);
            free(propList);
            cls = class_getSuperclass(cls);
        }
    }
    return copy;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"no find key:%@",key);
    return;
}
@end
