//
//  main.m
//  递归
//
//  Created by lingda on 2019/4/28.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import <Foundation/Foundation.h>

void move1(int n,char x,char y,char z) {
    if (n == 1) {
        printf("%c 移动到 %c",x,z);
        printf("\n");
    } else {
        move1(n - 1, x, z, y);
        printf("%c 移动到 %c",x,z);
        printf("\n");
        move1(n - 1, y, x, z);
    }
    
}

int main(int argc, const char * argv[]) {
    move1(3, 'x', 'y', 'z');
    return 0;
}
