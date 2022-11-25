//
//  NSString+Validations.m
//  BurbankApp
//
//  Created by Mohan Kumar on 22/12/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

#import "NSString+Validations.h"

@implementation NSString (Validations)

+(NSString *)checkNullValue:(NSString *)inputValue
{
    if (inputValue == nil || [inputValue isEqual:[NSNull null]]) {
        inputValue = @"";
    }
    return inputValue;
}

+(NSString *)priceFormat:(int)price {
    
    int currency = price;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"USD"];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:currency]];
    numberAsString = [numberAsString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    numberAsString = [numberAsString stringByReplacingOccurrencesOfString:@"US" withString:@""];

    return [NSString stringWithFormat:@"%@",numberAsString];
}

+(float)checkIntegerNull:(id)value
{
    float newValue;
    
    if (value == nil || [value isEqual:[NSNull null]]) {
        
        newValue = 0.00;
    }
    else
    {
        newValue = [value floatValue];
    }
    
    return newValue;
}

@end
