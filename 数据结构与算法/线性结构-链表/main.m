//
//  main.swift
//  线性结构-链表
//
//  Created by lingda on 2019/4/4.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import <Foundation/Foundation.h>
#define OK      1
#define ERROR   0
#define TRUE    1
#define FALSE   0
typedef unsigned int ElemType;

typedef int Status;
typedef struct Node{
    ElemType data;
    struct Node * next;
} Node;
typedef Node * LinkList;

Status LinkListGetElem(LinkList list, int i, ElemType *e ) {
    int j;
    j = -1;
    while( list->next && j<i ) {
        list = list->next;
        ++j;
    }
    if( !list || j>i ) {
        return ERROR;
    }
    *e = list->data;
    return OK;
}

Status LinkListInsert(LinkList * list, int i, ElemType e) {
    int j;
    LinkList s;
    j = -1;
    while( (*list)->next && j<i ) {
        (*list) = (*list)->next;
        j++;
    }
    if( !(*list) || j>i ) {
        return ERROR;
    }
    s = (LinkList)malloc(sizeof(Node));
    s->data = e;
    s->next = (*list)->next;
    (*list)->next = s;
    return OK;
}

Status LinkListDelete(LinkList * list, int i, ElemType * e) {
    int j;
    LinkList q;
    j = -1;
    while( (*list)->next && j<i ) {
        (*list) = (*list)->next;
        ++j;
    }
    if( !((*list)->next) || j>i ) {
        return ERROR;
    }
    q = (*list)->next;
    (*list)->next = q->next;
    *e = q->data;
    free(q);
    return OK;
}

LinkList LinkListCreateHead(int n) {
    LinkList p;
    int i;
    srand((unsigned int)time(0));//初始化随机数种子
    LinkList list = (LinkList)malloc(sizeof(Node));
    list->next = NULL;
    for( i=0; i < n; i++ ) {
        p = (LinkList)malloc(sizeof(Node));
        p->data = rand()%100+1;
        printf("%d,",p->data);
        p->next = list->next;
        list->next = p;
    }
    return list;
}

LinkList LinkListCreateTail(int n) {
    LinkList p,r;
    int i;
    srand((unsigned int)time(0));//初始化随机数种子
    LinkList list = (LinkList)malloc(sizeof(Node));
    r = list;
    for( i=0; i < n; i++ ) {
        p = (LinkList)malloc(sizeof(Node));
        p->data = rand()%100+1;
        printf("%d,",p->data);
        r->next = p;
        r = p;
    }
    r->next = NULL;
    return list;
}

Status LinkListClear(LinkList * list) {
    LinkList p, q;
    p = (*list)->next;
    while(p) {
        q = p->next;
        free(p);
        p = q;
    }
    (*list)->next = NULL;
    return OK;
}

//面试题
LinkList fastFindMidNode(LinkList list) {
    LinkList l1 = list->next;
    LinkList l2 = list->next;
    int i = 0;
    while (l1->next != NULL) {
        l1 = l1->next;
        if (l1->next != NULL) {
            l1 = l1->next;
        }
        l2 = l2->next;
        i ++;
    }
    return l2;
}

int main(int argc, const char * argv[]) {
    LinkList list = LinkListCreateTail(5);
    LinkList list1 = fastFindMidNode(list);
    
    return 0;
}
