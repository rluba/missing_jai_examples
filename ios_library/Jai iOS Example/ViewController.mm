//
//  ViewController.m
//  jai_ios_test
//
//  Created by Raphael Luba on 14.11.23.
//

#import "ViewController.h"

#include "../jai_exports.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    const char *c_string = "Hello from Objective-C";
    string s;
    s.count = strlen(c_string);
    s.data = (uint8_t *) c_string;
    string result = hello_from_jai(s, 42);
    NSString *native_string = [[NSString alloc] initWithBytes:result.data length:result.count encoding:NSUTF8StringEncoding];
    NSLog(@"Jai said: %@", native_string);
    {
        Our_Jai_Struct x;
        x.s = s;
        x.value = 69105;
        string result = more_hello_from_jai(&x);
        NSString *native_string = [[NSString alloc] initWithBytes:result.data length:result.count encoding:NSUTF8StringEncoding];
        NSLog(@"Jai also said: %@", native_string);
    }
}


@end
