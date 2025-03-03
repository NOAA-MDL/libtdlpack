subroutine write_ra(kfildo,kfilx,cfilx,id,nd5,ipack,nrepla,ncheck,ier) bind(c)
use iso_c_binding, only: c_int32_t, c_char, c_null_char
use tdlpack_mod
implicit none

! ----------------------------------------------------------------------------------------
! Input/Output Variables
! ----------------------------------------------------------------------------------------
integer(kind=c_int32_t), intent(in) :: kfildo
integer(kind=c_int32_t), intent(in) :: kfilx
character(kind=c_char), dimension(*), intent(in) :: cfilx
integer(kind=c_int32_t), intent(in), dimension(4) :: id
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(in), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(in) :: nrepla
integer(kind=c_int32_t), intent(in) :: ncheck
integer(kind=c_int32_t), intent(out) :: ier

! ----------------------------------------------------------------------------------------
! Local Variables
! ----------------------------------------------------------------------------------------
character(len=:), allocatable :: f_cfilx
integer :: i

! ----------------------------------------------------------------------------------------
! Initialize
! ----------------------------------------------------------------------------------------
ier=0

f_cfilx=""
i=1
do
   if(cfilx(i).eq.c_null_char)exit
   f_cfilx=f_cfilx//cfilx(i)
   i=i+1
end do

! ----------------------------------------------------------------------------------------
! Call WRTDLM
! ----------------------------------------------------------------------------------------
call wrtdlm(kfildo,kfilx,f_cfilx,id,ipack,nd5,nrepla,ncheck,l3264b,ier)

return
end subroutine write_ra
! ----------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------
subroutine write_ra_char(kfildo,kfilx,cfilx,id,nd5,ipack,nrepla,ncheck,ier) bind(c)
use iso_c_binding, only: c_int32_t, c_char, c_null_char
use tdlpack_mod
implicit none

! ----------------------------------------------------------------------------------------
! Input/Output Variables
! ----------------------------------------------------------------------------------------
integer(kind=c_int32_t), intent(in) :: kfildo
integer(kind=c_int32_t), intent(in) :: kfilx
character(kind=c_char), dimension(*), intent(in) :: cfilx
integer(kind=c_int32_t), intent(in), dimension(4) :: id
integer(kind=c_int32_t), intent(in) :: nd5
character(kind=c_char), intent(in), dimension(4,nd5) :: ipack
integer(kind=c_int32_t), intent(in) :: nrepla
integer(kind=c_int32_t), intent(in) :: ncheck
integer(kind=c_int32_t), intent(out) :: ier

! ----------------------------------------------------------------------------------------
! Local Variables
! ----------------------------------------------------------------------------------------
character(len=:), allocatable :: f_cfilx
integer :: i

! ----------------------------------------------------------------------------------------
! Initialize
! ----------------------------------------------------------------------------------------
ier=0

f_cfilx=""
i=1
do
   if(cfilx(i).eq.c_null_char)exit
   f_cfilx=f_cfilx//cfilx(i)
   i=i+1
end do

! ----------------------------------------------------------------------------------------
! Call WRTDLM
! ----------------------------------------------------------------------------------------
call wrtdlmc(kfildo,kfilx,f_cfilx,id,ipack,nd5,nrepla,ncheck,l3264b,ier)

return
end subroutine write_ra_char
