#define _CRT_SECURE_NO_WARNINGS


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_USERS 10
#define MAX_NAME_LENGTH 20
#define MAX_PASSWORD_LENGTH 20
#define MAX_QUESTION_LENGTH 100
#define MAX_ANSWER_LENGTH 20

typedef struct {
    char name[MAX_NAME_LENGTH];
    char password[MAX_PASSWORD_LENGTH];
    int is_registered;
    char security_question[MAX_QUESTION_LENGTH];
    char security_answer[MAX_ANSWER_LENGTH];
} user_t;

user_t users[MAX_USERS];
int num_users = 0;

void register_user() {
    if (num_users == MAX_USERS) {
        printf("Maximum number of users reached. Cannot register new user.\n");
        return;
    }

    char name[MAX_NAME_LENGTH];
    char password[MAX_PASSWORD_LENGTH];
    char question[MAX_QUESTION_LENGTH];
    char answer[MAX_ANSWER_LENGTH];

    printf("Enter your name: ");
    scanf("%s", name);

    for (int i = 0; i < num_users; i++) {
        if (strcmp(name, users[i].name) == 0) {
            printf("User with this name already exists. Please choose a different name.\n");
            return;
        }
    }

    printf("Enter your password: ");
    scanf("%s", password);

    printf("Enter your security question: ");
    scanf(" %[^\n]s", question);

    printf("Enter your security answer: ");
    scanf("%s", answer);

    strcpy(users[num_users].name, name);
    strcpy(users[num_users].password, password);
    users[num_users].is_registered = 1;
    strcpy(users[num_users].security_question, question);
    strcpy(users[num_users].security_answer, answer);

    printf("User successfully registered!\n");

    num_users++;
}

int login_user() {
    char name[MAX_NAME_LENGTH];
    char password[MAX_PASSWORD_LENGTH];

    printf("Enter your name: ");
    scanf("%s", name);

    printf("Enter your password: ");
    scanf("%s", password);

    for (int i = 0; i < num_users; i++) {
        if (strcmp(name, users[i].name) == 0 && strcmp(password, users[i].password) == 0) {
            printf("Login successful!\n");
            return i;
        }
    }

    printf("Login failed. Incorrect name or password.\n");
    return -1;
}

void recover_password() {
    char name[MAX_NAME_LENGTH];
    char answer[MAX_ANSWER_LENGTH];

    printf("Enter your name: ");
    scanf("%s", name);

    int user_index = -1;
    for (int i = 0; i < num_users; i++) {
        if (strcmp(name, users[i].name) == 0) {
            user_index = i;
            break;
        }
    }

    if (user_index == -1 || !users[user_index].is_registered) {
        printf("User not found or not registered.\n");
        return;
    }

    printf("%s\n", users[user_index].security_question);

    printf("Enter your security answer: ");
    scanf("%s", answer);

    if (strcmp(answer, users[user_index].security_answer) == 0) {
        printf("Your password is: %s\n", users[user_index].password);
    }
    else {
        printf("Incorrect security answer.\n");
    }
}

void save_users() {
    FILE* fp = fopen("users.txt", "w");
    if (fp == NULL) {
        printf("Error: could not open file for writing.\n");
        return;
    }

    for (int i = 0; i < num_users; i++) {
        fprintf(fp, "%s %s %d %s %s\n", users[i].name, users[i].password, users[i].is_registered, users[i].security_question, users[i].security_answer);
    }

    fclose(fp);
}

void load_users() {
    FILE* fp = fopen("users.txt", "r");
    if (fp == NULL) {
        printf("No saved users found.\n");
        return;
    }

    num_users = 0;
    while (fscanf(fp, "%s %s %d %s %s\n", users[num_users].name, users[num_users].password, &users[num_users].is_registered, users[num_users].security_question, users[num_users].security_answer) == 5) {
        num_users++;
    }

    fclose(fp);
}

int main() {
    printf("Welcome to the login system.\n");

    load_users();

    int choice = -1;
    while (choice != 0) {
        printf("Enter 1 to register\nEnter 2 to login\nEnter 3 to recover password\nEnter 0 to exit: ");
        scanf("%d", &choice);
        switch (choice) {
        case 1:
            register_user();
            break;
        case 2:
        {
            int user_index = login_user();
            if (user_index != -1) {
                printf("Welcome, %s!\n", users[user_index].name);
            }
        }
        break;
        case 3:
            recover_password();
            break;
        case 0:
            printf("Exiting...\n");
            break;
        default:
            printf("Invalid choice. Please try again.\n");
            break;
        }

        save_users();
    }

    return 0;
}
