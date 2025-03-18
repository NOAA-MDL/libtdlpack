#ifndef TDLPACK_H
#define TDLPACK_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif


extern int32_t get_tdlp_l3264b();
#define TDLP_L3264B (get_tdlp_l3264b())
#define TDLP_L3264W (64 / TDLP_L3264B)
#define TDLP_NBYPWD (TDLP_L3264B / 8)

extern int32_t get_tdlp_idlen();
#define TDLP_IDLEN (get_tdlp_idlen())

extern int32_t get_tdlp_max_name();
#define TDLP_MAX_NAME (get_tdlp_max_name())

//extern int32_t ND5;

extern int32_t get_nd7();
#define ND7 (get_nd7())

extern int32_t TDLP_STDOUT_LUN;

void tdlp_close_tdlpack_file(int32_t *lun, int32_t *ftype, int32_t *ier);

void tdlp_open_log_file(int32_t *log_unit, char *log_path);

void tdlp_open_tdlpack_file(char *file, char *mode, int32_t *lun, int32_t *ftype, int32_t *ier,
                            char *ra_template);

void tdlp_pack_1d_wrapper(int32_t *is0, int32_t *is1, int32_t *is2, int32_t *is4, int32_t *nd,
                          float *data, int32_t *nd5, int32_t *ipack, int32_t *ioctet,
                          int32_t *ier);

void tdlp_pack_2d_wrapper(int32_t *is0, int32_t *is1, int32_t *is2, int32_t *is4, int32_t *nx,
                          int32_t *ny, float *data, int32_t *nd5, int32_t *ipack,
                          int32_t *ioctet, int32_t *ier);

void tdlp_read_tdlpack_file(char *file, int32_t *lun, int32_t *ftype, int32_t *nd5, 
                            int32_t *ipack, int32_t *ioctet, int32_t *ier, int32_t *id);

void tdlp_unpack_meta(int32_t *nd5, int32_t *ipack, int32_t *is0, int32_t *is1,
                      int32_t *is2, int32_t *is4, int32_t *ier);

void tdlp_unpack_data(int32_t *nd5, int32_t *ipack, int32_t *is0, int32_t *is1,
                      int32_t *is2, int32_t *is4, float *data, int32_t *ier);

void tdlp_write_station_record(char *file, int32_t *lun, int32_t *ftype, int32_t *nsta, int32_t *nd5,
                               int32_t *ipack, int32_t *ntotby, int32_t *ntotrc, int32_t *ier,
                               int32_t *nreplace, int32_t *ncheck);

void tdlp_write_tdlpack_record(char *file, int32_t *lun, int32_t *ftype, int32_t *nd5,
                               int32_t *ipack, int32_t *ier, int32_t *nreplace, int32_t *ncheck);

void tdlp_write_trailer_record(int32_t *lun, int32_t *ftype, int32_t *ntotby, int32_t *ntotrc, int32_t *ier);

#ifdef __cplusplus
}
#endif

#endif
