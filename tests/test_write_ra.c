#include <stdio.h>
#include <stdint.h>
#include "tdlpack.h"

int main()
{
   int32_t kstdout=6;

   printf("Test writing to a small random access file...");
   {
      char name[] = "test_write_ra_char.tdlp";
      char mode[] = "w";
      int32_t byteorder=1; // 1 = Big-Endian
      int32_t filetype=1; // 1 = RA
      int32_t lun=0;
      int32_t ier=0;
      char ra_template[] = "small";
      open_tdlpack_file(&kstdout, name, mode, &lun, &byteorder, &filetype, &ier, ra_template);
      if (ier != 0)
         return ier;

      int32_t id[4];
      int32_t nd5=6;
      char ipack[6][4] = {"KACY", "    ", "KBWI", "    ", "KPHL", "    "};
      int32_t nreplace=0;
      int32_t ncheck=0;

      id[0] = 400001000;
      id[1] = 0;
      id[2] = 0;
      id[3] = 0;

      ier=0;
      write_ra_char(&kstdout, &lun, name, id, &nd5, ipack, &nreplace, &ncheck, &ier);

      ier=0;
      close_tdlpack_file(&kstdout, &lun, &filetype, &ier);
   }
   printf(" SUCCESS!\n");

   return 0;
}
