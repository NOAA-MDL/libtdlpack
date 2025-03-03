module tdlpack_mod
   use iso_c_binding, only: c_int32_t

   implicit none

   ! Parameter definitions
   integer, public, parameter :: l3264b = storage_size(1)
   integer, public, parameter :: l3264w = 64 / l3264b
   integer, public, parameter :: nbypwd = l3264b / 8

   ! Variables that can be accessed from C
   integer(kind=c_int32_t), public, save, bind(C) :: c_l3264b = l3264b
   integer(kind=c_int32_t), public, save, bind(C) :: c_l3264w = l3264w
   integer(kind=c_int32_t), public, save, bind(C) :: c_nbypwd = nbypwd

end module tdlpack_mod
