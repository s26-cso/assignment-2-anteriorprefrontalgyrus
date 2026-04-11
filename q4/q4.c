#include <dlfcn.h>
#include <stdio.h>
#include <string.h>

typedef int (*op_fn_t)(int, int);

int main(void)
{
    char op[6] = {0};
    int a = 0;
    int b = 0;

    char line[256];
    while (fgets(line, sizeof(line), stdin) != NULL)
    {
        op[0] = '\0';
        if (sscanf(line, "%5s %d %d", op, &a, &b) != 3)
            continue;

        char libname[64];
        snprintf(libname, sizeof(libname), "./lib%s.so", op);

        void *handle = dlopen(libname, RTLD_NOW | RTLD_LOCAL);
        if (!handle) 
            continue;

        dlerror(); 

        op_fn_t fn = (op_fn_t)dlsym(handle, op);
        
        const char *dlsym_error = dlerror();
        if (dlsym_error != NULL || fn == NULL)
        {
            dlclose(handle);
            continue;
        }

        int out = fn(a, b);
        printf("%d\n", out);
        dlclose(handle);
    }

    return 0;
}
