#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "tdlpack.h"

#define ERROR -1

void int_to_char_string(int32_t *ipack, int index, char *string)
{
   string[0] = (ipack[index] >> 24) & 0xFF;
   string[1] = (ipack[index] >> 16) & 0xFF;
   string[2] = (ipack[index] >>  8) & 0xFF;
   string[3] = (ipack[index] >>  0) & 0xFF;
}

int main()
{
   int32_t kstdout=6;
   char name[] = "test_write_sq_stations.tdlp";
   int32_t byteorder = 1; // 1 = Big-Endian
   int32_t filetype = 2; // 2 = SQ

   printf("Test writing stations and data to a sequential file\n");
   {
      char mode[] = "w";
      int32_t lun = 0;
      int32_t ier;

      printf("Opening TDLPACK file for writing...");
      ier = 0;
      open_tdlpack_file(&kstdout, name, mode, &lun, &byteorder, &filetype, &ier, NULL);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");

      // Write station record.
      int32_t nd5 = 3;
      char cpack[3][8] = {"KACY    ", "KBWI    ", "KPHL    "};
      int32_t ntotby = 0;
      int32_t ntotrc = 0;

      printf("Writing Station call letter record...");
      ier = 0;
      write_sq_station_record(&kstdout, &lun, &nd5, cpack, &ntotby, &ntotrc, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\tTotal number of bytes written: %d\n", ntotby);
      printf("\tTotal number of records written: %d\n", ntotrc);

      // Create data.
      int32_t nd7 = 54;
      int32_t is0[nd7] = {};
      int32_t is1[nd7] = {};
      int32_t is2[nd7] = {};
      int32_t is4[nd7] = {};
      int32_t nd = 3;
      float data[3] = {30.0, 33.0, 34.0};
      int32_t nd5_data = 1000;
      int32_t ipack[nd5_data] = {};
      int32_t ioctet = 0;

      is1[0] = 0;
      is1[1] = 0;
      is1[2] = 2024;
      is1[3] = 12;
      is1[4] = 25;
      is1[5] = 12;
      is1[6] = 0;
      is1[7] = 2024122512;
      is1[8] = 702000000;
      is1[9] = 0;
      is1[10] = 0;
      is1[11] = 0;
      is1[12] = 0;
      is1[13] = 0;
      is1[14] = 0;
      is1[15] = 0;
      is1[16] = 0;
      is1[17] = 0;
      is1[18] = 0;
      is1[19] = 0;
      is1[20] = 0;
      is1[21] = 16; // Number of plain language characters
      is1[22] = 32; // ' '
      is1[23] = 79; // 'O'
      is1[24] = 66; // 'B'
      is1[25] = 83; // 'S'
      is1[26] = 32; // ' '
      is1[27] = 84; // 'T'
      is1[28] = 69; // 'E'
      is1[29] = 77; // 'M'
      is1[30] = 80; // 'P'
      is1[31] = 69; // 'E'
      is1[32] = 82; // 'R'
      is1[33] = 65; // 'A'
      is1[34] = 84; // 'T'
      is1[35] = 85; // 'U'
      is1[36] = 82; // 'R'
      is1[37] = 69; // 'E'

      is4[1] = 26;
      is4[3] = 9999;

      // Pack data.
      printf("Packing station data into TDLPACK...");
      ier = 0;
      pack_1d_wrapper(&nd7, is0, is1, is2, is4, &nd, data, &nd5_data, ipack, &ioctet, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\tioctet = %d\n", ioctet);

      // Write TDLPACK record.
      printf("Writing TDLPACK data record...");
      ier = 0;
      nd5_data = ioctet / c_nbypwd; // IMPORTANT: different than the original value.
      write_tdlpack_file(&kstdout, name, &lun, &filetype, &nd5_data, ipack, &ier, NULL, NULL);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");

      // Write trailer record
      printf("Writing trailer record...");
      ier = 0;
      trail(&kstdout, &lun, &c_l3264b, &c_l3264w, &ntotby, &ntotrc, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");

      // Close file.
      printf("Closing TDLPACK file...");
      ier = 0;
      close_tdlpack_file(&kstdout, &lun, &filetype, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
   }
// ----------------------------------------------------------------------------------------
// Now open the file and re-read.
// ----------------------------------------------------------------------------------------
   printf("Test reading sequential file.\n");
   {
      // Open file
      char mode[] = "r";
      int32_t lun = 0;
      int32_t ier;

      printf("Opening TDLPACK file for reading...");
      lun = 0;
      byteorder = 0;
      filetype = 0;
      ier = 0;
      open_tdlpack_file(&kstdout, name, mode, &lun, &byteorder, &filetype, &ier, NULL);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t Fortran unit number = %d\n", lun);
      printf("\t Byte order = %d\n", byteorder);
      printf("\t File type = %d\n", filetype);

      // Read first record
      int32_t nd5 = 1000; // Enough to size ipack
      int32_t ipack[nd5] = {};
      int32_t ioctet = 0;
      char station[6] = {};

      printf("Reading first record...");
      ier = 0;
      read_tdlpack_file(&kstdout, name, &lun, &nd5, &filetype, &ioctet, ipack, &ier, NULL);
      if (ier != 0)
         return ier;
      if (ioctet != 24)
         return ERROR;
      printf(" SUCCESS!\n");
      printf("\t Size of record, ioctet = %d\n", ioctet);

      //for (int i=0; i < ioctet/c_nbypwd; i++)
      //{
      //   int_to_char_string(ipack, i, station);
      //   printf("station = %s\n", station);
      //}

      // Read second record
      printf("Reading second record...");
      ier = 0;
      read_tdlpack_file(&kstdout, name, &lun, &nd5, &filetype, &ioctet, ipack, &ier, NULL);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t Size of record, ioctet = %d\n", ioctet);

      // Unpack the second record.
      int32_t nd7 = 54;
      int32_t is0[nd7] = {};
      int32_t is1[nd7] = {};
      int32_t is2[nd7] = {};
      int32_t is4[nd7] = {};
      float data[nd5] = {};

      printf("Unpacking the data record...");
      ier = 0;
      unpack_data_wrapper(&nd5, ipack, &nd7, is0, is1, is2, is4, data, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t Size of record, ioctet = %d\n", ioctet);
      printf("\t TDLPACK Section 0, is0 = [");
      for (int i=0; i < 3; i++)
         printf("%d ", is0[i]);
      printf("]\n");
      printf("\t TDLPACK Section 1, is1 = [");
      for (int i=0; i < 54; i++)
         printf("%d ", is1[i]);
      printf("]\n");
      printf("\t TDLPACK Section 4, is4 = [");
      for (int i=0; i < 7; i++)
         printf("%d ", is4[i]);
      printf("]\n");
      printf("\t TDLPACK data = [");
      for (int i=0; i < 3; i++)
         printf("%f ", data[i]);
      printf("]\n");

      // Read third record (trailer)
      printf("Reading third record...");
      ier = 0;
      read_tdlpack_file(&kstdout, name, &lun, &nd5, &filetype, &ioctet, ipack, &ier, NULL);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t Size of record, ioctet = %d\n", ioctet);
      printf("\t ipack[0] = %d\n", ipack[0]);

      // TRY to read again, but should get EOF
      printf("Try to read again (should get EOF)...");
      ier = 0;
      read_tdlpack_file(&kstdout, name, &lun, &nd5, &filetype, &ioctet, ipack, &ier, NULL);
      if (ier == 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t ier = %d\n", ier);

      // Close file.
      printf("Closing TDLPACK file...");
      ier = 0;
      close_tdlpack_file(&kstdout, &lun, &filetype, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
   }
   return 0;
}
