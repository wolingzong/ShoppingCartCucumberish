//
//  CucumberishLoader.m
//  ShoppingCartCucumberish
//
//  Created by 沃霊宗 on 2025/09/28.
//

#import <Foundation/Foundation.h>
#import "ShoppingCartCucumberishUITests-Swift.h" // 关键！

__attribute__((constructor))
void CucumberishInit(void)
{
    [CucumberishInitializer CucumberishSwiftInit];
}
