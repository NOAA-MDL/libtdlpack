subroutine unpack_meta_wrapper(nd5,ipack,nd7,is0,is1,is2,is4,ier) bind(c)
use iso_c_binding, only: c_int32_t
use tdlpack_mod
implicit none

! Subroutine arguments
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(in), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(in) :: nd7
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is0
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is1
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is2
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is4
integer(kind=c_int32_t), intent(out) :: ier

! Locals
integer(kind=4) :: igive,kfildo
integer(kind=4) :: misspx,misssx
integer(kind=4), allocatable, dimension(:) :: iwork
real(kind=4), allocatable, dimension(:) :: data

ier=0
igive=1
kfildo=6
misspx=9999
misssx=9997

if(allocated(iwork))deallocate(iwork)
allocate(iwork(nd5))
iwork(:)=0

if(allocated(data))deallocate(data)
allocate(data(1))

call unpack(kfildo,ipack,iwork,data,nd5,&
            is0,is1,is2,is4,nd7,misspx,misssx,&
            igive,l3264b,ier)

if(allocated(iwork))deallocate(iwork)
if(allocated(data))deallocate(data)

return
end subroutine unpack_meta_wrapper




subroutine unpack_data_wrapper(nd5,ipack,nd7,is0,is1,is2,is4,data,ier) bind(c)
use iso_c_binding, only: c_int32_t, c_float
use tdlpack_mod
implicit none

! Subroutine arguments
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(in), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(in) :: nd7
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is0
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is1
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is2
integer(kind=c_int32_t), intent(out), dimension(nd7) :: is4
real(kind=c_float), intent(out), dimension(nd5) :: data
integer(kind=c_int32_t), intent(out) :: ier

! Locals
integer(kind=4) :: igive,kfildo
integer(kind=4) :: misspx,misssx
integer(kind=4), allocatable, dimension(:) :: iwork

ier=0
igive=2
kfildo=6
misspx=9999
misssx=9997

if(allocated(iwork))deallocate(iwork)
allocate(iwork(nd5))
iwork(:)=0

call unpack(kfildo,ipack,iwork,data,nd5,&
            is0,is1,is2,is4,nd7,misspx,misssx,&
            igive,l3264b,ier)

if(allocated(iwork))deallocate(iwork)

return
end subroutine unpack_data_wrapper
