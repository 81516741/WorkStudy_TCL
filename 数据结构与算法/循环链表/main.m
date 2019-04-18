//
//  main.c
//  循环链表
//
//  Created by lingda on 2019/4/17.
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
typedef Node * CycleLinkList;


int CycleLinkListLength(CycleLinkList list) {
    int length = 0;
    CycleLinkList list0 = list;
    if (list0 == NULL) {
        return length;
    } else {
        length ++;
    }
    while (list->next != list0) {
        list = list->next;
        length ++;
    }
    return length;
}


CycleLinkList CycleLinkListInit() {
    CycleLinkList list = NULL;
    ElemType item;
    CycleLinkList temp;
    CycleLinkList target;
    while (1) {
        printf("请输入:\n");
        scanf("%d",&item);
        if (item == 0) {
            return list;
        }
        if (list == NULL) {
            list = (Node *)malloc(sizeof(CycleLinkList));
            if (!list) {
                exit(0);
            }
            list->data = item;
            list->next = list;
        } else {
            target = list;
            while (target->next != list) {
                target = target->next;
            }
            temp = (Node *)malloc(sizeof(CycleLinkList));
            if (!temp) {
                exit(0);
            }
            temp->data = item;
            target->next = temp;
            temp->next = list;
        }
    }
}

Status CycleLinkListInSet(CycleLinkList * list , int i) {
    if (i > CycleLinkListLength(*list) - 1 || i < 0) {
        exit(0);
        return ERROR;
    }
    CycleLinkList temp;
    CycleLinkList target;
    int item;
    int j = 1;
    printf("请输入要插入的数:\n");
    scanf("%d", &item);
    if(i == 0) {
        temp = (CycleLinkList)malloc(sizeof(CycleLinkList));
        if(!temp) {
            exit(0);
            return ERROR;
        }
        temp ->data = item;
        target = *list;
        while (target->next != *list) {//找到最后一个元素
            target = target->next;
        }
        target->next = temp;
        temp->next = *list;
        *list = temp;
    } else {
        target = *list;
        while (j < i) {
            target=target->next;
            j ++;
        }
        temp = (CycleLinkList)malloc(sizeof(CycleLinkList));
        if(!temp) {
            exit(0);
            return ERROR;
        }
        
        temp ->data = item;
        temp->next = target->next;
        target->next = temp;
    }
    return OK;
}

Status CycleLinkListInDelete(CycleLinkList * list, int i) {
    if (i > CycleLinkListLength(*list) - 1 || i < 0 || list == NULL) {
        return ERROR;
    }
    CycleLinkList target;
    CycleLinkList temp;
    int j = 1;
    if(i == 0) {
        target = *list;
        while (target->next != *list) {//找到最后一个元素
            target = target->next;
        }
        if (CycleLinkListLength(* list) == 1) {
            *list = NULL;
        } else {
            *list = target->next->next;
            free(target->next);
        }
    } else {
        target = *list;
        while (j < i) {
            target=target->next;
            j ++;
        }
        temp = target->next;
        target->next = target->next->next;
        free(temp);
    }
    return OK;
}

Status CycleLinkListGet(CycleLinkList list,ElemType * data) {
    int index;
    printf("请输入要查找的元素的位置\n");
    scanf("%d",&index);
    if (index < 0 || index > CycleLinkListLength(list) - 1 ) {
        return ERROR;
    }
    int i = 0;
    while (index != i) {
        list = list->next;
        i ++;
    }
    * data = list->data;
    printf("找到位置%d的元素：%d",index,list->data);
    printf("\n------------\n");
    return OK;
}
void CycleLinkListPrintAll(CycleLinkList list) {
    if (list == NULL) {
        return;
    }
    CycleLinkList temp = list;
    do {
        printf("%d,",temp->data);
    } while ((temp = temp->next) != list);
    printf("\n");
}

int main(int argc, const char * argv[]) {
    ElemType data;
    CycleLinkList list = CycleLinkListInit();
    CycleLinkListInSet(&list, 2);
    CycleLinkListInDelete(&list, 2);
    CycleLinkListGet(list, &data);
    CycleLinkListPrintAll(list);
    return 0;
}
