subroutine close_tdlpack_file(lun,ftype,ier) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
integer(kind=c_int32_t), intent(in) :: lun
integer(kind=c_int32_t), intent(in) :: ftype
integer(kind=c_int32_t), intent(out) :: ier

! ---------------------------------------------------------------------------------------- 
! Local Variables
! ---------------------------------------------------------------------------------------- 
integer :: ios

! ---------------------------------------------------------------------------------------- 
! Initialize
! ---------------------------------------------------------------------------------------- 
ios=0
ier=0

! ---------------------------------------------------------------------------------------- 
! Close file according to ftype
! ---------------------------------------------------------------------------------------- 
if(ftype.eq.1)then
   ! Random-Access
   call clfilm(kstdout,lun,ier)
elseif(ftype.eq.2)then
   ! Sequential
   close(lun,iostat=ios)
   ier=ios
endif

return
end subroutine close_tdlpack_file
