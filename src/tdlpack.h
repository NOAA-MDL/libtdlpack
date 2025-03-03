#ifndef TDLPACK_H
#define TDLPACK_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

extern int32_t c_l3264b;
extern int32_t c_l3264w;
extern int32_t c_nbypwd;

void close_tdlpack_file(int32_t *kstdout, int32_t *lun, int32_t *ftype, int32_t *ier);

void open_log_file(int32_t *kstdout, char *path);

void open_tdlpack_file(int32_t *kstdout, char *file, char *mode, int32_t *lun,
                       int32_t *byteorder, int32_t *ftype, int32_t *ier,
                       char *ra_template);

void trail(int32_t *kfildo, int32_t *kfilio, int32_t *l3264b, int32_t *l3264w,
           int32_t *ntotby, int32_t *ntotrc, int32_t *ier);

void unpack_meta_wrapper(int32_t *nd5, int32_t *ipack, int32_t *nd7, int32_t *is0,
                         int32_t *is1, int32_t *is2, int32_t *is4, int32_t *ier);

void unpack_data_wrapper(int32_t *nd5, int32_t *ipack, int32_t *nd7, int32_t *is0,
                         int32_t *is1, int32_t *is2, int32_t *is4, float *data, int32_t *ier);

void write_ra(int32_t *kfildo, int32_t *kfilx, char *cfilx, int32_t id[4], int32_t *nd5,
              int32_t *ipack, int32_t *nrepla, int32_t *ncheck, int32_t *ier);

void write_ra_char(int32_t *kfildo, int32_t *kfilx, char *cfilx, int32_t id[4], int32_t *nd5,
              	   char ipack[][4], int32_t *nrepla, int32_t *ncheck, int32_t *ier);

void write_sq_station_record(int32_t *kfildo, int32_t *kfilio, int32_t *nd5, char ipack[][8],
                             int32_t *ntotby, int32_t *ntotrc, int32_t *ier);

#ifdef __cplusplus
}
#endif

#endif
