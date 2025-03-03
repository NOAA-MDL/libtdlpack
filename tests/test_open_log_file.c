#include <stdio.h>
#include <stdint.h>
#include "tdlpack.h"

int main() {

   int32_t unit=12;
   int32_t unit2=49;

   char log[] = "logfile.txt";

   open_log_file(&unit, log); // Call with a string
   open_log_file(&unit2, NULL); // Call without the string (optional argument)
   return 0;
}
