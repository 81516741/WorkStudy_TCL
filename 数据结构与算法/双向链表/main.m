//
//  main.m
//  双向链表
//
//  Created by lingda on 2019/4/20.
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
    struct Node * pre;
} Node;
typedef Node * LinkListDouble;

int LinkListDoubleLength(LinkListDouble list) {
    int count = 0;
    LinkListDouble temp = list;
    while (temp->next != list) {
        count ++;
        temp = temp->next;
    }
    return count;
}

Status LinkListDoubleClear(LinkListDouble * list) {
    LinkListDouble p, q;
    p = (*list)->next;
    while(p != *list) {
        q = p->next;
        free(p);
        p = q;
    }
    (*list)->next = *list;
    (*list)->pre = *list;
    return OK;
}

LinkListDouble LinkListDoubleCreateHead(int n) {
    LinkListDouble p;
    int i;
    srand((unsigned int)time(0));//初始化随机数种子
    LinkListDouble list = (LinkListDouble)malloc(sizeof(Node));
    list->next = list;
    list->pre = list;
    for( i=0; i < n; i++ ) {
        p = (LinkListDouble)malloc(sizeof(Node));
        p->data = rand()%100+1;
        printf("%d,",p->data);
        p->next = list->next;
        p->pre = list;
        list->next->pre = p;
        list->next = p;
    }
    return list;
}

LinkListDouble LinkListDoubleCreateTail(int n) {
    LinkListDouble p;
    int i;
    srand((unsigned int)time(0));//初始化随机数种子
    LinkListDouble list = (LinkListDouble)malloc(sizeof(Node));
    list->next = list;
    list->pre = list;
    for( i=0; i < n; i++ ) {
        p = (LinkListDouble)malloc(sizeof(Node));
        p->data = rand()%100+1;
        printf("%d,",p->data);
        p->pre = list->pre;
        p->next = list;
        list->pre->next = p;
        list->pre = p;
    }
    return list;
}

Status LinkListDoubleGet(LinkListDouble list,int n,ElemType * data) {
    if (list->next == list || n < 0 || n > LinkListDoubleLength(list)) {
        return ERROR;
    }
    n = n + 1;
    while (n) {
        list = list->next;
        n--;
    }
    *data = list->data;
    return OK;
}

Status LinkListDoubleSet(LinkListDouble * list,int n,ElemType data) {
    LinkListDouble temp = *list;
    if (temp->next == temp || n < 0 || n > LinkListDoubleLength(temp)) {
        return ERROR;
    }
    n = n + 1;
    while (n) {
        temp = temp->next;
        n--;
    }
    temp->data = data;
    return OK;
}

Status LinkListDoubleDelete(LinkListDouble * list,int n,ElemType * data) {
    LinkListDouble temp = *list;
    if (temp->next == temp || n < 0 || n > LinkListDoubleLength(temp)) {
        return ERROR;
    }
    while (n) {
        temp = temp->next;
        n--;
    }
    LinkListDouble shouldDelete = temp->next;
    temp->next = shouldDelete->next;
    shouldDelete->next->pre = temp;
    *data = shouldDelete->data;
    free(shouldDelete);
    return OK;
}

Status LinkListDoubleInset(LinkListDouble * list,int n,ElemType data) {
    LinkListDouble temp = *list;
    if (temp->next == temp || n < 0 || n > LinkListDoubleLength(temp)) {
        return ERROR;
    }
    while (n) {//找到前一个元素
        temp = temp->next;
        n--;
    }
    LinkListDouble p = (LinkListDouble)malloc(sizeof(Node));
    p->data = data;
    p->pre = temp;
    p->next = temp->next;
    p->next->pre = p;
    temp->next = p;
    return OK;
}

Status LinkListDoubleAppend(LinkListDouble * list,ElemType data) {
    LinkListDouble temp = (*list)->pre;
    LinkListDouble p = (LinkListDouble)malloc(sizeof(Node));
    p->data = data;
    p->pre = temp;
    p->next = temp->next;
    p->next->pre = p;
    temp->next = p;
    return OK;
}


int main(int argc, const char * argv[]) {
    LinkListDouble list = LinkListDoubleCreateTail(5);
    int length = LinkListDoubleLength(list);
    ElemType data;
    Status isOK = LinkListDoubleGet(list, 3, &data);
    LinkListDoubleAppend(&list, 999);
    LinkListDoubleAppend(&list, 888);
    LinkListDoubleDelete(&list, 2, &data);
    LinkListDoubleSet(&list, 2, 333);
    LinkListDoubleInset(&list, 0, 100);
    LinkListDoubleInset(&list, 1, 1100);
    LinkListDoubleAppend(&list, 118);
    LinkListDoubleClear(&list);
    length = LinkListDoubleLength(list);
    return 0;
}
