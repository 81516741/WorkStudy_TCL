//
//  support.cpp
//  C++Study
//
//  Created by lingda on 2019/6/4.
//  Copyright © 2019年 lingda. All rights reserved.
//

#include <iostream>

extern int count1;
void write_extern(void) {
    std::cout<< "count is" << count1 << std::endl;
}
