#ifndef TDLPACK_H
#define TDLPACK_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif


void unpack_meta_wrapper(c_int32_t *nd5, c_int32_t *ipack, c_int32_t *nd7, c_int32_t *is0,
                         c_int32_t *is1, c_int32_t *is2, c_int32_t *is4, c_int32_t *ier)

void unpack_data_wrapper(c_int32_t *nd5, c_int32_t *ipack, c_int32_t *nd7, c_int32_t *is0,
                         c_int32_t *is1, c_int32_t *is2, c_int32_t *is4, float *data, c_int32_t *ier)


#ifdef __cplusplus
}
#endif

#endif
