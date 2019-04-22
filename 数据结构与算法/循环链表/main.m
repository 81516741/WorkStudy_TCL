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


CycleLinkList CycleLinkListInit(int capacity) {
    CycleLinkList list = NULL;
    ElemType item = 0;
    CycleLinkList temp;
    CycleLinkList target;
    while (1) {
        if (capacity < 0) {
            printf("请输入:\n");
            scanf("%d",&item);
            if (item == 0) {
                return list;
            }
        } else {
            capacity--;
            item ++;
            if (capacity == -1) {
                return list;
            }
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

Status CycleLinkListInSet(CycleLinkList * list , int i,ElemType data) {
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
void CycleLinkListSetAllValue(CycleLinkList * list,ElemType value) {
    CycleLinkList temp = *list;
    while (temp->next != *list) {
        temp->data = value;
        temp = temp->next;
    }
    temp->data = value;
}
void yusefu(int capacity) {
    printf("约瑟夫问题\n");
    int count = 3;
    CycleLinkList list = CycleLinkListInit(capacity);
    CycleLinkList temp;
    while (list != list->next) {
        for (int i = 0; i<count-2; i++) {
            list = list->next;
        }
        temp = list->next;
        printf("干掉:%d\n",temp->data);
        list->next = list->next->next;
        list = list->next;
        free(temp);
    }
    printf("活下来:%d\n",list->data);
}

void moshushi(int capacity) {
//    1,8,2,5,10,3,12,11,9,4,7,6,13,
    printf("魔术师发牌问题\n");
    CycleLinkList list = CycleLinkListInit(capacity);
    CycleLinkListSetAllValue(&list, 0);
    int count = 1;
    CycleLinkList temp = list;
    temp->data = count;
    count ++;
    while (1) {
        for (int i = 0; i < count; i ++) {
            temp = temp->next;
            if (temp->data != 0) {
                i--;
            }
        }
        temp->data = count;
        count ++;
        if (count == capacity + 1) {
            break;
        }
    }
    CycleLinkListPrintAll(list);
}

void ladingfangzheng(int n) {
    printf("拉丁方正问题\n");
    CycleLinkList list = CycleLinkListInit(n);
    CycleLinkList temp = list;
    int count = n;
    while (count) {
        for (int i = 0; i < n; i++) {
            printf("%d ",temp->data);
            temp = temp->next;
        }
        printf("\n");
        list = list->next;
        temp = list;
        count--;
    }
}

int main(int argc, const char * argv[]) {
//    ElemType data;
//    CycleLinkList list = CycleLinkListInit(-1);
//    CycleLinkListInSet(&list, 2,0);
//    CycleLinkListInDelete(&list, 2);
//    CycleLinkListGet(list, &data);
//    CycleLinkListPrintAll(list);
//    yusefu(41);
//    moshushi(13);
    ladingfangzheng(9);
    return 0;
}


