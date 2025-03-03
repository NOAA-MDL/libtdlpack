subroutine write_sq_station_record(kfildo,kfilio,nd5,ipack,ntotby,ntotrc,ier) bind(c)
use iso_c_binding, only: c_int32_t, c_char, c_null_char
use tdlpack_mod
implicit none

! ----------------------------------------------------------------------------------------
! Input/Output Variables
! ----------------------------------------------------------------------------------------
integer(kind=c_int32_t), intent(in) :: kfildo
integer(kind=c_int32_t), intent(in) :: kfilio
integer(kind=c_int32_t), intent(in) :: nd5
character(kind=c_char), intent(in), dimension(8,nd5) :: ipack
integer(kind=c_int32_t), intent(inout) :: ntotby
integer(kind=c_int32_t), intent(inout) :: ntotrc
integer(kind=c_int32_t), intent(out) :: ier

! ----------------------------------------------------------------------------------------
! Local Variables
! ----------------------------------------------------------------------------------------
integer :: n,ios,nbytes,ntrash

! ----------------------------------------------------------------------------------------
! Initialize
! ----------------------------------------------------------------------------------------
ier=0
ios=0
nbytes=nd5*8
ntrash=0

! ----------------------------------------------------------------------------------------
! Update bytes and records totals
! ----------------------------------------------------------------------------------------
ntotby=ntotby+nbytes
ntotrc=ntotrc+1

! ----------------------------------------------------------------------------------------
! Write according to l3264b
! ----------------------------------------------------------------------------------------
if(l3264b.eq.32)then
   write(kfilio,iostat=ios)ntrash,nbytes,(ipack(:,n),n=1,nd5)
elseif(l3264b.eq.64)then
   write(kfilio,iostat=ios)nbytes,(ipack(:,n),n=1,nd5)
endif
ier=ios

return
end subroutine write_sq_station_record
