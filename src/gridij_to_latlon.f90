subroutine tdlp_gridij_to_latlon(nx,ny,mproj,xmeshl,orient,xlat,xlatll,xlonll,&
                                 lats,lons,ier) bind(c)
use tdlpack_mod
use iso_c_binding, only: c_int32_t, c_float
implicit none

! ---------------------------------------------------------------------------------------- 
! Input/Output Variables
! ---------------------------------------------------------------------------------------- 
integer(kind=c_int32_t), intent(in) :: nx
integer(kind=c_int32_t), intent(in) :: ny
integer(kind=c_int32_t), intent(in) :: mproj
real(kind=c_float), intent(in) :: xmeshl
real(kind=c_float), intent(in) :: orient
real(kind=c_float), intent(in) :: xlat
real(kind=c_float), intent(in) :: xlatll
real(kind=c_float), intent(in) :: xlonll
real(kind=c_float), intent(out), dimension(nx,ny) :: lats
real(kind=c_float), intent(out), dimension(nx,ny) :: lons
integer(kind=c_int32_t), intent(out) :: ier

! ---------------------------------------------------------------------------------------- 
! Local Variables
! ---------------------------------------------------------------------------------------- 
integer :: i,j
real :: alat,alon

! ---------------------------------------------------------------------------------------- 
! Initialize
! ---------------------------------------------------------------------------------------- 
ier=0
alat=0.0
alon=0.0

! ---------------------------------------------------------------------------------------- 
! Call appropriate subroutine to convert from grid coordinates to lats,lons based on
! map projection.
! ---------------------------------------------------------------------------------------- 
if(mproj.eq.3)then
   do j=1,ny
      do i=1,nx
         call lmijll(kstdout,real(i),real(j),xmeshl,orient,xlat,xlatll,xlonll,alat,alon,ier)
         lats(i,j)=alat
         lons(i,j)=alon
      end do
   end do
elseif(mproj.eq.5)then
   do j=1,ny
      do i=1,nx
         call psijll(kstdout,real(i),real(j),xmeshl,orient,xlat,xlatll,xlonll,alat,alon)
         lats(i,j)=alat
         lons(i,j)=alon
      end do
   end do
elseif(mproj.eq.7)then
   do j=1,ny
      do i=1,nx
         call mcijll(kstdout,real(i),real(j),xmeshl,xlat,xlatll,xlonll,alat,alon)
         lats(i,j)=alat
         lons(i,j)=alon
      end do
   end do
endif

return
end subroutine tdlp_gridij_to_latlon
