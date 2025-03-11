subroutine write_tdlpack_record(file,lun,ftype,nd5,ipack,ier,nreplace,ncheck) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t, c_char, c_null_char
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
character(kind=c_char), intent(in), dimension(*) :: file
integer(kind=c_int32_t), intent(in) :: lun
integer(kind=c_int32_t), intent(in) :: nd5
integer(kind=c_int32_t), intent(in) :: ftype
integer(kind=c_int32_t), intent(in), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(out) :: ier
integer(kind=c_int32_t), intent(in), optional :: nreplace
integer(kind=c_int32_t), intent(in), optional :: ncheck

! ---------------------------------------------------------------------------------------- 
! Local Variables
! ---------------------------------------------------------------------------------------- 
character(len=:), allocatable :: f_file
integer :: n,ios,ioctet,ntrash,nsize
integer :: nreplacex,ncheckx
integer, dimension(TDLP_IDLEN) :: id

! ---------------------------------------------------------------------------------------- 
! Initialize
! ---------------------------------------------------------------------------------------- 
ier=0
ios=0
ioctet=nd5*TDLP_NBYPWD
ncheckx=0
nreplacex=0
nsize=0
ntrash=0
id(:)=0

! FUTURE: Check for "TDLP" header

f_file=""
n=1
do
   if(file(n).eq.c_null_char)exit
   f_file=f_file//file(n)
   n=n+1
end do

! ---------------------------------------------------------------------------------------- 
! Perform appropriate writing according file type (ftype).
! ---------------------------------------------------------------------------------------- 
if(ftype.eq.1)then
   ! Random-Access
   if(present(nreplace))nreplacex=nreplace
   if(present(ncheck))ncheckx=ncheck
   id(1:4)=ipack(6:9)
   nsize=nd5
   call wrtdlm(kstdout,lun,file,id,ipack,nsize,nreplacex,ncheckx,TDLP_L3264B,ier)
elseif(ftype.eq.2)then
   ! Sequential
   if(TDLP_L3264B.eq.32)then
      write(lun,iostat=ios)ntrash,ioctet,(ipack(n),n=1,nd5)
   elseif(TDLP_L3264B.eq.64)then
      write(lun,iostat=ios)ioctet,(ipack(n),n=1,nd5)
   endif
   ier=ios
endif

return
end subroutine write_tdlpack_record
