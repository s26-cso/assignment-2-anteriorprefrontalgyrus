#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node *left;
    struct Node *right;
};

struct Node *make_node(int val);
struct Node *insert(struct Node *root, int val);
struct Node *get(struct Node *root, int val);
int getAtMost(int val, struct Node *root);

static void inorder(const struct Node *root) {
    if (!root) return;
    inorder(root->left);
    printf("%d ", root->val);
    inorder(root->right);
}

static void free_tree(struct Node *root) {
    if (!root) return;
    free_tree(root->left);
    free_tree(root->right);
    free(root);
}

int main(void) {
    struct Node *root = NULL;

    int values[] = {50, 20, 70, 10, 30, 60, 80, 20};
    size_t n = sizeof(values) / sizeof(values[0]);

    for (size_t i = 0; i < n; i++) {
        root = insert(root, values[i]);
    }

    printf("Inorder: ");
    inorder(root);
    printf("\n");

    int queries[] = {10, 30, 55, 80, 999};
    size_t qn = sizeof(queries) / sizeof(queries[0]);

    for (size_t i = 0; i < qn; i++) {
        int x = queries[i];
        struct Node *p = get(root, x);
        printf("get(%d): %s\n", x, p ? "found" : "NULL");
    }

    int atMostTests[] = {-5, 10, 25, 50, 55, 70, 81, 100};
    size_t an = sizeof(atMostTests) / sizeof(atMostTests[0]);

    for (size_t i = 0; i < an; i++) {
        int x = atMostTests[i];
        int ans = getAtMost(x, root);
        printf("getAtMost(%d): %d\n", x, ans);
    }

    free_tree(root);
    return 0;
}
