subroutine tdlp_unpack_meta(nd5,ipack,is0,is1,is2,is4,ier) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t
implicit none

! Subroutine arguments
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(in), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is0
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is1
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is2
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is4
integer(kind=c_int32_t), intent(out) :: ier

! Locals
integer(kind=4) :: igive
integer(kind=4) :: misspx,misssx
integer(kind=4), allocatable, dimension(:) :: iwork
real(kind=4), allocatable, dimension(:) :: data

ier=0
igive=1
misspx=9999
misssx=9997

if(allocated(iwork))deallocate(iwork)
allocate(iwork(nd5))
iwork(:)=0

if(allocated(data))deallocate(data)
allocate(data(1))

call unpack(kstdout,ipack,iwork,data,nd5,&
            is0,is1,is2,is4,nd7,misspx,misssx,&
            igive,TDLP_L3264B,ier)

if(allocated(iwork))deallocate(iwork)
if(allocated(data))deallocate(data)

return
end subroutine tdlp_unpack_meta




subroutine tdlp_unpack_data(nd5,ipack,is0,is1,is2,is4,data,ier) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t, c_float
implicit none

! Subroutine arguments
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(in), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is0
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is1
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is2
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is4
real(kind=c_float), intent(out), dimension(nd5) :: data
integer(kind=c_int32_t), intent(out) :: ier

! Locals
integer(kind=4) :: igive
integer(kind=4) :: misspx,misssx
integer(kind=4), allocatable, dimension(:) :: iwork

ier=0
igive=2
misspx=9999
misssx=9997

if(allocated(iwork))deallocate(iwork)
allocate(iwork(nd5))
iwork(:)=0

call unpack(kstdout,ipack,iwork,data,nd5,&
            is0,is1,is2,is4,nd7,misspx,misssx,&
            igive,TDLP_L3264B,ier)

if(allocated(iwork))deallocate(iwork)

return
end subroutine tdlp_unpack_data
