subroutine read_tdlpack_file(kstdout,file,lun,nd5,ftype,ioctet,ipack,ier,id) bind(c)
use iso_c_binding, only: c_int32_t, c_char, c_null_char
use tdlpack_mod
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
integer(kind=c_int32_t), intent(in) :: kstdout
character(kind=c_char), intent(in), dimension(*) :: file
integer(kind=c_int32_t), intent(in) :: lun
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(in) :: ftype
integer(kind=c_int32_t), intent(out) :: ioctet
integer(kind=c_int32_t), intent(out), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(out) :: ier
integer(kind=c_int32_t), intent(in), dimension(4), optional :: id

! ---------------------------------------------------------------------------------------- 
! Local Variables
! ---------------------------------------------------------------------------------------- 
character(len=:), allocatable :: f_file
integer :: n,ios,ntrash,nvalue

! ---------------------------------------------------------------------------------------- 
! Initialize
! ---------------------------------------------------------------------------------------- 
ier=0
ios=0
ntrash=0
nvalue=0

f_file=""
n=1
do
   if(file(n).eq.c_null_char)exit
   f_file=f_file//file(n)
   n=n+1
end do

! ---------------------------------------------------------------------------------------- 
! Perform appropriate read for the given file type (ftype).
! ---------------------------------------------------------------------------------------- 
if(ftype.eq.1)then
   ! Random-Access
   call rdtdlm(kstdout,lun,file,id,ipack,nd5,nvalue,l3264b,ier)
   ioctet=nvalue*(l3264b/8)
   if(ier.eq.153)ier=-1
elseif(ftype.eq.2)then
   ! Sequential
   if(l3264b.eq.32)then
      read(lun,iostat=ios)ntrash,ioctet,(ipack(n),n=1,(ioctet/(l3264b/8)))
      ier=ios
   elseif(l3264b.eq.64)then
      read(lun,iostat=ios)ioctet,(ipack(n),n=1,(ioctet/(l3264b/8)))
      ier=ios
   endif
endif

return
end subroutine read_tdlpack_file
