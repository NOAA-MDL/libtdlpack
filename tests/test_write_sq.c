#include <stdio.h>
#include <stdint.h>
#include "tdlpack.h"

int main()
{
   int32_t kstdout=6;

   printf("Test writing stations to a sequential file...");
   {
      char name[] = "test_write_sq_stations.tdlp";
      char mode[] = "w";
      int32_t byteorder=1; // 1 = Big-Endian
      int32_t filetype=2; // 2 = SQ
      int32_t lun=0;
      int32_t ier=0;
      open_tdlpack_file(&kstdout, name, mode, &lun, &byteorder, &filetype, &ier, NULL);
      if (ier != 0)
         return ier;

      int32_t nd5=3;
      char ipack[3][8] = {"KACY    ", "KBWI    ", "KPHL    "};
      int32_t ntotby=0;
      int32_t ntotrc=0;

      ier=0;
      write_sq_station_record(&kstdout, &lun, &nd5, ipack, &ntotby, &ntotrc, &ier);

      ier=0;
      trail(&kstdout, &lun, &c_l3264b, &c_l3264w, &ntotby, &ntotrc, &ier);
   }
   printf(" SUCCESS!\n");

   return 0;
}
