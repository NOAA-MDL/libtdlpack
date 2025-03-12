#include <stddef.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "tdlpack.h"

#define ERROR -1
#define NCHAR 8

void int_to_char_string(int32_t *ipack, int index, char *string)
{
   string[0] = (ipack[index] >> 24) & 0xFF;
   string[1] = (ipack[index] >> 16) & 0xFF;
   string[2] = (ipack[index] >>  8) & 0xFF;
   string[3] = (ipack[index] >>  0) & 0xFF;
}

int main()
{
   char name[] = "test_write_ra_stations.tdlp";
   int32_t filetype = 1; // 1 = RA

   printf("Test writing stations and data to a small random access file\n");
   {
      // Open new file.
      char mode[] = "w";
      int32_t lun=0;
      int32_t ier;
      char ra_template[] = "small";

      printf("Opening new TDLPACK random access file for writing...");
      ier = 0;
      open_tdlpack_file(name, mode, &lun, &filetype, &ier, ra_template);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");

      // Write station call letter record.
      int32_t id[4];
      int32_t nsta=3;
      int32_t nd5=(nsta*NCHAR)/TDLP_NBYPWD;
      char stations[3][NCHAR] = {"KACY    ", "KBWI    ", "KPHL    "};
      int32_t *ipack;
      int32_t ntotby=0;
      int32_t ntotrc=0;
      int32_t nreplace=0;
      int32_t ncheck=0;

      // Put station call letter strings into ipack
      ipack = malloc(nd5*TDLP_NBYPWD);
      for (int i = 0; i < nsta; i++)
      {
         memcpy(&ipack[i*2], stations[i], NCHAR/2);
         memcpy(&ipack[i*2+1], stations[i]+(NCHAR/2), NCHAR/2);
      }

      id[0] = 400001000;
      id[1] = 0;
      id[2] = 0;
      id[3] = 0;

      printf("Writing station call letter record...");
      ier=0;
      write_station_record(name, &lun, &filetype, &nsta, &nd5, ipack, &ntotby, &ntotrc, &ier, &nreplace, &ncheck);
      printf("ier = %d\n", ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");

      free(ipack);

      // Create data.
      int32_t is0[ND7];
      int32_t is1[ND7];
      int32_t is2[ND7];
      int32_t is4[ND7];
      int32_t nd = 3;
      float data[3] = {30.0, 33.0, 34.0};
      int32_t nd5_data = 1000;
      int32_t ioctet = 0;

      memset(&is0, 0, ND7*sizeof(int32_t));
      memset(&is1, 0, ND7*sizeof(int32_t));
      memset(&is2, 0, ND7*sizeof(int32_t));
      memset(&is4, 0, ND7*sizeof(int32_t));
      ipack = malloc(nd5_data);

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
      pack_1d_wrapper(is0, is1, is2, is4, &nd, data, &nd5_data, ipack, &ioctet, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\tioctet = %d\n", ioctet);

      // Write TDLPACK record.
      printf("Writing TDLPACK data record...");
      ier = 0;
      nd5_data = ioctet / TDLP_NBYPWD; // IMPORTANT: different than the original value.
      write_tdlpack_record(name, &lun, &filetype, &nd5_data, ipack, &ier, &nreplace, &ncheck);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");

      free(ipack);

      // Close the TDLPACK file.
      printf("Closing random-access file...");
      ier=0;
      close_tdlpack_file(&lun, &filetype, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
   }

// ----------------------------------------------------------------------------------------
// Now open the file and re-read.
// ----------------------------------------------------------------------------------------

   printf("Test reading random-access file.\n");
   {
      // Open file
      char mode[] = "r";
      int32_t lun;
      int32_t ier;

      printf("Opening TDLPACK random-access file for reading...");
      lun = 0;
      filetype = 0;
      ier = 0;
      open_tdlpack_file(name, mode, &lun, &filetype, &ier, NULL);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t Fortran unit number = %d\n", lun);
      printf("\t File type = %d\n", filetype);

      // Read first record
      int32_t nd5 = 1000; // Enough to size ipack
      int32_t *ipack;
      int32_t id[4];
      int32_t ioctet = 0;
      char station[6];

      ipack = malloc(nd5*TDLP_NBYPWD);

      id[0] = 400001000;
      id[1] = 0;
      id[2] = 0;
      id[3] = 0;

      printf("Reading first record...");
      ier = 0;
      read_tdlpack_file(name, &lun, &filetype, &nd5, ipack, &ioctet, &ier, id);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t Size of record, ioctet = %d\n", ioctet);

      for (int i=0; i < ioctet/TDLP_NBYPWD; i++)
      {
         int_to_char_string(ipack, i, station);
         printf("station = %s\n", station);
      }

      free(ipack);
      ipack = malloc(nd5*TDLP_NBYPWD);

      id[0] = 9999;
      id[1] = 0;
      id[2] = 0;
      id[3] = 0;

      // Read second record
      printf("Reading second record...");
      ier = 0;
      ioctet = 0;
      read_tdlpack_file(name, &lun, &filetype, &nd5, ipack, &ioctet, &ier, id);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t Size of record, ioctet = %d\n", ioctet);

      // Unpack the second record.
      int32_t is0[ND7];
      int32_t is1[ND7];
      int32_t is2[ND7];
      int32_t is4[ND7];
      float data[nd5];

      memset(&is0, 0, ND7*sizeof(int32_t));
      memset(&is1, 0, ND7*sizeof(int32_t));
      memset(&is2, 0, ND7*sizeof(int32_t));
      memset(&is4, 0, ND7*sizeof(int32_t));
      memset(&data, 0, nd5*sizeof(float));

      printf("Unpacking the data record...");
      ier = 0;
      unpack_data(&nd5, ipack, is0, is1, is2, is4, data, &ier);
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

      free(ipack);
      ipack = malloc(nd5*TDLP_NBYPWD);

      // TRY to read again, but should get EOF
      printf("Try to read again (should get EOF)...");
      ier = 0;
      ioctet = 0;
      read_tdlpack_file(name, &lun, &nd5, &filetype, &ioctet, ipack, &ier, id);
      if (ier == 0)
         return ier;
      printf(" SUCCESS!\n");
      printf("\t ier = %d\n", ier);

      free(ipack);

      // Close file.
      printf("Closing TDLPACK file...");
      ier = 0;
      close_tdlpack_file(&lun, &filetype, &ier);
      if (ier != 0)
         return ier;
      printf(" SUCCESS!\n");
   }

   return 0;
}
