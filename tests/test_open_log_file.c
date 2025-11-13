#include <stddef.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "tdlpack.h"

int main(int argc, char *argv[])
{

   int32_t unit = 12;
   int32_t unit2 = 0;

   char *libtype = argv[1];
   char *log = argv[2];
   tdlp_open_log_file(&unit, log); // Call with a string

   if (strcmp(libtype, "shared") == 0)
      unit2 = 49;
   if (strcmp(libtype, "static") == 0)
      unit2 = 50;
   tdlp_open_log_file(&unit2, NULL); // Call without the string (optional argument)

   return 0;
}
