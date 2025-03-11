subroutine write_station_record(file,lun,ftype,nsta,nd5,ipack,ntotby,ntotrc,ier,nreplace,ncheck) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t, c_char, c_null_char
implicit none

! ----------------------------------------------------------------------------------------
! Input/Output Variables
! ----------------------------------------------------------------------------------------
character(kind=c_char), intent(in), dimension(*) :: file
integer(kind=c_int32_t), intent(in) :: lun
integer(kind=c_int32_t), intent(in) :: ftype
integer(kind=c_int32_t), intent(in) :: nsta
integer(kind=c_int32_t), intent(in) :: nd5
character(kind=c_int32_t), intent(in), dimension(nd5) :: ipack
integer(kind=c_int32_t), intent(inout) :: ntotby
integer(kind=c_int32_t), intent(inout) :: ntotrc
integer(kind=c_int32_t), intent(out) :: ier
integer(kind=c_int32_t), intent(in), optional :: nreplace
integer(kind=c_int32_t), intent(in), optional :: ncheck

! ----------------------------------------------------------------------------------------
! Local Variables
! ----------------------------------------------------------------------------------------
character(len=1) :: f1
character(len=:), allocatable :: f_file
character(len=TDLP_NBYPWD), allocatable, dimension(:) :: cpack
integer :: i,n,ios,nbytes,ntrash
integer :: nreplacex, ncheckx
integer, dimension(TDLP_IDLEN) :: id

! ----------------------------------------------------------------------------------------
! Initialize
! ----------------------------------------------------------------------------------------
f_file=""
ier=0
ios=0
nreplacex=0
ncheckx=0

! ----------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------
if(ftype.eq.1)then

   i=1
   do
      if(file(i).eq.c_null_char)exit
      f1=file(i)
      f_file=f_file//f1
      i=i+1
   end do

   if(allocated(cpack))deallocate(cpack)
   allocate(cpack(TDLP_L3264W*nsta))

   do n=1,size(cpack)
      cpack(n) = transfer(ipack(n),"    ")
   end do 

   id(1)=400001000
   id(2:4)=0

   if(present(nreplace))nreplacex=nreplace
   if(present(ncheck))ncheckx=ncheck

   call wrtdlmc(kstdout,lun,f_file,id,cpack,nd5,nreplacex,ncheckx,TDLP_L3264B,ier)

elseif(ftype.eq.2)then

   nbytes=nd5*8
   ntrash=0

   if(TDLP_L3264B.eq.32)then
      write(lun,iostat=ios)ntrash,nbytes,(ipack(n),n=1,nd5)
   elseif(TDLP_L3264B.eq.64)then
      write(lun,iostat=ios)nbytes,(ipack(n),n=1,nd5)
   endif
   ier=ios

   ntotby=ntotby+nbytes
   ntotrc=ntotrc+1

endif

return
end subroutine write_station_record
