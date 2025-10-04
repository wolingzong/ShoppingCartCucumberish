//
//  CucumberishLoader.m
//  ShoppingCartCucumberish
//
//  Created by 沃霊宗 on 2025/09/28.
//


//Replace CucumberishExampleUITests with the name of your swift test target
#import "ShoppingCartCucumberishUITests-Swift.h"

__attribute__((constructor))
void CucumberishInit(void)
{
    [CucumberishInitializer CucumberishSwiftInit];
}
