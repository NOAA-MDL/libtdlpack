module tdlpack_mod
   use iso_c_binding, only: c_int32_t

   implicit none

   ! Parameter definitions
   integer, public, parameter :: tdlp_l3264b = storage_size(1)  ! Size in bits of default integer.
   integer, public, parameter :: tdlp_l3264w = 64 / tdlp_l3264b ! Number of integer words for 64-bits.
   integer, public, parameter :: tdlp_nbypwd = tdlp_l3264b / 8  ! Number of bytes per word.
   integer, public, parameter :: tdlp_byteorder = 1             ! 1 = Big-Endian. TDLPACK files are Big-Endian.
   integer, public, parameter :: tdlp_idlen = 4                 ! Length of TDLPACK MOS-2000 Variable ID.
   integer, public, parameter :: tdlp_max_name = 1024           ! Max length of TDLPACK filenames.
   integer, public, parameter :: tdlp_ra_maxent_small = 300     ! RA Max Entries for "small" template.
   integer, public, parameter :: tdlp_ra_nbytes_small = 2000    ! RA Nbytes for "small" template.
   integer, public, parameter :: tdlp_ra_maxent_large = 840     ! RA Max Entries for "large" template.
   integer, public, parameter :: tdlp_ra_nbytes_large = 20000   ! RA Nbytes for "large" template.

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

   function get_tdlp_max_name() bind(c) result(val)
      integer(kind=c_int32_t) :: val
      val = tdlp_max_name
   end function get_tdlp_max_name

   function get_nd7() bind(c) result(val)
      integer(kind=c_int32_t) :: val
      val = nd7
   end function get_nd7

end module tdlpack_mod
