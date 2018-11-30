
#include"k.h"
#ifdef __cplusplus
extern "C"{
#endif

K add(K x,K y) {
    if (x->t != -KJ || y->t != -KJ)
        return krr("type");
    return kj(x->j + y->j);
}

#ifdef __cplusplus
}
#endif



