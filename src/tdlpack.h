#ifndef TDLPACK_H
#define TDLPACK_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void open_log_file(int32_t *kstdout, char *path);

void open_tdlpack_file(int32_t *kstdout, char *file, char *mode, int32_t *lun,
                       int32_t *byteorder, int32_t *ftype, int32_t *ier,
                       char *ra_template);

void unpack_meta_wrapper(int32_t *nd5, int32_t *ipack, int32_t *nd7, int32_t *is0,
                         int32_t *is1, int32_t *is2, int32_t *is4, int32_t *ier);

void unpack_data_wrapper(int32_t *nd5, int32_t *ipack, int32_t *nd7, int32_t *is0,
                         int32_t *is1, int32_t *is2, int32_t *is4, float *data, int32_t *ier);

#ifdef __cplusplus
}
#endif

#endif
