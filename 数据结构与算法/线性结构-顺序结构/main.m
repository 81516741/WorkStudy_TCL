//
//  main.m
//  线性结构-顺序结构
//
//  Created by lingda on 2019/3/29.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import <Foundation/Foundation.h>
#define OK      1
#define ERROR   0
#define TRUE    1
#define FALSE   0

typedef unsigned int ElemType;
typedef int Status;
typedef struct SqList{
    ElemType * data;
    int length;
    int capacity;
} SqList;

SqList * sqListCreate(int capacity) {
    SqList * s = (SqList *)malloc(sizeof(SqList)/sizeof(char));
    if (s == NULL) {
        return NULL;
    }
    s -> data = (ElemType *)malloc(sizeof(ElemType)/sizeof(char) * capacity);
    if (s -> data == NULL) {
        free(s);
        return NULL;
    }
    s -> capacity = capacity;
    s -> length = 0;
    return s;
}

Status sqListGetElem(SqList list,int i,ElemType * e) {
    if (list.length == 0 || i < 0 || i >= list.capacity) {
        return ERROR;
    }
    *e = list.data[i];
    return OK;
}

Status sqListSetElem(SqList list,int i,ElemType e) {
    if (list.length == 0 || i < 0 || i >= list.capacity) {
        return ERROR;
    }
    list.data[i] = e;
    return OK;
}

Status sqListInsert(SqList *list, int i, ElemType e) {
    int k;
    if(list->length == list->capacity) {
        return ERROR;
    }
    if(i<0 || i>list->length) {
        return ERROR;
    }
    if( i < list->length ) {
        for( k=list->length; k > i; k-- ) {
            list->data[k] = list->data[k-1];
        }
    }
    list->data[i] = e;
    list->length++;
    return OK;
}

Status sqListDelete(SqList *list, int i, ElemType *e) {
    int k;
    if( list->length == 0 ) {
        return ERROR;
    }
    if(i<0 || i>=list->length) {
        return ERROR;
    }
    *e = list->data[i];
    if( i < list->length - 1 ) {//保证不是最后一个元素
        for( k=i; k < list->length - 1; k++ ) {
            list->data[k] = list->data[k+1];
        }
    }
    list->length--;
    return OK;
}

Status sqListHasElem(SqList list,ElemType e) {
    int len = list.length;
    for (int i = 0; i < len; i ++) {
        ElemType e0;
        sqListGetElem(list, i, &e0);
        if (e0 == e) {
            return OK;
        }
    }
    return ERROR;
}

void sqListUnion(SqList * listA, SqList * listB)
{
    int La_len, Lb_len, i;
    ElemType e;
    La_len = listA->length;
    Lb_len = listB->length;

    for( i=0; i < Lb_len; i++ )
    {
        sqListGetElem(*listB, i, &e);
        if(!sqListHasElem(*listA, e))
        {
            sqListInsert(listA, La_len++, e);
        }
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ElemType e;
        SqList * qe = sqListCreate(10);
        sqListInsert(qe, 0, 1);
        sqListInsert(qe, 1, 2);
        Status s = sqListInsert(qe, 2, 3);
        sqListDelete(qe, 1, &e);
        sqListSetElem(*qe, 0, 8);
        SqList * qe1 = sqListCreate(10);
        sqListInsert(qe1, 0, 1);
        sqListInsert(qe1, 1, 5);
        sqListInsert(qe1, 2, 6);
        
        sqListUnion(qe, qe1);
        
        for (int i = 0; i < qe->length; i ++) {
            printf("%d",qe->data[i]);
        }
        
        
    }
    return 0;
}
