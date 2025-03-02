subroutine openlog(kstdout,path) bind(c)
use iso_c_binding, only: c_int32_t, c_char, c_null_char
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
integer(kind=c_int32_t), intent(in) :: kstdout
character(kind=c_char), dimension(*), intent(in), optional :: path

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
! Special rule for kstdout=6 which is standard out...just return
! ----------------------------------------------------------------------------------------
if(kstdout.eq.6)return

! ---------------------------------------------------------------------------------------- 
! Open log file accordingly.
! ---------------------------------------------------------------------------------------- 
if(present(path))then
   i=1
   do
      if(path(i).eq.c_null_char)exit
      f_path=f_path//path(i)
      i=i+1
   end do
   open(unit=kstdout,file=f_path,form="formatted",status="replace",iostat=ios)
else
   open(unit=kstdout,form="formatted",iostat=ios)
endif

return
end subroutine openlog
