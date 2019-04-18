//
//  main.m
//  静态链表
//
//  Created by lingda on 2019/4/10.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OK      1
#define ERROR   0
#define TRUE    1
#define FALSE   0
#define MAXSIZE 10
typedef int Status;
typedef int ElemType;
typedef struct {
    ElemType data;
    int cur;
}StaticLinkList[MAXSIZE];//0位是类似头指针的，最后一位是存放首个元素的游标的，所以只可以存放  MAXSIZE - 2 个元素

Status StaticLinkListInit(StaticLinkList space) {
    for (int i = 0; i < MAXSIZE - 1; i++) {
        space[i].cur = i + 1;
    }
    space[MAXSIZE-1].cur = 0;
    return OK;
}
int StaticLinkListMalloc(StaticLinkList space) {
    int i = space[0].cur;
    if (i) {
        space[0].cur = space[i].cur;
    }
    return i;
}
int StaticLinkListLength(StaticLinkList space) {
    int j = 0,k = space[MAXSIZE - 1].cur;
    while (k) {
        j ++;
        k = space[k].cur;
    }
    return j;
}
Status StaticLinkListInsert(StaticLinkList list, int i, ElemType data) {
    i = i + 1;
    if (i<1 || i>StaticLinkListLength(list)+1 || i >= MAXSIZE - 1) {
        return ERROR;
    }
    int j = StaticLinkListMalloc(list);
    int k = MAXSIZE - 1;
    if (j) {
        for (int l = 1; l <= i - 1; l++) {
            k = list[k].cur;
        }
        list[j].data = data;
        list[j].cur = list[k].cur;
        list[k].cur = j;
        return OK;
    }
    return ERROR;
}
Status StaticLinkListAppend(StaticLinkList list, ElemType data) {
    int length = StaticLinkListLength(list);
    if (length < MAXSIZE - 2) {
        return StaticLinkListInsert(list, length, data);
    } else {
        return ERROR;
    }
}


void StaticLinkListFree(StaticLinkList list,int i) {
    list[i].cur = list[0].cur;
    list[0].cur = i;
}
Status StaticLinkListDelete(StaticLinkList list,int i, ElemType * data) {
    i = i + 1;
    if (i < 1 || i > StaticLinkListLength(list)) {
        return ERROR;
    }
    int k = MAXSIZE - 1;
    for (int l = 1; l <= i-1; l++) {
        k = list[k].cur;
    }
    int j = list[k].cur;
    *data = list[j].data;
    list[k].cur = list[j].cur;
    StaticLinkListFree(list, j);
    return OK;
}

Status StaticLinkListSet(StaticLinkList list,int i,ElemType data) {
    i = i + 1;
    if (i < 0 || i > StaticLinkListLength(list)) {
        return ERROR;
    }
    int j = list[MAXSIZE - 1].cur;
    for (int k = 1; k < i; k ++) {
        j = list[j].cur;
    }
    list[j].data = data;
    return OK;
}
Status StaticLinkListGet(StaticLinkList list,int i,ElemType * data) {
    i = i + 1;
    if (i < 0 || i > StaticLinkListLength(list)) {
        return ERROR;
    }
    int j = list[MAXSIZE - 1].cur;
    for (int k = 1; k < i; k ++) {
        j = list[j].cur;
    }
    *data = list[j].data;
    return OK;
}

void StaticLinkListTraverse(StaticLinkList list) {
    int i = list[MAXSIZE - 1].cur;
    while (i) {
        printf("%d\n",list[i].data);
        i = list[i].cur;
    }
}

int main(int argc, const char * argv[]) {
    StaticLinkList list;
    StaticLinkListInit(list);
    Status ok = StaticLinkListInsert(list, 0, 11);
    ok = StaticLinkListInsert(list, 1, 22);
    ok = StaticLinkListInsert(list, 0, 33);
    ok = StaticLinkListAppend(list, 1);
    ok = StaticLinkListAppend(list, 2);
    StaticLinkListTraverse(list);
    int leng = StaticLinkListLength(list);
    int data;
    int d = StaticLinkListGet(list, 2, &data);
    StaticLinkListSet(list, 0, 100);
    StaticLinkListDelete(list, 0, &data);
    StaticLinkListSet(list, 2, 58);
    return 0;
}
