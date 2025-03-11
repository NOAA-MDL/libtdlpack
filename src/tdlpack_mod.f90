module tdlpack_mod
   use iso_c_binding, only: c_int32_t

   implicit none

   ! Parameter definitions
   integer, public, parameter :: tdlp_l3264b = storage_size(1)
   integer, public, parameter :: tdlp_l3264w = 64 / tdlp_l3264b
   integer, public, parameter :: tdlp_nbypwd = tdlp_l3264b / 8
   integer, public, parameter :: tdlp_byteorder = 1 ! 1 = Big-Endian. TDLPACK files are Big-Endian.
   integer, public, parameter :: tdlp_idlen = 4 ! Length of TDLPACK MOS-2000 Variable ID.

   ! Traditional MOS2K "ND"
   integer(kind=c_int32_t), public, save, bind(C,name="ND5") :: tdlp_nd5 = 20971520 / tdlp_nbypwd ! Default size 
   integer, public, parameter :: nd7 = 54 ! Size of IS*( ) arrays.

   ! Variables that can be shared between C and Fortran
   integer(kind=c_int32_t), public, save, bind(C,name="TDLP_STDOUT_LUN") :: kstdout=6

contains

   function get_tdlp_idlen() bind(c) result(val)
      integer(kind=c_int32_t) :: val
      val = tdlp_idlen
   end function get_tdlp_idlen

   function get_tdlp_l3264b() bind(c) result(val)
      integer(kind=c_int32_t) :: val
      val = tdlp_l3264b
   end function get_tdlp_l3264b

   function get_nd7() bind(c) result(val)
      integer(kind=c_int32_t) :: val
      val = nd7
   end function get_nd7

end module tdlpack_mod
