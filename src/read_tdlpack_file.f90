subroutine read_tdlpack_file(file,lun,ftype,nd5,ipack,ioctet,ier,id) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t, c_char, c_null_char
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
character(kind=c_char), intent(in), dimension(*) :: file
integer(kind=c_int32_t), intent(in) :: lun
integer(kind=c_int32_t), intent(in) :: ftype
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(out), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(out) :: ioctet
integer(kind=c_int32_t), intent(out) :: ier
integer(kind=c_int32_t), intent(in), dimension(TDLP_IDLEN), optional :: id

! ---------------------------------------------------------------------------------------- 
! Local Variables
! ---------------------------------------------------------------------------------------- 
character(len=:), allocatable :: f_file
integer :: n,ios,ntrash,nvalue
integer, dimension(TDLP_IDLEN) :: idx

! ---------------------------------------------------------------------------------------- 
! Initialize
! ---------------------------------------------------------------------------------------- 
ier=0
ios=0
ntrash=0
nvalue=0
idx(:)=0

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
   if(present(id))idx(1:TDLP_IDLEN)=id(1:TDLP_IDLEN)
   ! Random-Access
   call rdtdlm(kstdout,lun,f_file,idx,ipack,nd5,nvalue,TDLP_L3264B,ier)
   ioctet=nvalue*TDLP_NBYPWD
   if(idx(1).eq.400001000.and.ier.eq.155)ier=0
   if(ier.eq.153)ier=-1
elseif(ftype.eq.2)then
   ! Sequential
   if(TDLP_L3264B.eq.32)then
      read(lun,iostat=ios)ntrash,ioctet,(ipack(n),n=1,(ioctet/TDLP_NBYPWD))
      ier=ios
   elseif(TDLP_L3264B.eq.64)then
      read(lun,iostat=ios)ioctet,(ipack(n),n=1,(ioctet/TDLP_NBYPWD))
      ier=ios
   endif
endif

return
end subroutine read_tdlpack_file
