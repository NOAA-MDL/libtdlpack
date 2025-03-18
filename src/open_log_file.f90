subroutine tdlp_open_log_file(log_unit,log_path) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t, c_char, c_null_char
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
integer(kind=c_int32_t), intent(in) :: log_unit
character(kind=c_char), dimension(*), intent(in), optional :: log_path

! ---------------------------------------------------------------------------------------- 
! Local Variables
! ---------------------------------------------------------------------------------------- 
character(len=:), allocatable :: f_path
integer :: i,ios

! ---------------------------------------------------------------------------------------- 
! Initialize
! ---------------------------------------------------------------------------------------- 
ios=0
f_path=""

! ----------------------------------------------------------------------------------------
! Special rule for log_unit=6 which is standard out...just return
! ----------------------------------------------------------------------------------------
if(log_unit.eq.6)then
   return
endif

! ---------------------------------------------------------------------------------------- 
! Open log file accordingly.
! ---------------------------------------------------------------------------------------- 
if(present(log_path))then
   i=1
   do
      if(log_path(i).eq.c_null_char)exit
      f_path=f_path//log_path(i)
      i=i+1
   end do
   open(unit=log_unit,file=f_path,form="formatted",status="replace",iostat=ios)
else
   open(unit=log_unit,form="formatted",iostat=ios)
endif

if(ios.ne.0)then
   write(6,fmt='(A,I2,A,I2)')" Error opening file on Fortran unit = ",log_unit,&
                           ", iostat = ",ios
endif

return
end subroutine tdlp_open_log_file
