subroutine tdlp_write_trailer_record(lun,ftype,ntotby,ntotrc,ier) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t
implicit none

! ----------------------------------------------------------------------------------------
! Input/Output Variables
! ----------------------------------------------------------------------------------------
integer(kind=c_int32_t), intent(in) :: lun
integer(kind=c_int32_t), intent(in) :: ftype
integer(kind=c_int32_t), intent(inout) :: ntotby
integer(kind=c_int32_t), intent(inout) :: ntotrc
integer(kind=c_int32_t), intent(out) :: ier

! ----------------------------------------------------------------------------------------
! Initialize
! ----------------------------------------------------------------------------------------
ier=0

! ----------------------------------------------------------------------------------------
! Do nothing is file type = 1 (random-access)
! ----------------------------------------------------------------------------------------
if(ftype.eq.1)return

! ----------------------------------------------------------------------------------------
! Call trail
! ----------------------------------------------------------------------------------------
call trail(kstdout,lun,TDLP_L3264B,TDLP_L3264W,ntotby,ntotrc,ier)

return
end subroutine tdlp_write_trailer_record
