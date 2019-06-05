//
//  main.cpp
//  C++Study
//
//  Created by lingda on 2019/6/3.
//  Copyright © 2019年 lingda. All rights reserved.
//

#include <iostream>
extern void write_extern(void);
int count1;
using namespace std;
enum color {red = 10,green,blue} c;
int main(int argc, const char * argv[]) {
    // insert code here...
    c = green;
    count1 = 19;
    cout << c << endl;
    write_extern();
    return 0;
}
