#include <stddef.h>
#include <stdio.h>
#include <stdint.h>
#include "tdlpack.h"

int main()
{
   printf("Test creating a small-template random access file...");
   {
      char name[] = "test_open_ra_small.tdlp";
      char mode[] = "w";
      int32_t filetype=1; // 1 = RA
      int32_t lun=0;
      int32_t ier=0;
      char ra_template[] = "small";
      open_tdlpack_file(name, mode, &lun, &filetype, &ier, ra_template);
      if (ier != 0)
         return ier;
   }
   printf(" SUCCESS!\n");
   printf("Test creating a large-template random access file...");
   {
      char name[] = "test_open_ra_large.tdlp";
      char mode[] = "w";
      int32_t filetype=1; // 1 = RA
      int32_t lun=0;
      int32_t ier=0;
      char ra_template[] = "large";
      open_tdlpack_file(name, mode, &lun, &filetype, &ier, ra_template);
      if (ier != 0)
         return ier;
   }
   printf(" SUCCESS!\n");
   printf("Test creating a sequential file...");
   {
      char name[] = "test_open_sq.tdlp";
      char mode[] = "w";
      int32_t filetype=2; // 2 = SQ
      int32_t lun=0;
      int32_t ier=0;
      open_tdlpack_file(name, mode, &lun, &filetype, &ier, NULL);
      if (ier != 0)
         return ier;
   }
   printf(" SUCCESS!\n");

   return 0;
}
