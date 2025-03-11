subroutine open_tdlpack_file(file,mode,lun,ftype,ier,ra_template) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t, c_char, c_null_char
use tdlpack_mod
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
character(kind=c_char), dimension(*), intent(in) :: file
character(kind=c_char), dimension(*), intent(in) :: mode
integer(kind=c_int32_t), intent(inout) :: lun
integer(kind=c_int32_t), intent(inout) :: ftype
integer(kind=c_int32_t), intent(inout) :: ier
character(len=c_char), dimension(*), intent(in), optional :: ra_template

! ---------------------------------------------------------------------------------------- 
! Local Variables
! ---------------------------------------------------------------------------------------- 
integer :: i,ios,itemp,ibyteorder
integer :: maxent,nbytes
character(len=1) :: mode1
character(len=:), allocatable :: caccess
character(len=:), allocatable :: caction
character(len=:), allocatable :: cstatus
character(len=:), allocatable :: f_mode,f_ra_template
character(len=20) :: convertx
character(len=1024) :: f_file

integer, save :: ienter=0
integer, save :: isysend=0
integer, save :: lunx=65535

! ---------------------------------------------------------------------------------------- 
! Initialize
! ---------------------------------------------------------------------------------------- 
ier=0
ios=0
ibyteorder=0
caccess=""
caction="readwrite"
cstatus=""
f_file=repeat(" ",len(f_file))

! ---------------------------------------------------------------------------------------- 
! Convert C char file to Fortran.
! ---------------------------------------------------------------------------------------- 
i=1
do
   if(file(i).eq.c_null_char)exit
   f_file(i:i)=file(i)
   i=i+1
end do 

! ---------------------------------------------------------------------------------------- 
! Convert C char mode to Fortran.
! ---------------------------------------------------------------------------------------- 
i=1
f_mode=""
do
   if(mode(i).eq.c_null_char)exit
   f_mode=f_mode//mode(i)
   i=i+1
end do
mode1=f_mode(1:1)

! ---------------------------------------------------------------------------------------- 
! Convert C char ra_template to Fortran, if present.
! ---------------------------------------------------------------------------------------- 
if(present(ra_template))then
   i=1
   f_ra_template=""
   do
      if(ra_template(i).eq.c_null_char)exit
      f_ra_template=f_ra_template//ra_template(i)
      i=i+1
   end do
endif

! ---------------------------------------------------------------------------------------- 
! Get byte order of the system and set unit number.
! ---------------------------------------------------------------------------------------- 
if(ienter.eq.0)call cksysend(6,"     ",isysend,ier)
lun=lunx+ienter
ienter=ienter+1

! ---------------------------------------------------------------------------------------- 
! Perform the following for read (only) and append (can be read and/or write).
! ---------------------------------------------------------------------------------------- 
if(mode1.eq."r".or.mode1.eq."a")then

   ! Open file for stream access; read first 4 bytes; close.
   open(unit=lun,file=f_file,form="unformatted",access="stream",status="old",iostat=ios)
   read(lun,iostat=ios)itemp
   close(lun)

   ! Test itemp to determine if file is random-access or sequential; then perform
   ! appropriate IO action to prepare for reading the file.
   if(itemp.eq.0)then
      ! Random-Access
      call ckraend(kstdout,lun,f_file,isysend,ibyteorder,convertx,ier)
      ftype=1
   else
      ! Sequential
      call ckfilend(kstdout,lun,f_file,isysend,ibyteorder,convertx,ier)
      ftype=2
      cstatus="old"
      if(mode1.eq."r")then
         caccess="sequential"
         caction="read"
      elseif(mode1.eq."a")then
         caccess="append"
      endif
      open(unit=lun,file=f_file,form="unformatted",convert="big_endian",status=cstatus,&
           iostat=ios,access=caccess,action=caction)
      ier=ios
   endif

! ---------------------------------------------------------------------------------------- 
! Perform the following for new files.
! ---------------------------------------------------------------------------------------- 
elseif(mode1.eq."w".or.mode1.eq."x")then

   if(ftype.eq.1)then
      ! Random-Access
      if(present(ra_template))then
         if(f_ra_template.eq."small")then
            maxent=300
            nbytes=2000
         elseif(f_ra_template.eq."large")then
            maxent=840
            nbytes=20000
         endif
         call createra(kstdout,f_file,TDLP_L3264B,lun,maxent,nbytes,ier)
      endif
   elseif(ftype.eq.2)then
      ! Sequential
      if(mode1.eq."w")cstatus="replace"
      if(mode1.eq."x")cstatus="new"
      ftype=2
      open(unit=lun,file=f_file,form="unformatted",convert="big_endian",status=cstatus,&
           action=caction,iostat=ios)
      ier=ios
   endif

endif

return
end subroutine open_tdlpack_file
