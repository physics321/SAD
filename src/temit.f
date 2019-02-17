      module temw
      use tffitcode
      implicit none

      private

      integer*4 , public, parameter ::
     $     ipdx=1,ipdpx=2,ipdy=3,ipdpy=4,ipdz=5,ipddp=6,
     $     ipnx=7,ipny=8,ipnz=9,
     $     ipu0=10,ipvceff=11,iptrf0=12,ipalphap=13,ipdleng=14,
     $     ipbh=15,ipdampx=16,ipdampy=17,ipdampz=18,
     $     ipjx=19,ipjy=20,ipjz=21,
     $     ipemx=22,ipemy=23,ipemz=24,ipsige=25,ipsigz=26,
     $     ipheff=27,ipdnux=28,ipdnuy=29,ipdnuz=30,
     $     iptwiss=31,iptws0=iptwiss-1,
     $     ipnnup=iptwiss+ntwissfun,iptaup=ipnnup+1,
     $     ippolx=iptaup+1,ippoly=ippolx+1,ippolz=ippoly+1,
     $     ipequpol=ippolz+1,ipnup=ipequpol+1,iprevf=ipnup+1,
     $     nparams=iprevf

      real(8), public :: r(6, 6) = RESHAPE((/
     $     1.d0, 0.d0, 0.d0, 0.d0, 0.d0, 0.d0,
     $     0.d0, 1.d0, 0.d0, 0.d0, 0.d0, 0.d0,
     $     0.d0, 0.d0, 1.d0, 0.d0, 0.d0, 0.d0,
     $     0.d0, 0.d0, 0.d0, 1.d0, 0.d0, 0.d0,
     $     0.d0, 0.d0, 0.d0, 0.d0, 1.d0, 0.d0,
     $     0.d0, 0.d0, 0.d0, 0.d0, 0.d0, 1.d0/),
     $     (/6, 6/))

c     Inverse matrix of r
      real(8), public :: ri(6, 6) = RESHAPE((/
     $     1.d0, 0.d0, 0.d0, 0.d0, 0.d0, 0.d0,
     $     0.d0, 1.d0, 0.d0, 0.d0, 0.d0, 0.d0,
     $     0.d0, 0.d0, 1.d0, 0.d0, 0.d0, 0.d0,
     $     0.d0, 0.d0, 0.d0, 1.d0, 0.d0, 0.d0,
     $     0.d0, 0.d0, 0.d0, 0.d0, 1.d0, 0.d0,
     $     0.d0, 0.d0, 0.d0, 0.d0, 0.d0, 1.d0/),
     $     (/6, 6/))

      real(8), public :: emx, emy, emz
      real*8 , public :: transr(6,6),codr0(6),bzhr0,bsi

      logical*4, public :: normali, initemip=.true.
      logical*4 , public :: initr

      real*8 , parameter :: toln=0.1d0


      public :: tfetwiss,etwiss2ri,tfnormalcoord,toln,
     $     tfinitemip,tsetr0

      contains
      subroutine tsetr0(trans,cod,bzh,bsi0)
      implicit none
      real*8 ,intent(in)::trans(6,6),cod(6),bzh,bsi0
      codr0=cod
      transr=trans
      bzhr0=bzh
      bsi=bsi0
      return
      end subroutine

      subroutine tfinitemip
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 irtc
      character*2 strfromis
      if( .not. initemip)then
        return
      endif
      call tfevals('BeginPackage[emit$`];Begin[emit$`]',kx,irtc)
      call tfevals(
     $'nparams='//strfromis(nparams)//
     $';ipdx='//strfromis(ipdx)//
     $';ipdpx='//strfromis(ipdpx)//
     $';ipdy='//strfromis(ipdy)//
     $';ipdpy='//strfromis(ipdpy)//
     $';ipdz='//strfromis(ipdz)//
     $';ipddp='//strfromis(ipddp)//
     $';ipnx='//strfromis(ipnx)//
     $';ipny='//strfromis(ipny)//
     $';ipnz='//strfromis(ipnz)//
     $';ipu0='//strfromis(ipu0)//
     $';ipvceff='//strfromis(ipvceff)//
     $';iptrf0='//strfromis(iptrf0)//
     $';ipalphap='//strfromis(ipalphap)//
     $';ipdleng='//strfromis(ipdleng)//
     $';ipbh='//strfromis(ipbh)//
     $';ipheff='//strfromis(ipheff)//
     $';iptwiss='//strfromis(iptwiss)//
     $';iptws0='//strfromis(iptws0)//
     $';ipdampx='//strfromis(ipdampx)//
     $';ipdampy='//strfromis(ipdampy)//
     $';ipdampz='//strfromis(ipdampz)//
     $';ipdnux='//strfromis(ipdnux)//
     $';ipdnuy='//strfromis(ipdnuy)//
     $';ipdnuz='//strfromis(ipdnuz)//
     $';ipjx='//strfromis(ipjx)//
     $';ipjy='//strfromis(ipjy)//
     $';ipjz='//strfromis(ipjz)//
     $';ipemx='//strfromis(ipemx)//
     $';ipemy='//strfromis(ipemy)//
     $';ipemz='//strfromis(ipemz)//
     $';ipsige='//strfromis(ipsige)//
     $';ipsigz='//strfromis(ipsigz)//
     $';ipnnup='//strfromis(ipnnup)//
     $';iptaup='//strfromis(iptaup)//
     $';ippolx='//strfromis(ippolx)//
     $';ippoly='//strfromis(ippoly)//
     $';ippolz='//strfromis(ippolz)//
     $';ipequpol='//strfromis(ipequpol)//
     $';ipnup='//strfromis(ipnup)//
     $';iprevf='//strfromis(iprevf)//
     $';SetAttributes[{'//
     $ 'nparams,ipdx,ipdpx,ipdy,ipdpy,ipdz,ipddp,'//
     $ 'ipnx,ipny,ipnz,'//
     $ 'ipu0,ipvceff,iptrf0,ipalphap,ipdleng,'//
     $ 'ipbh,ipheff,iptwiss,ipdampx,ipdampy,ipdampz,'//
     $ 'ipdnux,ipdnuy,ipdnuz,ipjx,ipjy,ipjz,'//
     $ 'ipemx,ipemy,ipemz,ipsige,ipsigz,iptaup,ipnup,'//
     $ 'ippolx,ippoly,ippolz,ipequpol,ipnup,iprevf'//
     $ '},Constant];'//
     $ 'End[];EndPackage[];',kx,irtc)
c      call tfdebugprint(kx,'initemip',1)
      initemip=.false.
      return
      end subroutine

      subroutine tfetwiss(r,cod,twiss,normi)
      use ffs
      implicit none
      real*8 r(6,6),twiss(ntwissfun),hi(6,6),cod(6)
      real*8 ax,ay,az,axy,f,detm,his(4),
     $     uz11,uz12,uz21,uz22,
     $     hx11,hx12,hx21,hx22,
     $     hy11,hy12,hy21,hy22,
     $     r11,r12,r21,r22,
     $     crx,cry,crz,cx,cy,cz,sx,sy,sz,
     $     bx21,bx22,by21,by22,bz21,bz22
      logical*4 normal,normi
c      write(*,'(a,1p5g15.7)')'tfetwiss ',r(5,5),r(5,6),r(6,5),r(6,6),
c     $     r(5,5)*r(6,6)-r(6,5)*r(5,6)
      az=sqrt(r(5,5)*r(6,6)-r(6,5)*r(5,6))
      uz11=r(5,5)/az
      uz12=r(5,6)/az
      uz21=r(6,5)/az
      uz22=r(6,6)/az
      hx11= r(6,2)*uz11-r(5,2)*uz21
      hx12= r(6,2)*uz12-r(5,2)*uz22
      hx21=-r(6,1)*uz11+r(5,1)*uz21
      hx22=-r(6,1)*uz12+r(5,1)*uz22
      hy11= r(6,4)*uz11-r(5,4)*uz21
      hy12= r(6,4)*uz12-r(5,4)*uz22
      hy21=-r(6,3)*uz11+r(5,3)*uz21
      hy22=-r(6,3)*uz12+r(5,3)*uz22
      f=1.d0/(1.d0+az)
      ax=1.d0-(hx11*hx22-hx21*hx12)*f
      ay=1.d0-(hy11*hy22-hy21*hy12)*f
      hi(2,2)=ax
      hi(1,2)=0.d0
      hi(4,2)= (hx12*hy21-hx11*hy22)*f
      hi(3,2)=-(-hx12*hy11+hx11*hy12)*f
      hi(6,2)=-hx11
      hi(5,2)= hx12
      hi(2,1)= 0.d0
      hi(1,1)= ax
      hi(4,1)=-(hx22*hy21-hx21*hy22)*f
      hi(3,1)=(-hx22*hy11+hx21*hy12)*f
      hi(6,1)= hx21
      hi(5,1)=-hx22
      hi(2,4)= hi(3,1)
      hi(1,4)=-hi(3,2)
      hi(4,4)= ay
      hi(3,4)= 0.d0
      hi(6,4)=-hy11
      hi(5,4)= hy12
      hi(2,3)=-hi(4,1)
      hi(1,3)= hi(4,2)
      hi(4,3)= 0.d0
      hi(3,3)= ay
      hi(6,3)= hy21
      hi(5,3)=-hy22
      hi(2,6)= hx22
      hi(1,6)= hx21
      hi(4,6)= hy22
      hi(3,6)= hy21
      hi(6,6)= az
      hi(5,6)= 0.d0
      hi(2,5)= hx12
      hi(1,5)= hx11
      hi(4,5)= hy12
      hi(3,5)= hy11
      hi(6,5)= 0.d0
      hi(5,5)= az
      call tmultr(hi,r,6)
      detm=(hi(1,1)*hi(2,2)-hi(2,1)*hi(1,2)
     $     +hi(3,3)*hi(4,4)-hi(4,3)*hi(3,4))*.5d0
c      write(*,'(a,1p6g15.7)')'tfetwiss ',detm,ax,ay,az,f,xyth
      normal=detm .gt. xyth
      if(.not. normal)then
        his=hi(1,1:4)
        hi(1,1:4)=hi(3,1:4)
        hi(3,1:4)=his
        his=hi(2,1:4)
        hi(2,1:4)=hi(4,1:4)
        hi(4,1:4)=his
        detm=(hi(1,1)*hi(2,2)-hi(2,1)*hi(1,2)
     $       +hi(3,3)*hi(4,4)-hi(4,3)*hi(3,4))*.5d0
      endif
      axy=sqrt(detm)
      r11=( hi(4,4)*hi(3,1)-hi(3,4)*hi(4,1))/axy
      r12=( hi(4,4)*hi(3,2)-hi(3,4)*hi(4,2))/axy
      r21=(-hi(4,3)*hi(3,1)+hi(3,3)*hi(4,1))/axy
      r22=(-hi(4,3)*hi(3,2)+hi(3,3)*hi(4,2))/axy
      crx=sqrt(hi(1,2)**2+hi(2,2)**2)
      cx= hi(2,2)/crx
      sx=-hi(1,2)/crx
      bx21=(-sx*hi(1,1)+cx*hi(2,1))/axy
      bx22=crx/axy
      cry=sqrt(hi(3,4)**2+hi(4,4)**2)
      cy= hi(4,4)/cry
      sy=-hi(3,4)/cry
      by21=(-sy*hi(3,3)+cy*hi(4,3))/axy
      by22=cry/axy
      crz=sqrt(uz12**2+uz22**2)
      cz= uz22/crz
      sz=-uz12/crz
      bz21=-sz*uz11+cz*uz21
      bz22=crz
      twiss(mfitr1)=r11
      twiss(mfitr2)=r12
      twiss(mfitr3)=r21
      twiss(mfitr4)=r22
      if(.not. normi)then
        normal=.not. normal
      endif
      if(normal)then
        twiss(mfitax)= bx21*bx22
        twiss(mfitbx)= bx22**2
        twiss(mfitnx)= atan2(sx,cx)
        twiss(mfitay)= by21*by22
        twiss(mfitby)= by22**2
        twiss(mfitny)= atan2(sy,cy)
        twiss(mfitex)= axy*hx12-r22*hy12+r12*hy22
        twiss(mfitepx)= axy*hx22+r21*hy12-r11*hy22
        twiss(mfitey) = axy*hy12+r11*hx12+r12*hx22
        twiss(mfitepy)=axy*hy22+r21*hx12+r22*hx22
        twiss(mfitdetr)=r11*r22-r12*r21
        twiss(mfitzx) =axy*hx11-r22*hy11+r12*hy21
        twiss(mfitzpx)=axy*hx21+r21*hy11-r11*hy21
        twiss(mfitzy) =axy*hy11+r11*hx11+r12*hx21
        twiss(mfitzpy)=axy*hy21+r21*hx11+r22*hx21
      else
        twiss(mfitay)= bx21*bx22
        twiss(mfitby)= bx22**2
        twiss(mfitny)= atan2(sx,cx)
        twiss(mfitax)= by21*by22
        twiss(mfitbx)= by22**2
        twiss(mfitnx)= atan2(sy,cy)
        twiss(mfitey)= axy*hx12-r22*hy12+r12*hy22
        twiss(mfitepy)= axy*hx22+r21*hy12-r11*hy22
        twiss(mfitex) = axy*hy12+r11*hx12+r12*hx22
        twiss(mfitepx)=axy*hy22+r21*hx12+r22*hx22
        twiss(mfitdetr)=1.d0+xyth-r11*r22+r12*r21
        twiss(mfitzy) =axy*hx11-r22*hy11+r12*hy21
        twiss(mfitzpy)=axy*hx21+r21*hy11-r11*hy21
        twiss(mfitzx) =axy*hy11+r11*hx11+r12*hx21
        twiss(mfitzpx)=axy*hy21+r21*hx11+r22*hx21
      endif
      twiss(mfitdx:mfitddp)=cod
      twiss(mfitaz)=bz21*bz22
      twiss(mfitbz)=bz22**2
      twiss(mfitnz)=atan2(sz,cz)
      return
      end subroutine

      subroutine etwiss2ri(twiss1,ria,normal)
      use ffs
      implicit none
      real*8 twiss1(ntwissfun),ria(6,6),h(4,6),br(4,4),
     $     hx11,hx12,hx21,hx22,
     $     hy11,hy12,hy21,hy22,
     $     ex,epx,ey,epy,zx,zpx,zy,zpy,
     $     r1,r2,r3,r4,amu,detr,sqrbx,sqrby,sqrbz,aa,
     $     ax,ay,az,dethx,dethy,amux,amuy,azz
      logical*4 normal
      r1=twiss1(mfitr1)
      r2=twiss1(mfitr2)
      r3=twiss1(mfitr3)
      r4=twiss1(mfitr4)
      detr=twiss1(mfitdetr)
      normal=detr .lt. 1.d0
      if(normal)then
        amu=sqrt(1.d0-detr)
        ex =twiss1(mfitex)
        epx=twiss1(mfitepx)
        ey =twiss1(mfitey)
        epy=twiss1(mfitepy)
        zx =twiss1(mfitzx)
        zpx=twiss1(mfitzpx)
        zy =twiss1(mfitzy)
        zpy=twiss1(mfitzpy)
        sqrbx=sqrt(twiss1(mfitbx))
        ax=twiss1(mfitax)
        sqrby=sqrt(twiss1(mfitby))
        ay=twiss1(mfitay)
      else
        amu=sqrt(1.d0-r1*r4+r2*r3)
        ey =twiss1(mfitex)
        epy=twiss1(mfitepx)
        ex =twiss1(mfitey)
        epx=twiss1(mfitepy)
        zy =twiss1(mfitzx)
        zpy=twiss1(mfitzpx)
        zx =twiss1(mfitzy)
        zpx=twiss1(mfitzpy)
        sqrby=sqrt(twiss1(mfitbx))
        ay=twiss1(mfitax)
        sqrbx=sqrt(twiss1(mfitby))
        ax=twiss1(mfitay)
      endif
      sqrbz=sqrt(twiss1(mfitbz))
      az=twiss1(mfitaz)
      hx11=amu*zx -r2*zpy+r4*zy
      hx12=amu*ex -r2*epy+r4*ey
      hx21=amu*zpx+r1*zpy-r3*zy
      hx22=amu*epx+r1*epy-r3*ey
      hy11=amu*zy -r2*zpx-r1*zx
      hy12=amu*ey -r2*epx-r1*ex
      hy21=amu*zpy-r4*zpx-r3*zx
      hy22=amu*epy-r4*epx-r3*ex
      dethx=hx11*hx22-hx21*hx12
      dethy=hy11*hy22-hy21*hy12
      azz=sqrt(1.d0-dethx-dethy)
      aa=1.d0/(1.d0+azz)
      amux=1.d0-dethx*aa
      amuy=1.d0-dethy*aa
      h(1,1)=amux
      h(1,2)=0.d0
      h(1,3)=( hx12*hy21-hx11*hy22)*aa
      h(1,4)=(-hx12*hy11+hx11*hy12)*aa
      h(1,5)=-hx11
      h(1,6)=-hx12
      h(2,1)=0.d0
      h(2,2)=amux
      h(2,3)=( hx22*hy21-hx21*hy22)*aa
      h(2,4)=(-hx22*hy11+hx21*hy12)*aa
      h(2,5)=-hx21
      h(2,6)=-hx22
      h(3,1)= h(2,4)
      h(3,2)=-h(1,4)
      h(3,3)=amuy
      h(3,4)=0.d0
      h(3,5)=-hy11
      h(3,6)=-hy12
      h(4,1)=-h(2,3)
      h(4,2)= h(1,3)
      h(4,3)=0.d0
      h(4,4)=amuy
      h(4,5)=-hy21
      h(4,6)=-hy22
      ria(5,1)= hx22
      ria(5,2)=-hx12
      ria(5,3)= hy22
      ria(5,4)=-hy12
      ria(5,5)=azz
      ria(5,6)=0.d0
      ria(6,1)=-hx21
      ria(6,2)= hx11
      ria(6,3)=-hy21
      ria(6,4)= hy11
      ria(6,5)=0.d0
      ria(6,6)=azz
      br(1,1)= amu/sqrbx
      br(1,2)=0.d0
      br(1,3)=-r4/sqrbx
      br(1,4)= r2/sqrbx
      br(2,1)= amu*ax/sqrbx
      br(2,2)= amu*sqrbx
      br(2,3)= r3*sqrbx-r4*ax/sqrbx
      br(2,4)= r2*ax/sqrbx-r1*sqrbx
      br(3,1)= r1/sqrby
      br(3,2)= r2/sqrby
      br(3,3)= amu/sqrby
      br(3,4)=0.d0
      br(4,1)= r1*ay/sqrby+r3*sqrby
      br(4,2)= r2*ay/sqrby+r4*sqrby
      br(4,3)= amu*ay/sqrby
      br(4,4)= amu*sqrby
      ria(1,1)=br(1,1)*h(1,1)+br(1,2)*h(2,1)
     $       +br(1,3)*h(3,1)+br(1,4)*h(4,1)
      ria(1,2)=br(1,1)*h(1,2)+br(1,2)*h(2,2)
     $       +br(1,3)*h(3,2)+br(1,4)*h(4,2)
      ria(1,3)=br(1,1)*h(1,3)+br(1,2)*h(2,3)
     $       +br(1,3)*h(3,3)+br(1,4)*h(4,3)
      ria(1,4)=br(1,1)*h(1,4)+br(1,2)*h(2,4)
     $       +br(1,3)*h(3,4)+br(1,4)*h(4,4)
      ria(1,5)=br(1,1)*h(1,5)+br(1,2)*h(2,5)
     $       +br(1,3)*h(3,5)+br(1,4)*h(4,5)
      ria(1,6)=br(1,1)*h(1,6)+br(1,2)*h(2,6)
     $       +br(1,3)*h(3,6)+br(1,4)*h(4,6)
      ria(2,1)=br(2,1)*h(1,1)+br(2,2)*h(2,1)
     $       +br(2,3)*h(3,1)+br(2,4)*h(4,1)
      ria(2,2)=br(2,1)*h(1,2)+br(2,2)*h(2,2)
     $       +br(2,3)*h(3,2)+br(2,4)*h(4,2)
      ria(2,3)=br(2,1)*h(1,3)+br(2,2)*h(2,3)
     $       +br(2,3)*h(3,3)+br(2,4)*h(4,3)
      ria(2,4)=br(2,1)*h(1,4)+br(2,2)*h(2,4)
     $       +br(2,3)*h(3,4)+br(2,4)*h(4,4)
      ria(2,5)=br(2,1)*h(1,5)+br(2,2)*h(2,5)
     $       +br(2,3)*h(3,5)+br(2,4)*h(4,5)
      ria(2,6)=br(2,1)*h(1,6)+br(2,2)*h(2,6)
     $       +br(2,3)*h(3,6)+br(2,4)*h(4,6)
      ria(3,1)=br(3,1)*h(1,1)+br(3,2)*h(2,1)
     $       +br(3,3)*h(3,1)+br(3,4)*h(4,1)
      ria(3,2)=br(3,1)*h(1,2)+br(3,2)*h(2,2)
     $       +br(3,3)*h(3,2)+br(3,4)*h(4,2)
      ria(3,3)=br(3,1)*h(1,3)+br(3,2)*h(2,3)
     $       +br(3,3)*h(3,3)+br(3,4)*h(4,3)
      ria(3,4)=br(3,1)*h(1,4)+br(3,2)*h(2,4)
     $       +br(3,3)*h(3,4)+br(3,4)*h(4,4)
      ria(3,5)=br(3,1)*h(1,5)+br(3,2)*h(2,5)
     $       +br(3,3)*h(3,5)+br(3,4)*h(4,5)
      ria(3,6)=br(3,1)*h(1,6)+br(3,2)*h(2,6)
     $       +br(3,3)*h(3,6)+br(3,4)*h(4,6)
      ria(4,1)=br(4,1)*h(1,1)+br(4,2)*h(2,1)
     $       +br(4,3)*h(3,1)+br(4,4)*h(4,1)
      ria(4,2)=br(4,1)*h(1,2)+br(4,2)*h(2,2)
     $       +br(4,3)*h(3,2)+br(4,4)*h(4,2)
      ria(4,3)=br(4,1)*h(1,3)+br(4,2)*h(2,3)
     $       +br(4,3)*h(3,3)+br(4,4)*h(4,3)
      ria(4,4)=br(4,1)*h(1,4)+br(4,2)*h(2,4)
     $       +br(4,3)*h(3,4)+br(4,4)*h(4,4)
      ria(4,5)=br(4,1)*h(1,5)+br(4,2)*h(2,5)
     $       +br(4,3)*h(3,5)+br(4,4)*h(4,5)
      ria(4,6)=br(4,1)*h(1,6)+br(4,2)*h(2,6)
     $       +br(4,3)*h(3,6)+br(4,4)*h(4,6)
      ria(5,1:6)=ria(5,1:6)/sqrbz
      ria(6,1:6)=ria(6,1:6)*sqrbz+ria(5,1:6)*az
      return
      end subroutine

      subroutine tfnormalcoord(isp1,kx,irtc)
      use tfstk
      use ffs
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,itfmessage
      real*8 rn(6,6)
      logical*4 normal
      type (sad_rlist), pointer :: kl
      if(isp .ne. isp1+1)then
        irtc=itfmessage(9,'General::narg','"1"')
        return
      endif
      if(.not. tfnumlistqn(dtastk(isp),ntwissfun,kl))then
        irtc=itfmessage(9,'General::wrongtype',
     $       '"Real List of Length 28"')
        return
      endif
      call etwiss2ri(kl%rbody(1:ntwissfun),rn,normal)
      kx=kxm2l(rn,6,6,6,.false.)
      irtc=0
      return
      end subroutine

      end module temw

      module touschek_table
      implicit none
      private

      public :: initialize_tampl

      integer(8), public:: itoul = 0
      integer, public :: id = 0

      integer, public, parameter :: ntouckx = 34, ntouckz = 25
      integer, public, parameter :: ntouckl = 120

c     ntouckx > ntouckz

c     Table of amplitude(index, axis[1->x, 2->y, 3->z])
      real(8), public :: tampl(ntouckx, 3)

c     Table of loss-rate
      real(8), public :: touckl(ntouckl)
      real(8), public :: touckm(ntouckz, ntouckx, 3)
      real(8), public, allocatable :: toucke(:,:)

      contains

      subroutine initialize_tampl()
      implicit none
      integer :: i

      tampl(:,:) = 0.d0

      tampl( 1,1)=1.d0
      tampl( 2,1)=2.d0
      tampl( 3,1)=3.d0
      tampl( 4,1)=4.d0

      tampl( 1+4,1)=5.d0
      tampl( 2+4,1)=6.d0
      tampl( 3+4,1)=7.d0
      tampl( 4+4,1)=8.d0
      tampl( 5+4,1)=9.d0

      tampl( 1+5+4,1)=10.d0
      tampl( 2+5+4,1)=11.d0
      tampl( 3+5+4,1)=13.d0
      tampl( 4+5+4,1)=15.d0
      tampl( 5+5+4,1)=17.d0
      tampl( 6+5+4,1)=19.d0
      tampl( 7+5+4,1)=21.d0
      tampl( 8+5+4,1)=24.d0
      tampl( 9+5+4,1)=28.d0
      tampl(10+5+4,1)=32.d0
      tampl(11+5+4,1)=36.d0
      tampl(12+5+4,1)=41.d0
      tampl(13+5+4,1)=46.d0
      tampl(14+5+4,1)=53.d0
      tampl(15+5+4,1)=60.d0
      tampl(16+5+4,1)=68.d0
      tampl(17+5+4,1)=77.d0
      tampl(18+5+4,1)=88.d0

      do i = 28, ntouckx
        tampl(i, 1) = tampl(i-18, 1) * 10.d0
      enddo

      tampl(1:ntouckx,2) = tampl(1:ntouckx,1)

      tampl(7:ntouckx-3,3) = tampl(10:ntouckx,1)
      tampl( 1,3)= 4.6d0
      tampl( 2,3)= 5.3d0
      tampl( 3,3)= 6.d0
      tampl( 4,3)= 6.8d0
      tampl( 5,3)= 7.7d0
      tampl( 6,3)= 8.8d0

      return
      end subroutine initialize_tampl

      end module touschek_table

      module tspin
      use macphys

      real*8, parameter :: pst=8.d0*sqrt(3.d0)/15.d0,
     $     sflc=.75d0*(elradi/finest)**2

      integer*4 ,parameter :: mdim=4,maxi=200,maxm=400,maxiv=10
      integer*4 , parameter ::
     $     mlen(6)=(/8+2, 30+6, 80+10, 175+16, 336+25, 588+36/)

      type scmat
        complex*16 , pointer :: cmat(:,:,:)
        integer*4 , pointer :: iamat(:,:,:,:)
        integer*4 , pointer :: ind(:,:)
        integer*4 nind,iord,id
      end type

c      type spin
c      sequence
c      real*8 sx,sy,sz
c      end type

      contains
        subroutine spinitrm(rm,nord,id)
        implicit none
        type (scmat) rm
        integer*4 nord,id
        allocate(rm%cmat(3,3,mlen(nord)))
        allocate(rm%iamat(0:nord,0:nord,-nord:nord,-nord:nord))
        allocate(rm%ind(4,mlen(nord)))
        rm%nind=0
        rm%iamat=0
        rm%iord=nord
        rm%id=id
        return
        end

        integer*4 function iaind(rm,ind) result(ia)
        type (scmat) rm
        integer*4 ind(4)
        ia=rm%iamat(ind(1),ind(2),ind(3),ind(4))
        if(ia .eq. 0)then
          rm%nind=rm%nind+1
          if(rm%nind .gt. mlen(rm%iord))then
            write(*,*)'Insufficient matrix table ',rm%id,rm%iord,ind
            stop
          endif
          ia=rm%nind
          rm%ind(:,ia)=ind
          rm%iamat(ind(1),ind(2),ind(3),ind(4))=ia
          rm%cmat(:,:,ia)=(0.d0,0.d0)
        endif
        return
        end function

        subroutine spsetrm(am,ind,rm)
        implicit none
        type (scmat) rm
        integer*4 ind(4),ia
        complex*16 am(3,3)
        ia=iaind(rm,ind)
        rm%cmat(:,:,ia)=am
        return
        end subroutine

        subroutine spdotrm(rma,rmb,rmc)
        implicit none
        type (scmat) rma,rmb,rmc
        integer*4 indc(4),i,j,ia
        do i=1,rma%nind
          do j=1,rmb%nind
            indc=rma%ind(:,i)+rmb%ind(:,j)
            ia=iaind(rmc,indc)
            rmc%cmat(:,:,ia)=rmc%cmat(:,:,ia)
     $           +matmul(rma%cmat(:,:,i),rmb%cmat(:,:,j))
          enddo
        enddo
        return
        end subroutine

        subroutine spaddrm(rma,rmb,rmc)
        implicit none
        type (scmat) rma,rmb,rmc
        integer*4 ind(4),i,ic
        do i=1,rma%nind
          ind=rma%ind(:,i)
          ic=iaind(rmc,ind)
          rmc%cmat(:,:,ic)=rmc%cmat(:,:,ic)+rma%cmat(:,:,i)
        enddo
        do i=1,rmb%nind
          ind=rmb%ind(:,i)
          ic=iaind(rmc,ind)
          rmc%cmat(:,:,ic)=rmc%cmat(:,:,ic)+rmb%cmat(:,:,i)
        enddo
        return
        end subroutine

        subroutine spcopyrm(rma,rmb)
        implicit none
        type (scmat) rma,rmb
        integer*4 ind(4),i,ib
        do i=1,rma%nind
          ind=rma%ind(:,i)
          ib=iaind(rmb,ind)
          rmb%cmat(:,:,ib)=rma%cmat(:,:,i)
        enddo
        return
        end subroutine

        subroutine spintrm(rm,dx,amx,ams)
        implicit none
        type (scmat) rm
        real*8 dx,amx,ams
        complex*16 cm(3,3)
        integer*4 i,ia,ind(4)
        do i=1,rm%nind
          ind=rm%ind(:,i)
          cm=rm%cmat(:,:,i)/
     $         (1.d0-exp(dcmplx(-ind(2)*dx,ind(3)*amx+ind(4)*ams)));
c          write(*,*)'spintrm ',ind,
c     $         (1.d0-exp(dcmplx(-ind(2)*dx,ind(3)*amx+ind(4)*ams)))
          rm%cmat(:,:,i)=-cm
          ind(2:4)=0
          ia=iaind(rm,ind)
          rm%cmat(:,:,ia)=rm%cmat(:,:,ia)+cm
        enddo
        return
        end subroutine

        subroutine spmulrm(rm,cv,indv,rd)
        implicit none
        type (scmat) rm,rd
        complex*16 cv
        integer*4 i,indv(4),ind(4),ia
        do i=1,rm%nind
          ind=indv+rm%ind(:,i)
          ia=iaind(rd,ind)
          rd%cmat(:,:,ia)=rd%cmat(:,:,ia)+cv*rm%cmat(:,:,i)
        enddo
        return
        end subroutine

        subroutine spdepol(gxr,gxi,gyr,gyi,gzr,gzi,e1,e2,a,
     $     dx,amx,ams,rmd)
        implicit none
        integer*4 , parameter ::
     $       m1=1,  m2=2,  m3=3,  m4=4,  m5=5,  m6=6,
     $       mi1=7, mi2=8, mi3=9, mi4=10,mi5=11,mi6=12,
     $       mlast=mi6
        integer*4 , parameter ::
     $       iord(mlast)=(/
     $       1,2,3,4,5,6,
     $       1,2,3,4,5,6/)
        type (scmat) rm(mlast)
        integer*4 i,ia1,ia2,ia3,ia4,ia5,ia6,ia7,ia8,ia9,ia10,
     $       ia11,ia12,ia13,ia14,ia15,
     $       ia20,ia21,ia22,ia40,ia41,ia42,ia43,ia44,
     $       ia60,ia61,ia62,ia63,ia64,ia65,ia66
        complex*16 gx1,gy1,gz1,gx2,gy2,gz2,gyyzz,cg1,cg0
        complex*16 ,parameter :: cI=(0.d0,1.d0),c0=(0.d0,0.d0),
     $       c1=(1.d0,0.d0)
        real*8 gxr,gxi,gyr,gyi,gzr,gzi,dx,amx,ams,e1,e2,a
        real*8 , intent(out) :: rmd(3,3)
        do i=1,mlast
          call spinitrm(rm(i),iord(i),i)
        enddo
        gx1=dcmplx(gxr, gxi)
        gx2=dcmplx(gxr,-gxi)
        gy1=dcmplx( gyr+gzi, gzr-gyi)
        gy2=dcmplx( gyi-gzr,-gyr-gzi)
        gz1=dcmplx( gyr-gzi, gzr+gyi)
        gz2=dcmplx(-gyi-gzr,-gyr+gzi)
        ia1=iaind(rm(m1),(/0,1,-1,-1/))
        rm(m1)%cmat(:,:,ia1)=RESHAPE(0.25d0*gz2*(/
     $        c0,c1,cI,
     $       -c1,c0,c0,
     $       -cI,c0,c0/),(/3,3/))
        ia2=iaind(rm(m1),(/0,1,-1,0/))
        rm(m1)%cmat(:,:,ia2)=RESHAPE(0.5d0*gx2*(/
     $        c0,c0, c0,
     $        c0,c0,-c1,
     $        c0,c1, c0/),(/3,3/))
        ia3=iaind(rm(m1),(/0,1,-1,1/))
        rm(m1)%cmat(:,:,ia3)=RESHAPE(0.25d0*gy1*(/
     $        c0,cI,c1,
     $       -cI,c0,c0,
     $       -c1,c0,c0/),(/3,3/))
        ia4=iaind(rm(m1),(/1,1,1,-1/))
        rm(m1)%cmat(:,:,ia4)=conjg(rm(m1)%cmat(:,:,ia3))
        ia5=iaind(rm(m1),(/1,1,1,0/))
        rm(m1)%cmat(:,:,ia5)=conjg(rm(m1)%cmat(:,:,ia2))
        ia6=iaind(rm(m1),(/1,1,1,1/))
        rm(m1)%cmat(:,:,ia6)=conjg(rm(m1)%cmat(:,:,ia1))

        ia1=iaind(rm(m2),(/0,2,-2,-2/))
        rm(m2)%cmat(:,:,ia1)=RESHAPE((/
     $       c0, c0, c0,
     $       c0,-c1,-cI,
     $       c0,-cI, c1/)*gz2**2/32.d0,(/3,3/))
        ia2=iaind(rm(m2),(/0,2,-2,-1/))
        rm(m2)%cmat(:,:,ia2)=RESHAPE((/
     $        c0,cI,-c1,
     $        cI,c0, c0,
     $       -c1,c0, c0/)*gx2*gz2/16.d0,(/3,3/))
        ia3=iaind(rm(m2),(/0,2,-2,0/))
        rm(m2)%cmat(:,:,ia3)=RESHAPE((/
     $       -2.d0*cI*gy1*gz2,c0,c0,
     $       c0,-2.d0*gx2**2-cI*gy1*gz2,c0,
     $       c0,c0,-2.d0*gx2**2-cI*gy1*gz2/)/16.d0,(/3,3/))
        ia4=iaind(rm(m2),(/0,2,-2,1/))
        rm(m2)%cmat(:,:,ia4)=RESHAPE((/
     $        c0,c1,-cI,
     $        c1,c0, c0,
     $       -cI,c0, c0/)*gx2*gy1/16.d0,(/3,3/))
        ia5=iaind(rm(m2),(/0,2,-2,2/))
        rm(m2)%cmat(:,:,ia5)=RESHAPE((/
     $       c0, c0, c0,
     $       c0, c1,-cI,
     $       c0,-cI,-c1/)*gy1**2/32.d0,(/3,3/))
        ia6=iaind(rm(m2),(/1,2,0,-2/))
        rm(m2)%cmat(:,:,ia6)=RESHAPE((/
     $       c0, c0, c0,
     $       c0,-c1,-cI,
     $       c0,-cI, c1/)*gy2*gz2/16.d0,(/3,3/))
        ia7=iaind(rm(m2),(/1,2,0,-1/))
        rm(m2)%cmat(:,:,ia7)=RESHAPE((/
     $        c0,cI,-c1,
     $        cI,c0, c0,
     $       -c1,c0, c0/)*(gx2*gy2+gx1*gz2)/16.d0,(/3,3/))
        gyyzz=gy1*gy2+gz1*gz2
        ia8=iaind(rm(m2),(/1,2,0,0/))
        rm(m2)%cmat(:,:,ia8)=RESHAPE((/
     $       -2.d0*cI*gyyzz,c0,c0,
     $       c0,-4.d0*gx1*gx2-cI*gyyzz,c0,
     $       c0,c0,-4.d0*gx1*gx2-cI*gyyzz/)/16.d0,(/3,3/))
        ia9=iaind(rm(m2),(/1,2,0,1/))
        rm(m2)%cmat(:,:,ia9)=RESHAPE((/
     $        c0,c1,-cI,
     $        c1,c0, c0,
     $       -cI,c0, c0/)*(gx1*gy1+gx2*gz1)/16.d0,(/3,3/))
        ia10=iaind(rm(m2),(/1,2,0,2/))
        rm(m2)%cmat(:,:,ia10)=RESHAPE((/
     $       c0, c0, c0,
     $       c0, c1,-cI,
     $       c0,-cI,-c1/)*gy1*gz1/16.d0,(/3,3/))
        ia11=iaind(rm(m2),(/2,2,2,-2/))
        rm(m2)%cmat(:,:,ia11)=conjg(rm(m2)%cmat(:,:,ia5))
        ia12=iaind(rm(m2),(/2,2,2,-1/))
        rm(m2)%cmat(:,:,ia12)=conjg(rm(m2)%cmat(:,:,ia4))
        ia13=iaind(rm(m2),(/2,2,2,0/))
        rm(m2)%cmat(:,:,ia13)=conjg(rm(m2)%cmat(:,:,ia3))
        ia14=iaind(rm(m2),(/2,2,2,1/))
        rm(m2)%cmat(:,:,ia14)=conjg(rm(m2)%cmat(:,:,ia2))
        ia15=iaind(rm(m2),(/2,2,2,2/))
        rm(m2)%cmat(:,:,ia15)=conjg(rm(m2)%cmat(:,:,ia1))

        call spcopyrm(rm(m1),rm(mi1))
        call spintrm(rm(mi1),dx,amx,ams)
        call spcopyrm(rm(m2),rm(mi2))
        call spdotrm(rm(m1),rm(mi1),rm(mi2))
        call spintrm(rm(mi2),dx,amx,ams)

        cg1=.25d0*(gx1**2+ci*gy2*gz1)
        cg0=.25d0*(2.d0*gx1*gx2+ci*gyyzz)
        call spmulrm(rm(m1),-cg1/6.d0,(/2,2,2,0/),rm(m3))
        call spmulrm(rm(m1),-conjg(cg1)/6.d0,(/0,2,-2,0/),rm(m3))
        call spmulrm(rm(m1),-cg0/6.d0,(/1,2,0,0/),rm(m3))
        call spcopyrm(rm(m3),rm(mi3))
        call spdotrm(rm(m1),rm(mi2),rm(mi3))
        call spdotrm(rm(m2),rm(mi1),rm(mi3))
        call spintrm(rm(mi3),dx,amx,ams)

        call spmulrm(rm(m2),-cg1/12.d0,(/2,2,2,0/),rm(m4))
        call spmulrm(rm(m2),-conjg(cg1)/12.d0,(/0,2,-2,0/),rm(m4))
        call spmulrm(rm(m2),-cg0/12.d0,(/1,2,0,0/),rm(m4))
        call spcopyrm(rm(m4),rm(mi4))
        call spdotrm(rm(m1),rm(mi3),rm(mi4))
        call spdotrm(rm(m2),rm(mi2),rm(mi4))
        call spdotrm(rm(m3),rm(mi1),rm(mi4))
        call spintrm(rm(mi4),dx,amx,ams)

        call spmulrm(rm(m3),-cg1/20.d0,(/2,2,2,0/),rm(m5))
        call spmulrm(rm(m3),-conjg(cg1)/20.d0,(/0,2,-2,0/),rm(m5))
        call spmulrm(rm(m3),-cg0/20.d0,(/1,2,0,0/),rm(m5))
        call spcopyrm(rm(m5),rm(mi5))
        call spdotrm(rm(m1),rm(mi4),rm(mi5))
        call spdotrm(rm(m2),rm(mi3),rm(mi5))
        call spdotrm(rm(m3),rm(mi2),rm(mi5))
        call spdotrm(rm(m4),rm(mi1),rm(mi5))
        call spintrm(rm(mi5),dx,amx,ams)

        call spmulrm(rm(m4),-cg1/30.d0,(/2,2,2,0/),rm(m6))
        call spmulrm(rm(m4),-conjg(cg1)/20.d0,(/0,2,-2,0/),rm(m6))
        call spmulrm(rm(m4),-cg0/30.d0,(/1,2,0,0/),rm(m6))
        call spcopyrm(rm(m6),rm(mi6))
        call spdotrm(rm(m1),rm(mi5),rm(mi6))
        call spdotrm(rm(m2),rm(mi4),rm(mi6))
        call spdotrm(rm(m3),rm(mi3),rm(mi6))
        call spdotrm(rm(m4),rm(mi2),rm(mi6))
        call spdotrm(rm(m5),rm(mi1),rm(mi6))
        call spintrm(rm(mi6),dx,amx,ams)

        ia20=iaind(rm(mi2),(/0,0,0,0/))
        ia21=iaind(rm(mi2),(/1,0,0,0/))
        ia22=iaind(rm(mi2),(/2,0,0,0/))
        ia40=iaind(rm(mi4),(/0,0,0,0/))
        ia41=iaind(rm(mi4),(/1,0,0,0/))
        ia42=iaind(rm(mi4),(/2,0,0,0/))
        ia43=iaind(rm(mi4),(/3,0,0,0/))
        ia44=iaind(rm(mi4),(/4,0,0,0/))
        ia60=iaind(rm(mi6),(/0,0,0,0/))
        ia61=iaind(rm(mi6),(/1,0,0,0/))
        ia62=iaind(rm(mi6),(/2,0,0,0/))
        ia63=iaind(rm(mi6),(/3,0,0,0/))
        ia64=iaind(rm(mi6),(/4,0,0,0/))
        ia65=iaind(rm(mi6),(/5,0,0,0/))
        ia66=iaind(rm(mi6),(/6,0,0,0/))
        rmd=(e1+e2)*dble(rm(mi2)%cmat(:,:,ia21))
     $     +(e1-e2)*(dble(rm(mi2)%cmat(:,:,ia20))
     $              +dble(rm(mi2)%cmat(:,:,ia22)))
     $     +(e1-e2)*(3.d0*(e1-e2)*(dble(rm(mi4)%cmat(:,:,ia40))
     $                            +dble(rm(mi4)%cmat(:,:,ia44)))
     $             +(3.d0*(e1+e2)+2.d0*a)
     $                *(dble(rm(mi4)%cmat(:,:,ia41))
     $                 +dble(rm(mi4)%cmat(:,:,ia43))))
     $     +(2.d0*(a*(e1+e2)+e1*e2)+3.d0*(e1**2+e2**2))
     $        *dble(rm(mi4)%cmat(:,:,ia42))
     $     +(e1-e2)*(3.d0*(e1-e2)*(
     $         5.d0*(e1-e2)*(dble(rm(mi6)%cmat(:,:,ia60))
     $                      +dble(rm(mi6)%cmat(:,:,ia66)))
     $        +(2.d0*a+5.d0*(e1+e2))*(dble(rm(mi6)%cmat(:,:,ia61))
     $                               +dble(rm(mi6)%cmat(:,:,ia65))))
     $       +(2.d0*a*(4.d0*a+3.d0*(e1+e2))
     $         +15.d0*(e1**2+e2**2)+18.d0*e1*e2)
     $           *(dble(rm(mi6)%cmat(:,:,ia62))
     $            +dble(rm(mi6)%cmat(:,:,ia64))))
     $     +(a*(8.d0*a*(e1+e2)+6.d0*(e1**2+e2**2)+4.d0*e1*e2)
     $      +3.d0*(e1+e2)*(5.d0*(e1**2+e2**2)-2.d0*e1*e2))
     $       *dble(rm(mi6)%cmat(:,:,ia63))
c     $       +(4.d0+1.d0/dx)*(e1+e2)**2*dble(rm(mi4)%cmat(:,:,ia42))
c     $       +(24.d0+(8.d0+8.d0/dx)/dx)*dble(rm(mi6)%cmat(:,:,ia6))
        
        do i=1,mlast
          deallocate(rm(i)%cmat)
          deallocate(rm(i)%iamat)
          deallocate(rm(i)%ind)
        enddo
        return
        end subroutine

        subroutine tradkf1(x,px,y,py,z,g,dv,sx,sy,sz,
     $     px00,py0,zr0,cphi0,sphi0,bsi,al)
        use tfstk, only:pxy2dpz,p2h
        use ffs_flag
        use tmacro
        implicit none
        real*8, parameter:: gmin=-0.9999d0,
     $       cave=8.d0/15.d0/sqrt(3.d0)
        real*8 x,px,y,py,z,g,dv,px0,py0,zr0,bsi,al,
     $       dpx,dpy,dpz,dpz0,ppx,ppy,ppz,theta,pr,p,anp,dg,
     $       pxm,pym,al1,uc,ddpx,ddpy,h1,p2,h2,sx,sy,sz,
     $       ppa,an,a,dph,r1,r2,px00,cphi0,sphi0
        dpz0=pxy2dpz(px00,py0)
        px0= cphi0*px00+sphi0*(1.d0+dpz0)
        dpz0=cphi0*dpz0-sphi0*px00
        dpx=px-px0
        dpy=py-py0
        dpz=pxy2dpz(px,py)
        dpz0=pxy2dpz(px0,py0)
        ppx=py*dpz0-dpz*py0+dpy
        ppy=dpz*px0-px*dpz0-dpx
        ppz=px*py0-py*px0
        ppa=abs(dcmplx(ppx,abs(dcmplx(ppy,ppz))))
        theta=asin(min(1.d0,max(-1.d0,ppa)))
        pr=1.d0+g
        p=p0*pr
        h1=p2h(p)
        anp=anrad*p*theta
        call tdusrn(anp,dph,r1,r2,an)
        if(an .ne. 0.d0)then
          al1=al-z+zr0
c          al1=al*(1.d0+(dldx*pxm**2+pym**2)*.5d0)
          uc=cuc*h1**3/p0*theta/al1
          dg=-dph*uc
          g=max(gmin,g+dg)
          ddpx=-r1*dpx*dg
          ddpy=-r1*dpy*dg
          x=x+r2*ddpx*al
          y=y+r2*ddpy*al
          px=px+ddpx
          py=py+ddpy
          pr=1.d0+g
          p2=p0*pr
          h2=p2h(p2)
          dv=-g*(1.d0+pr)/h2/(h2+p2)+dvfs
          h1=p2h(p)
          z=z*p2/h2*h1/p
          if(calpol)then
            if(ppa .ne. 0.d0)then
              a=theta/ppa
            else
              a=0.d0
            endif
            pxm=px0+dpx*.5d0
            pym=py0+dpy*.5d0
            call sprot(sx,sy,sz,pxm,pym,
     $           ppx,ppy,ppz,bsi,a,
     $           al1,p2,h2,an,cphi0,sphi0)
          endif
        elseif(calpol)then
          if(ppa .ne. 0.d0)then
            a=theta/ppa
          else
            a=0.d0
          endif
          pxm=px0+dpx*.5d0
          pym=py0+dpy*.5d0
          call sprot(sx,sy,sz,pxm,pym,ppx,ppy,ppz,bsi,a,
     $         al,p,h1,-1.d0,cphi0,sphi0)
        endif
        return
        end subroutine

        subroutine tradk1(x,px,y,py,z,g,dv,sx,sy,sz,
     $     px00,py0,zr0,cphi0,sphi0,bsi,al)
        use tfstk, only:pxy2dpz,p2h
        use ffs_flag
        use tmacro
        implicit none
        real*8 x,px,y,py,z,g,dv,px0,py0,zr0,bsi,al,a,
     $       dpz,dpz0,ppx,ppy,ppz,theta,pr,p,anp,dg,dpx,dpy,
     $       pxm,pym,al1,uc,ddpx,ddpy,h2,h1,sx,sy,sz,ppa,p2,
     $       cphi0,sphi0,px00
        real*8, parameter:: gmin=-0.9999d0,
     $       cave=8.d0/15.d0/sqrt(3.d0)
        dpz0=pxy2dpz(px00,py0)
        px0= cphi0*px00+sphi0*(1.d0+dpz0)
        dpz0=cphi0*dpz0-sphi0*px00
        dpx=px-px0
        dpy=py-py0
        dpz=pxy2dpz(px,py)
        ppx=py*dpz0-dpz*py0+dpy
        ppy=dpz*px0-px*dpz0-dpx
        ppz=px*py0-py*px0
        ppa=abs(dcmplx(ppx,abs(dcmplx(ppy,ppz))))
        theta=asin(min(1.d0,max(-1.d0,ppa)))
        pr=1.d0+g
        p=p0*pr
        h1=p2h(p)
        al1=al-z+zr0
c        al1=al*(1.d0+(dldx*pxm**2+pym**2)*.5d0)
        anp=anrad*p*theta
        uc=cuc*h1**3/p0*theta/al1
        dg=-cave*anp*uc
        g=max(gmin,g+dg)
        ddpx=-.5d0*dpx*dg
        ddpy=-.5d0*dpy*dg
        x=x+ddpx*al/3.d0
        y=y+ddpy*al/3.d0
        px=px+ddpx
        py=py+ddpy
        pr=1.d0+g
        p2=p0*pr
        h2=p2h(p2)
        dv=-g*(1.d0+pr)/h2/(h2+p2)+dvfs
        z=z*p2/h2*h1/p
        if(calpol)then
          if(ppa .ne. 0.d0)then
            a=theta/ppa
          else
            a=0.d0
          endif
          pxm=px0+dpx*.5d0
          pym=py0+dpy*.5d0
          call sprot(sx,sy,sz,pxm,pym,ppx,ppy,ppz,bsi,a,
     $         al1,p2,h2,anp,cphi0,sphi0)
        endif
        return
        end subroutine

        subroutine sprot(sx,sy,sz,pxm,pym,bx0,by0,bz0,bsi,a,
     $     al,p,h,anph,cphi0,sphi0)
        use tfstk,only:pxy2dpz,ktfenanq,sqrt1
        use tmacro
        use ffs_flag, only:radpol
        implicit none
        real*8 pxm,pym,bsi,h,pzm,bx0,by0,bz0,sx,sy,sz,cphi0,sphi0,
     $       bx,by,bz,bp,blx,bly,blz,btx,bty,btz,ct,
     $       gx,gy,gz,g,a,p,al,dsx,dsy,dsz,
     $       gnx,gny,gnz,
     $       sux,suy,suz,
     $       tnx,tny,tnz,
     $       bt,st,dst,dr,sl1,st1,
     $       sw,anph,cosu,sinu,dcosu,sx0
        real*8 , parameter :: cl=1.d0+gspin
        pzm=1.d0+pxy2dpz(pxm,pym)
        bx=bx0*a*p/p0
        by=by0*a*p/p0
        bz=bz0*a*p/p0+bsi
        bp=bx*pxm+by*pym+bz*pzm
        blx=bp*pxm
        bly=bp*pym
        blz=bp*pzm
        btx=bx-blx
        bty=by-bly
        btz=bz-blz
        dsx=0.d0
        dsy=0.d0
        dsz=0.d0
        if(anph .gt. 0.d0 .and. radpol)then
          bt=abs(dcmplx(btx,abs(dcmplx(bty,btz))))
          if(bt .ne. 0.d0)then
            tnx=btx/bt
            tny=bty/bt
            tnz=btz/bt
            st=sx*tnx+sy*tny+sz*tnz
            dst=(st-pst)*sflc*anph*(bt*h*p/al)**2
            if(st .ne. 1.d0)then
              dr=dst/(1.d0-st**2)
              dsx=dr*sx
              dsy=dr*sy
              dsz=dr*sz
            else
              st1=st-dst
              sl1=sqrt(1-st1**2)
              sx=sl1*pxm+st1*tnx
              sy=sl1*pym+st1*tny
              sz=sl1*pzm+st1*tnz
            endif
          else
            tnx=0.d0
            tny=0.d0
            tnz=0.d0
          endif
        else
          tnx=0.d0
          tny=0.d0
          tnz=0.d0
        endif
        ct=1.d0+h*gspin
        gx=ct*btx+cl*blx+dsy*tnz-dsz*tny
        gy=ct*bty+cl*bly+dsz*tnx-dsx*tnz
        gz=ct*btz+cl*blz+dsx*tny-dsy*tnx
        g=abs(dcmplx(gx,abs(dcmplx(gy,gz))))
        if(g .ne. 0.d0)then
c          write(*,'(a,1p9g14.6)')'sprot ',g,ct,h,
c     $         btx,bty,btz,cphi0,sphi0
          gnx=gx/g
          gny=gy/g
          gnz=gz/g
          sinu=sin(g)
          dcosu=2.d0*sin(g*.5d0)**2
          cosu=1.d0-dcosu
          sw=(sx*gnx+sy*gny+sz*gnz)*dcosu
          sux=sy*gnz-sz*gny
          suy=sz*gnx-sx*gnz
          suz=sx*gny-sy*gnx
          sx=cosu*sx+sinu*sux+sw*gnx
          sy=cosu*sy+sinu*suy+sw*gny
          sz=cosu*sz+sinu*suz+sw*gnz
        endif
        sx0=sx
        sx= sx0*cphi0+sz*sphi0
        sz=-sx0*sphi0+sz*cphi0
        return
        end subroutine
      
        subroutine spnorm(srot,sps,smu)
        implicit none
        real*8 , intent(inout) :: srot(3,9)
        real*8 , intent(out) :: sps(3,3),smu
        real*8 s,a(3,3),w(3,3),eig(2,3),dr(3),dsps(3),
     $       cm,sm,spsa1(3)
        real*8 , parameter :: smin=1.d-4
        integer*4 i
        s=abs(dcmplx(srot(1,2),abs(dcmplx(srot(2,2),srot(3,2)))))
        srot(:,2)=srot(:,2)/s
        s=srot(1,1)*srot(1,2)+srot(2,1)*srot(2,2)+srot(3,1)*srot(3,2)
        srot(:,1)=srot(:,1)-s*srot(:,2)
        s=abs(dcmplx(srot(1,1),abs(dcmplx(srot(2,1),srot(3,1)))))
        srot(:,1)=srot(:,1)/s
        srot(1,3)=srot(2,1)*srot(3,2)-srot(2,2)*srot(3,1)
        srot(2,3)=srot(3,1)*srot(1,2)-srot(3,2)*srot(1,1)
        srot(3,3)=srot(1,1)*srot(2,2)-srot(1,2)*srot(2,1)
        sps(1,1)=srot(2,3)-srot(3,2)
        sps(2,1)=srot(3,1)-srot(1,3)
        sps(3,1)=srot(1,2)-srot(2,1)
        s=abs(dcmplx(sps(1,1),abs(dcmplx(sps(2,1),sps(3,1)))))
        if(s .lt. smin)then
          a=srot(:,1:3)
          call teigen(a,w,eig,3,3)
          do i=1,3
            if(eig(2,i) .eq. 0.d0)then
              sps(:,1)=a(:,i)
              s=abs(dcmplx(sps(1,1),abs(dcmplx(sps(2,1),sps(3,1)))))
              exit
            endif
          enddo
        endif
        sps(:,1)=sps(:,1)/s
        dr=sps(:,1)-srot(:,1)*sps(1,1)-srot(:,2)*sps(2,1)
     $       -srot(:,3)*sps(3,1)
        a=srot(:,1:3)
        a(1,1)=a(1,1)-1.d0
        a(2,2)=a(2,2)-1.d0
        a(3,3)=a(3,3)-1.d0
        call tsolvg(a,dr,dsps,3,3,3)
        sps(:,1)=sps(:,1)+dsps
        s=abs(dcmplx(sps(1,1),abs(dcmplx(sps(2,1),sps(3,1)))))
        sps(:,1)=sps(:,1)/s
        if(abs(min(sps(1,1),sps(2,1),sps(3,1)))
     $       .gt. abs(max(sps(1,1),sps(2,1),sps(3,1))))then
          sps(:,1)=-sps(:,1)
        endif
        dr=sps(:,1)-srot(:,1)*sps(1,1)-srot(:,2)*sps(2,1)
     $       -srot(:,3)*sps(3,1)
        sps(:,2)=0.d0
        if(abs(sps(1,1)) .gt. abs(sps(2,1)))then
          sps(2,2)=1.d0
          s=sps(2,1)
        else
          sps(1,2)=1.d0
          s=sps(1,1)
        endif
        sps(:,2)=sps(:,2)-s*sps(:,1)
        s=abs(dcmplx(sps(1,2),abs(dcmplx(sps(2,2),sps(3,2)))))
        sps(:,2)=sps(:,2)/s
        sps(1,3)=sps(2,1)*sps(3,2)-sps(3,1)*sps(2,2)
        sps(2,3)=sps(3,1)*sps(1,2)-sps(1,1)*sps(3,2)
        sps(3,3)=sps(1,1)*sps(2,2)-sps(2,1)*sps(1,2)
        spsa1=srot(:,1)*sps(1,2)+srot(:,2)*sps(2,2)+srot(:,3)*sps(3,2)
        cm=spsa1(1)*sps(1,2)+spsa1(2)*sps(2,2)+spsa1(3)*sps(3,2)
        sm=spsa1(1)*sps(1,3)+spsa1(2)*sps(2,3)+spsa1(3)*sps(3,3)
        smu=atan(-sm,cm)
c        write(*,'(a,1p8g15.7)')'spnorm ',sps(:,1),smu/2.d0/pi,dr
        return
        end subroutine 

        subroutine sremit(srot,sps,params,emit,demit,rm1,equpol)
        use temw
        use macmath
        implicit none
        real*8 , intent(in)::srot(3,9),emit(21),demit(21),sps(3,3),
     $       params(nparams)
        real*8 , intent(out)::equpol,rm1(3,3)
        real*8 drot(3,6),
     $       d1,d2,d3,d4,d5,d6,e1,e2,e3,e4,e5,e6,
     $       c1,c2,c3,c4,c5,c6,dpol,smu,c,s,tx,c60,
     $       dex1,dex2,dey1,dey2,dez1,dez2,
     $       c1a,c3a,c5a,d1a,d3a,d5a,e1a,e3a,e5a,
     $       rm(3,3),rmx(3,3),rmy(3,3),rmz(3,3),epol(3),b(3)
        integer*4 k
c        write(*,'(1p3g15.7)')(rm(k,:),k=1,3)
        smu=params(ipnup)*m_2pi
        dpol=1.d0/(params(iptaup)*params(iprevf))
        drot=matmul(srot(:,4:9),r)
        c1a=dot_product(drot(:,1),sps(:,1))
        c2 =dot_product(drot(:,2),sps(:,1))
        c3a=dot_product(drot(:,3),sps(:,1))
        c4 =dot_product(drot(:,4),sps(:,1))
        c5a=dot_product(drot(:,5),sps(:,1))
        c6 =dot_product(drot(:,6),sps(:,1))
        d1a=dot_product(drot(:,1),sps(:,2))
        d2 =dot_product(drot(:,2),sps(:,2))
        d3a=dot_product(drot(:,3),sps(:,2))
        d4 =dot_product(drot(:,4),sps(:,2))
        d5a=dot_product(drot(:,5),sps(:,2))
        d6 =dot_product(drot(:,6),sps(:,2))
        e1a=dot_product(drot(:,1),sps(:,3))
        e2 =dot_product(drot(:,2),sps(:,3))
        e3a=dot_product(drot(:,3),sps(:,3))
        e4 =dot_product(drot(:,4),sps(:,3))
        e5a=dot_product(drot(:,5),sps(:,3))
        e6 =dot_product(drot(:,6),sps(:,3))
        tx=.5d0*atan(2.d0*demit(2),demit(1)-demit(3))
        c=cos(tx)
        s=sin(tx)
        dex1=c**2*demit(1)+s**2*demit(3)+2.d0*c*s*demit(2)
        dex2=c**2*demit(3)+s**2*demit(1)-2.d0*c*s*demit(2)
        c1= c*c1a-s*c2
        c2= s*c1a+c*c2
        d1= c*d1a-s*d2
        d2= s*d1a+c*d2
        e1= c*e1a-s*e2
        e2= s*e1a+c*e2
        tx=.5d0*atan(2.d0*demit(9),demit(6)-demit(10))
        c=cos(tx)
        s=sin(tx)
        dey1=c**2*demit(6) +s**2*demit(10)+2.d0*c*s*demit(9)
        dey2=c**2*demit(10)+s**2*demit(6) -2.d0*c*s*demit(9)
        c3= c*c3a-s*c4
        c4= s*c3a+c*c4
        d3= c*d3a-s*d4
        d4= s*d3a+c*d4
        e3= c*e3a-s*e4
        e4= s*e3a+c*e4
        tx=.5d0*atan(2.d0*demit(20),demit(15)-demit(21))
        c=cos(tx)
        s=sin(tx)
        dez1=c**2*demit(15)+s**2*demit(21)+2.d0*c*s*demit(20)
        dez2=c**2*demit(21)+s**2*demit(15)-2.d0*c*s*demit(20)
        c60=c6
        c5= c*c5a-s*c6
        c6= s*c5a+c*c6
        d5= c*d5a-s*d6
        d6= s*d5a+c*d6
        e5= c*e5a-s*e6
        e6= s*e5a+c*e6
c        write(*,'(a,1p10g12.4)')'sremit ',tx,
c     $       demit(15),demit(20),demit(21),dez1,dez2,c5,c6,c5a,c60
        call spdepol(c3,c2,d1,d2,e1,e2,dex1,dex2,
     $       .5d0*(emit(1)+emit(3)),
     $       -params(ipdampx),params(ipnx)*m_2pi,smu,rmx)
        call spdepol(c3,c4,d3,d4,e3,e4,dey1,dey2,
     $       .5d0*(emit(6)+emit(10)),
     $       -params(ipdampy),params(ipny)*m_2pi,smu,rmy)
        call spdepol(c5,c6,d5,d6,e5,e6,dez1,dez2,
     $       .5d0*(emit(15)+emit(21)),
     $       -params(ipdampz),params(ipnz)*m_2pi,smu,rmz)
        rm=rmx+rmy+rmz
        write(*,'(1p9g13.5)')(rmx(k,:),rmy(k,:),rmz(k,:),k=1,3)
        rm(1,1)=rm(1,1)-dpol
        rm1=rm
        b=(/-dpol*pst,0.d0,0.d0/)
        call tsolvg(rm,b,epol,3,3,3)
        equpol=epol(1)
        return
        end subroutine

        subroutine tsrot(srot,rr)
        implicit none
        real*8 , intent(inout)::srot(3,9)
        real*8 , intent(in)::rr(3,3)
        integer*4 i
        do i=1,9
          srot(:,i)=rr(:,1)*srot(1,i)
     $         +rr(:,2)*srot(2,i)+rr(:,3)*srot(3,i)
        enddo
        return
        end subroutine

      end module

      subroutine temit(trans,cod,beam,btr,
     $     calem,iatr,iacod,iabmi,iamat,
     $     plot,params,stab,lfno)
      use tfstk
      use temw
      use ffs_flag
      use ffs_pointer
      use tmacro
      use tffitcode
      use tspin, only:spnorm,sremit
      implicit none
      real*8 conv
      parameter (conv=1.d-12)
      integer*8 iatr,iacod,iamat,iabmi
      integer*4 lfno,ia,it,i,j,k,k1,k2,k3,m,n,iret,l
      real*8 trans(6,12),cod(6),beam(42),srot(3,9),srot1(3,3),
     $     emx0,emy0,emz0,dl,equpol,
     $     heff,phirf,omegaz,bh,so,s,
     $     sr,sqr2,bb,bbv(21),sige,
     $     emxr,emyr,emzr,xxs,yys,btilt,
     $     sig1,sig2,sigx,sigy,tune,sigz,
     $     emxmin,emymin,emzmin,emxmax,emymax,emzmax,
     $     emxe,emye,emze,dc,smu,
     $     transs(6,12),beams(21),rsav(6,6),risav(6,6)
      complex*16 cc(6),cd(6),ceig(6),ceig0(6),dceig(6)
      real*8 btr(21,21),emit(21),emit1(42),beam1(42),
     1     beam2(21),params(nparams),codold(6),ab(6),
     $     sps(3,3),spm(3,3)
      real*8 demin,rgetgl1
      character*10 label1(6),label2(6)
      character*11 autofg,vout(nparams)
      character*9 vout9(nparams)
      logical*4 plot,pri,fndcod,synchm,intend,stab,calem,
     $     epi,calcodr,rt,radpol0
      data label1/'        X ','       Px ','        Y ',
     1            '       Py ','        Z ','       Pz '/
      data label2/'        x ','    px/p0 ','        y ',
     1            '    py/p0 ','        z ','    dp/p0 '/
      ia(m,n)=((m+n+abs(m-n))**2+2*(m+n)-6*abs(m-n))/8
      it=0
      trf0=0.d0
      vcalpha=1.d0
      epsrad=1.d-6
      demin=1.d100
      calint=.false.
      intend=.false.
      epi=.false.
      radpol0=radpol
      cod=codin
      beam(1:21)=beamin
      beam(22:42)=0.d0
      codold=10.d0
      params=0.d0
      ceig0=(0.d0,0.d0)
      emxe=rgetgl1('EMITXE')
      emye=rgetgl1('EMITYE')
      emze=rgetgl1('EMITZE')
      call tsetdvfs
      emx0=0.d0
      emy0=0.d0
      emz0=0.d0
      emxmin=1.d-100
      emymin=1.d-100
      emzmin=1.d-100
      emxmax=1.d100
      emymax=1.d100
      emzmax=1.d100
      irad=6
      caltouck=.false.
      calcodr=.not. trpt .and. calcod
      pri=lfno .gt. 0
      rt=radcod .and. radtaper
      if(calcodr)then
c
c zero clear initial cod (comment out by Y.O, 2010/10/28)
c
c        call tclr(cod,6)
c        write(*,*)'temit-cod-0'
        call tcod(trans,cod,beam,fndcod)
c        write(*,*)'temit-cod-1 ',fndcod
        if(.not. fndcod)then
          write(lfno,*)'???-Emittance[]-closed orbit not found.'
        endif
        codin=cod
c        write(*,*)'temit-tcod ',trf0
        if(pri)then
          write(lfno,*)
          write(lfno,*)'   Closed orbit:'
          write(lfno,'(10X,6A)')label2
          call tput(cod,label2,' Entrance ','9.6',1,lfno)
        endif
      elseif(calem)then
        if(pri)then
          write(lfno,*)
          write(lfno,*)'   Closed orbit:'
          write(lfno,'(10X,6A)')label2
          call tput(codin,label2,' Entrance ','9.6',1,lfno)
        endif
      else
        if(pri)then
          write(lfno,*)
          write(lfno,*)'   Closed orbit:'
          write(lfno,'(10X,6A)')label2
          call tput(cod,label2,' Entrance ','9.6',1,lfno)
        endif
        call tinitr12(trans)
        call tturne(trans,cod,beam,srot,int8(0),int8(0),int8(0),
     $       .false.,.false.,rt)
      endif
      irad=12
 4001 if(calem)then
        cod=codin
        beam(1:21)=beamin
c        call tclr(beam,21)
        call tinitr12(trans)
c        write(*,*)'temit ',trf0,cod
        srot=0.d0
        srot(1,1)=1.d0
        srot(2,2)=1.d0
        call tsetr0(trans,cod,0.d0,0.d0)
        call tturne(trans,cod,beam,srot,int8(0),int8(0),int8(0),
     1       .false.,.false.,rt)
      endif
c     call tsymp(trans)
      params(iprevf)=omega0/m_2pi
      params(ipdx:ipddp)=cod
      if(pri)then
        call tput(cod,label2,'     Exit ','9.6',1,lfno)
        write(lfno,*)
      endif
      transs=trans
      if(trpt)then
        beams=beamin(1:21)
      else
        beams=beam(1:21)
      endif
 3101 r=trans(:,1:6)
      if(pri .and. emiout)then
        write(lfno,*)'   Symplectic part of the transfer matrix:'
        call tput(trans,label2,label2,'9.6',6,lfno)
        call tinv6(r,ri)
        call tmultr(ri,trans,6)
        call tput(ri,label2,label2,'9.6',6,lfno)
      endif
      if(.not. rfsw)then
        r(6,1)=0.d0
        r(6,2)=0.d0
        r(6,3)=0.d0
        r(6,4)=0.d0
        r(6,5)=0.d0
        r(6,6)=1.d0
      endif
      call teigen(r,ri,ceig,6,6)
      call tnorm(r,ceig,lfno)
      call tsub(ceig,ceig0,dceig,12)
      ceig0=ceig
      call tsymp(r)
      call tinv6(r,ri)
      call tmultr(trans,ri,6)
      call tmov(r,btr,36)
      call tmultr(btr,trans,6)
      if(pri .and. emiout)then
        call tput(btr,label1,label1,'9.6',6,lfno)
      endif
      if(iamat .gt. 0)then
        dlist(iamat+4)=
     $       dtfcopy1(kxm2l(ri,6,6,6,.false.))
        dlist(iamat+1)=
     $       dtfcopy1(kxm2l(codin,0,6,1,.false.))
      endif
      dl=btr(14,2)
      do i=1,3
        cc(i*2-1)=ceig(i*2-1)
        cc(i*2  )=conjg(cc(i*2-1))
        cd(i+3)=log(cc(i*2-1))
      enddo
      if(vceff .ne. 0.d0)then
        phirf=asin(u0*pgev/vceff)
        heff=wrfeff*cveloc/omega0
      else
        phirf=0.d0
        heff=0.d0
      endif
      synchm=rfsw .and. imag(cd(6)) .ne. 0.d0
      if(synchm)then
        if(wrfeff .ne. 0.d0)then
          alphap=-imag(cd(6))*abs(imag(cd(6)))/(c*pi2/omega0)
     $         /(dvcacc/pgev)
        else
          alphap=0.d0
        endif
        omegaz=abs(imag(cd(6)))*omega0/pi2
      else
        alphap=-dl/pi2/cveloc/p0*h0*omega0
        omegaz=sqrt(abs(alphap*pi2*heff*vceff/pgev*cos(phirf)))
     $       *omega0/pi2
      endif
c      write(*,'(a,1p5g15.7)')'temit ',omegaz,heff,alphap,vceff,phirf
      if(vceff .ne. 0.d0)then
        bh=sqrt(abs(vceff/pi/abs(alphap)/heff/pgev*
     1        (2.d0*cos(phirf)-(pi-2.d0*phirf)*u0*pgev/vceff)))
      else
        bh=0.d0
      endif
      stab=(abs(dble(cd(4))) .lt. 1.d-6
     $     .and. abs(dble(cd(5))) .lt. 1.d-6
     1     .and. abs(dble(cd(6))) .lt. 1.d-6) .and. fndcod
      params(ipnx:ipnz)=imag(cd(4:6))/pi2
      params(ipu0)=u0*pgev
      params(ipvceff)=vceff
      params(iptrf0)=trf0
      params(ipalphap)=alphap
      params(ipdleng)=dleng
      params(ipbh)=bh
      params(ipheff)=heff
      call tfetwiss(ri,cod,params(iptwiss),.true.)
      if(pri)then
        if(lfno .gt. 0)then
          do i=1,ntwissfun
            vout9(i)=autofg(params(iptws0+i),'9.6')(1:9)
          enddo
          write(lfno,9001)
     $         vout9(mfitax),vout9(mfitbx),vout9(mfitzx),vout9(mfitex),
     $         vout9(mfitnx),vout9(mfitzpx),vout9(mfitey),
     $         vout9(mfitr1),vout9(mfitr2),vout9(mfitay),vout9(mfitby),
     $         vout9(mfitzy),vout9(mfitey),
     $         vout9(mfitr3),vout9(mfitr4),vout9(mfitny),
     $         vout9(mfitzpy),vout9(mfitepy),
     $         vout9(mfitaz),vout9(mfitbz),vout9(mfitnz)
 9001     format('    Extended Twiss Parameters:',/,
     $         'AX:',a,' BX:',a,              26x,'  ZX:',a,'  EX:',a,/
     $         11x,'PSIX:',a,              26x,' ZPX:',a,' EPX:',a,/
     $         'R1:',a,' R2:',a,' AY:',a,' BY:',a,'  ZY:',a,'  EY:',a,/
     $         'R3:',a,' R4:',a,    12x,'PSIY:',a,' ZPY:',a,' EPY:',a,/
     $         51x,'  AZ:',a,'  BZ:',a,/
     $         65x,'PSIZ:',a,/
     $         '    Units: B(X,Y,Z), E(X,Y), R2: m ',
     $         '| PSI(X,Y,Z): radian | ZP(X,Y), R3: 1/m',/)
        endif
        vout(1) =autofg(pgev/1.d9       ,'10.7')
        vout(2) =autofg(omega0/pi2      ,'10.7')
        vout(3) =autofg(u0*pgev/1.d6    ,'10.7')
        vout(4) =autofg(vceff/1.d6      ,'10.7')
        vout(5) =autofg(trf0*1.d3       ,'10.7')
        vout(6) =autofg(alphap          ,'10.7')
        vout(7) =autofg(-dleng*1.d3     ,'10.7')
        vout(8) =autofg(heff            ,'10.7')
        vout(9) =autofg(bh              ,'10.7')
        vout(10)=autofg(omegaz/pi2      ,'10.7')
        write(lfno,9101)vout(1:10)(1:10)
9101    format(   'Design momentum      P0 =',a,' GeV',
     1         1x,'Revolution freq.     f0 =',a,' Hz '/
     1            'Energy loss per turn U0 =',a,' MV ',
     1         1x,'Effective voltage    Vc =',a,' MV '/
     1            'Equilibrium position dz =',a,' mm ',
     1         1x,'Momentum compact. alpha =',a/
     1            'Orbit dilation       dl =',a,' mm ',
     1         1x,'Effective harmonic #  h =',a,/
     1            'Bucket height     dV/P0 =',a,'    ',
     $         1x,'Synchrotron frequency   =',a,' Hz '/)
        if(emiout)then
          write(lfno,*)'   Eigen values and eigen vectors:'
          write(lfno,*)
          write(lfno,9011)'     Real:',(dble(ceig(j)),j=1,6)
          write(lfno,9011)'Imaginary:',(imag(ceig(j)),j=1,6)
        endif
        write(lfno,9012)'Imag.tune:',(dble(cd(j))/pi2,j=4,6)
        write(lfno,9012)'Real tune:',(imag(cd(j))/pi2,j=4,6)
        write(lfno,*)
9011    format(2x,a,6f10.7)
9012    format(2x,a,3(f10.7,10x))
        so=0.d0
        do i=1,6
          do j=1,6
            s=0.d0
            do k=1,6
              s=s+ri(j,k)*r(k,i)
            enddo
            trans(j,i)=s
            if(i .eq. j)then
              so=so+abs(s-1.d0)
            else
              so=so+abs(s)
            endif
          enddo
        enddo
        if(so .gt. 1.d-8)then
          write(lfno,*)' *** Deviation from symplectic matrix = ',so
        endif
        if(emiout)then
          call tput(r ,label1,label2,'9.6',6,lfno)
          call tput(ri,label2,label1,'9.6',6,lfno)
          call tput(trans,label2,label2,'9.6',6,lfno)
        endif
      endif
      if(.not. calem)then
        return
      endif
      do i=1,6
        do j=1,6
          s=0.d0
          do k=1,6
            s=s+trans(j,k+6)*r(k,i)
          enddo
          trans(j,i)=s
        enddo
      enddo
      call tmultr(trans,ri,6)
      do i=1,5,2
        cd(int(i/2)+1)=dcmplx((trans(i,i)+trans(i+1,i+1))*.5d0,
     1                   (trans(i,i+1)-trans(i+1,i))*.5d0)/cc(i)
      enddo
      if(trpt)then
        taurdx=1.d3
        taurdy=1.d3
        taurdz=1.d3
      else
        if(dble(cd(1)) .ne. 0.d0)then
          taurdx=-pi2/omega0/dble(cd(1))
        else
          taurdx=0.d0
        endif
        if(dble(cd(2)) .ne. 0.d0)then
          taurdy=-pi2/omega0/dble(cd(2))
        else
          taurdy=0.d0
        endif
        if(dble(cd(3)) .ne. 0.d0)then
          taurdz=-pi2/omega0/dble(cd(3))
        else
          taurdz=0.d0
        endif
      endif
      params(ipdampx:ipdampz)=dble(cd(1:3))
      params(ipdnux:ipdnuz)=imag(cd(1:3))
      sr=params(ipdampx)+params(ipdampy)+params(ipdampz)
      if(sr .ne. 0.d0)then
        sr=4.d0/sr
        params(ipjx:ipjz)=params(ipdampx:ipdampz)*sr
      else
        sr=0.d0
        params(ipjx:ipjz)=0.d0
      endif
      if(pri)then
        if(emiout)then
          write(lfno,*)'   Radiation part of the transfer matrix:'
          call tput(trans(1,7),label2,label2,'9.6',6,lfno)
          call tput(trans     ,label1,label1,'9.6',6,lfno)
        endif
        write(lfno,*)'   Damping per one revolution:'
        write(lfno,9013)
     1        'X :',dble(cd(1)),'Y :',dble(cd(2)),'Z :',dble(cd(3))
        write(lfno,*)'   Damping time (sec):'
        write(lfno,9013)
     1       'X :',-pi2/omega0/dble(cd(1)),
     $       'Y :',-pi2/omega0/dble(cd(2)),
     $       'Z :',-pi2/omega0/dble(cd(3))
        write(lfno,*)'   Tune shift due to radiation:'
        write(lfno,9013)
     1        'X :',imag(cd(1))/pi2,
     $       'Y :',imag(cd(2))/pi2,'Z :',imag(cd(3))/pi2
9013    format(10x,3(a,1p,g14.6,3x))
        write(lfno,*)'   Damping partition number:'
        write(lfno,9014)
     1  'X :',dble(cd(1))*sr,'Y :',dble(cd(2))*sr,'Z :',dble(cd(3))*sr
9014    format(10x,3(a,f10.4,7x))
        write(lfno,*)
      endif
      beam1(1:21)=beam(1:21)
      call tmulbs(beam,ri,.false.,.false.)
      beam2(1:21)=beam(1:21)
      if(.not. synchm)then
        do i=1,6
          beam(ia(5,i))=0.d0
          trans(i,5)=0.d0
          trans(5,i)=0.d0
        enddo
      endif
      btr=0.d0
      trans(:,7:12)=0.d0
c      call tclr(btr,441)
c      call tclr(trans(1,7),36)
      do i=1,5,2
        tune=imag(cd(int(i/2)+4))
        trans(i  ,i+6)= cos(tune)
        trans(i  ,i+7)= sin(tune)
        trans(i+1,i+6)=-sin(tune)
        trans(i+1,i+7)= cos(tune)
      enddo
      do i=1,6
        do j=1,i
          k=ia(i  ,j  )
          do m=1,6
            do n=1,6
              l=ia(m,n)
              btr(k,l)=btr(k,l)-(trans(i,m)+trans(i,m+6))*
     1                          (trans(j,n)+trans(j,n+6))
            enddo
          enddo
        enddo
      enddo
      sqr2=sqrt(.5d0)
      do i=1,5,2
        k1=ia(i  ,i  )
        k2=ia(i+1,i+1)
        k3=ia(i  ,i+1)
c        do j=1,21
          bbv=btr(k1,1:21)
          btr(k1,1:21)=( bbv+btr(k2,1:21))*sqr2
          btr(k2,1:21)=(-bbv+btr(k2,1:21))*sqr2
          btr(k3,1:21)=btr(k3,1:21)/sqr2
c        enddo
        bb=beam(k1)
        beam(k1)=( bb+beam(k2))*sqr2
        beam(k2)=(-bb+beam(k2))*sqr2
        beam(k3)=beam(k3)/sqr2
c        do j=1,21
          bbv=btr(1:21,k1)
          btr(1:21,k1)=( bbv+btr(1:21,k2))*sqr2
          btr(1:21,k2)=(-bbv+btr(1:21,k2))*sqr2
          btr(1:21,k3)=btr(1:21,k3)*sqr2
c        enddo
      enddo
      do  i=1,21
        btr(i,i)=btr(i,i)+1.d0
        emit(i)=0.d0
      enddo
      do i=1,5,2
        k=ia(i,i)
        btr(k,k)=-(trans(i  ,i)**2+trans(i  ,i+1)**2+
     1             trans(i+1,i)**2+trans(i+1,i+1)**2)*.5d0-
     1            trans(i,i+6)*(trans(i,i)+trans(i+1,i+1))-
     1            trans(i,i+7)*(trans(i,i+1)-trans(i+1,i))
      enddo
      if(.not. synchm)then
        btr(15,21)=0.d0
        btr(15,15)=btr(15,15)*2.d0
        btr(21,15)=-btr(21,21)
        beam(21)=0.d0
      endif
      do i=1,5,2
        k1=ia(i,i)
        k2=ia(i+1,i+1)
        if(btr(k2,k2) .ne. 0.d0 .and. btr(k1,k1) .ne. 0.d0)then
          ab(i)=sqrt(abs(btr(k1,k1)/btr(k2,k2)))
c          do j=1,21
            btr(k1,1:21)=btr(k1,1:21)/ab(i)
            btr(k2,1:21)=btr(k2,1:21)*ab(i)
c          enddo
          beam(k1)=beam(k1)/ab(i)
          beam(k2)=beam(k2)*ab(i)
        else
          ab(i)=1.d0
        endif
      enddo
      call tsolva(btr,beam,emit,21,21,21,1d-8)
      do i=1,5,2
        k1=ia(i,i)
        k2=ia(i+1,i+1)
        bb=emit(k1)
        emit(k1          )=(bb-emit(k2))*sqr2
        emit(k2          )=(bb+emit(k2))*sqr2
        emit(ia(i  ,i+1))=emit(ia(i  ,i+1))*sqr2
      enddo
      emit(ia(1,1))=sign(max(abs(emit(ia(1,1))),emxe),
     $     emit(ia(1,1)))
      emit(ia(2,2))=sign(max(abs(emit(ia(2,2))),emxe),
     $     emit(ia(2,2)))
      emit(ia(3,3))=sign(max(abs(emit(ia(3,3))),emye),
     $     emit(ia(3,3)))
      emit(ia(4,4))=sign(max(abs(emit(ia(4,4))),emye),
     $     emit(ia(4,4)))
      emit(ia(5,5))=sign(max(abs(emit(ia(5,5))),emze),
     $     emit(ia(5,5)))
      emit(ia(6,6))=sign(max(abs(emit(ia(6,6))),emze),
     $     emit(ia(6,6)))
      if(.not. epi)then
        emx= sign(sqrt(abs(emit(ia(1,1))*emit(ia(2,2))
     $       -emit(ia(1,2))**2)),emit(ia(2,2))*charge)
        emy= sign(sqrt(abs(emit(ia(3,3))*emit(ia(4,4))
     $       -emit(ia(3,4))**2)),emit(ia(4,4))*charge)
        emz= sign(sqrt(abs(emit(ia(5,5))*emit(ia(6,6))
     $       -emit(ia(5,6))**2)),emit(ia(6,6))*charge)
      endif
      emit1(1:21)=emit
      call tmulbs(emit1,r,.false.,.false.)
      sige=sqrt(abs(emit1(21)))
      if(synchm)then
        sigz=sqrt(abs(emit1(15)))
      else
        if(omegaz .ne. 0.d0)then
          sigz=abs(alphap)*sige*cveloc*p0/h0/omegaz
        else
          sigz=0.d0
        endif
        emz=sigz*sige
      endif
      params(ipemx)=emx
      params(ipemy)=emy
      params(ipemz)=emz
      params(ipsige)=sige
      params(ipsigz)=sigz
      params(ipnnup)=h0*gspin
      params(iptaup)=33275.d0/36864.d0/finest**2
     $     *h0*elradi/cveloc/(params(ipjz)*sige**2*p0/h0)**3
      call rsetgl1('EMITX',emx)
      call rsetgl1('EMITY',emy)
      call rsetgl1('EMITZ',emz)
      call rsetgl1('SIGE',sige)
      call rsetgl1('SIGZ',sigz)
 3001 if(pri)then
        if(emiout)then
          if(calint)then
            if(intra)then
              write(lfno,*)
     1             '   Beam matrix by radiation+intrabeam fluctuation:'
            endif
            if(wspac)then
              write(lfno,*)
     1             '   Beam matrix with space charge:'
            endif
          else
            write(lfno,*)'   Beam matrix by radiation fluctuation:'
          endif
          call tputbs(beam1,label2,lfno)
          call tputbs(beam2,label1,lfno)
          write(lfno,*)'   Equiliblium beam matrix:'
          call tputbs(emit,label1,lfno)
          call tputbs(emit1,label2,lfno)
        endif
        vout(1)=autofg(emx             ,'11.8')
        vout(2)=autofg(emy             ,'11.8')
        vout(3)=autofg(emz             ,'11.8')
        vout(4)=autofg(sige            ,'11.8')
        vout(5)=autofg(sigz*1.d3       ,'11.8')
        vout(9)=autofg(params(ipnnup)   ,'11.7')
        vout(10)=autofg(params(iptaup)/60.d0,'11.7')
ckiku <------------------
        xxs=emit1(1)-emit1(6)
        yys=-2.d0*emit1(4)
        if(xxs .ne. 0.d0 .and. yys .ne. 0.d0)then
          btilt= atan2(yys,xxs) /2d0
        else
          btilt=0.d0
        endif
        sig1 = abs(emit1(1)+emit1(6))/2d0
        sig2 = 0.5d0* sqrt(abs((emit1(1)-emit1(6))**2+4d0*emit1(4)**2))
        sigx = max(sqrt(sig1+sig2),sqrt(abs(sig1-sig2)))
        sigy = min(sqrt(sig1+sig2),sqrt(abs(sig1-sig2)))
        vout(6)=autofg(btilt,'11.8')
        vout(7)=autofg(sigx*1.d3  ,'11.8')
        vout(8)=autofg(sigy*1.d3  ,'11.8')
        write(lfno,9102)vout(1:10)
9102    format(   'Emittance X            =',a,' m  ',
     1         1x,'Emittance Y            =',a,' m'/
     1            'Emittance Z            =',a,' m  ',
     1         1x,'Energy spread          =',a,/
     1            'Bunch Length           =',a,' mm ',
     1         1X,'Beam tilt              =',a,' rad'/
     1            'Beam size xi           =',a,' mm ',
     1         1X,'Beam size eta          =',a,' mm'/
     $           ,'Nominal spin tune      =',a,'    ',
     $         1x,'Nominal pol. time      =',a,' min'/)
c9103   format(3X,'Beam dimension along principal axis:'/
        call putsti(emx,emy,emz,sige,sigz,btilt,sigx,sigy,
     1              calint,fndcod)
ckiku ------------------>
      endif
      if(calpol)then
        call spnorm(srot,sps,smu)
        srot1=srot(:,1:3)
        params(ipnup)=smu/m_2pi
        call sremit(srot,sps,params,emit,beam2,spm,equpol)
        params(ipequpol)=equpol
        params(ippolx:ippolz)=sps(:,1)
        if(pri)then
          write(lfno,*)'   Polarization vector at entrance:'
          write(lfno,9013)
     1        'x :',sps(1,1),'y :',sps(2,1),'z :',sps(3,1)
          if(emiout)then
            write(lfno,*)'\n'//'   Spin precession matrix:'
            write(lfno,*)'                sx             sy'//
     $           '             sz'
            write(*,'(a,1p3g15.7)')'        sx',srot1(1,:)
            write(*,'(a,1p3g15.7)')'        sy',srot1(2,:)
            write(*,'(a,1p3g15.7)')'        sz',srot1(3,:)
            write(lfno,*)'\n'//'   One-turn depolarization vectors:'
            write(lfno,*)'                x              px'//
     $           '              y             py'//
     $           '              z             pz'
            write(*,'(a,1p6g15.7)')'        sx',srot(1,4:9)
            write(*,'(a,1p6g15.7)')'        sy',srot(2,4:9)
            write(*,'(a,1p6g15.7)')'        sz',srot(3,4:9)
            write(lfno,*)'\n'//'   Spin depolarization matrix:'
            write(lfno,*)'               s1              s2'//
     $           '              s3'
            write(*,'(a,1p6g15.7)')'        s1',spm(1,:)
            write(*,'(a,1p6g15.7)')'        s2',spm(2,:)
            write(*,'(a,1p6g15.7)')'        s3',spm(3,:)
          endif
          vout(1)=autofg(smu/m_2pi,'11.8')
          vout(2)=autofg(equpol*100.d0,'11.8')
          write(lfno,9103)vout(1:2)
 9103     format(/'Spin tune              =',a,'    ',
     1         1x,'Equil. polarization    =',a,' %'/)
        endif
c        write(*,'(a,1p7g15.7)')'radpol ',depolt
      endif
      if(calcodr .and. .not. stab .and. intra)then
        write(lfno,*)'Skip intrabeam because of unstable.'
        intend=.true.
      endif
      if(intend)then
        go to 7010
      endif
      if(intra .or. wspac)then
        dc=0.d0
        do i=1,6
          dc=dc+abs(dceig(i))
        enddo
        call tintraconv(lfno,it,emit,transs,trans,r,
     $     beams,beam,
     $     emxr,emyr,emzr,
     $     emx,emy,emz,
     $     emxmax,emymax,emzmax,
     $     emxmin,emymin,emzmin,
     $     emx0,emy0,emz0,demin,sigz,sige,dc,
     $     vout,pri,intend,epi,synchm,iret)
c        write(*,*)'temit-intraconv ',iret,beam(27)
        go to (7010,4001,3101,3001),iret
      else
        beam(22:42)=emit1(1:21)
      endif
7010  if(plot .and. calem)then
        if(iamat .gt. 0)then
          dlist(iamat+5)=
     $         dtfcopy1(kxm2l(beam1,0,21,1,.false.))
          dlist(iamat+6)=
     $         dtfcopy1(kxm2l(emit1,0,21,1,.false.))
        endif
        call tinitr12(trans)
c        call tclr(trans(1,7),36)
        cod=codin
        rsav=r
        risav=ri
c        call tmov(r,btr,78)
        if(trpt)then
          emit1(1:21)=beamin
        else
          emit1(1:21)=beam(22:42)
        endif
        emit1(22:42)=beam(22:42)
c        call tfmemcheckprint('temit-3',0,.true.,iret)
        srot=0.d0
        srot(1,1)=1.d0
        srot(2,2)=1.d0
        call tturne(trans,cod,emit1,srot,
     $       iatr,iacod,iabmi,.true.,.false.,rt)
c        call tfmemcheckprint('temit-4',0,.true.,iret)
        if(iamat .gt. 0)then
          dlist(iamat+2)=
     $         dtfcopy1(kxm2l(trans,6,6,6,.false.))
          dlist(iamat+3)=
     $         dtfcopy1(kxm2l(trans(1,7),6,6,6,.false.))
        endif
        r=rsav
        ri=risav
c        call tmov(btr,r,78)
        if(iamat .eq. 0)then
          if(charge .lt. 0.d0)then
            beamsize=-beamsize
          endif
        endif
      endif
      return
      end

      subroutine tintraconv(lfno,it,emit,transs,trans,r,
     $     beams,beam,
     $     emxr,emyr,emzr,
     $     emx,emy,emz,
     $     emxmax,emymax,emzmax,
     $     emxmin,emymin,emzmin,
     $     emx0,emy0,emz0,demin,sigz,sige,dc,
     $     vout,pri,intend,epi,synchm,iret)
      use tfstk
      use ffs_flag
      use touschek_table
      use tmacro
      implicit none
      type (sad_dlist), pointer :: klx1
      type (sad_dlist), pointer :: klx2,klx
      type (sad_rlist), pointer :: klx1d,klx1l
      integer*4 itmax,ia,m,n
      real*8 resib,dcmin
      parameter (itmax=100,resib=3.d-6,dcmin=0.06d0)
      integer*8 kax,kax1,kax1d,kax1l,kax2
      integer*4 lfno,it,i,iii,k,iret,j
      real*8 emit(21),beams(21),beam(42),transs(6,12),
     $     trans(6,12),trans1(6,6),r(6,6),
     $     rx,ry,rz,emxr,emyr,emzr,
     $     emx,emy,emz,emx1,emy1,emz1,emmin,
     $     emxmax,emymax,emzmax,
     $     emxmin,emymin,emzmin,
     $     de,emx0,emy0,emz0,demin,tf,tt,eintrb,
     $     rr,sigz,sige,dc
      logical*4 pri,intend,epi,synchm
      character*11 autofg,vout(*)
      ia(m,n)=((m+n+abs(m-n))**2+2*(m+n)-6*abs(m-n))/8
      emx1=emx
      emy1=emy
      emz1=emz
      if(.not. trpt)then
        emmin=(emx+emy)*coumin
        emx=max(emmin,emx)
        emy=max(emmin,emy)
        emz=max(emz0*0.1d0,emz)
        if(emx .le. 0.d0 .or. emy .le. 0.d0 .or. emz .le. 0.d0)then
          write(lfno,*)
     $         ' Negative emittance, ',
     $         'No intrabeam/space charge calculation. emx,y,z =',
     $         emx,emy,emz
          it=itmax+1
        endif
        if(it .ge. 20)then
          emx=min(emxmax,max(emxmin,emx))
          emy=min(emymax,max(emymin,emy))
          emz=min(emzmax,max(emzmin,emz))
        endif
        de=(1.d0-emx0/emx)**2+
     1       (1.d0-emy0/emy)**2+(1.d0-emz0/emz)**2
        demin=min(de,demin)
        if(it .ge. 20)then
          if(it .eq. 20)then
            write(*,*)' Poor convergence... '
            write(*,*)
     $'     EMITX          EMITY          EMITZ           conv'
          endif
          write(*,'(1P,4G15.7)')emx,emy,emz,de
        endif
      endif
 7301 if(it .gt. 1 .and. dc .lt. dcmin
     $     .and. de .lt. resib .or. it .gt. itmax)then
        if(.not. trpt)then
          if(de .ge. resib .or. dc .ge. dcmin)then
            write(*,*)' Intrabeam/space charge convergence failed.'
          elseif(intra .and. .not. caltouck)then
            de=resib*1.01d0
            go to 7301
          endif
          if(itoul .eq. 0)then
            itoul=ktfsymbolz('TouschekTable',13)-4
          endif
          intend=.true.
          tf=rclassic**2*pbunch*sqrt(pi)/h0*omega0/2.d0/pi/p0*h0
          if(caltouck)then
            id=id+1
            kax=ktadaloc(0,4,klx)
            kax1=ktadaloc(0,2,klx1)
            kax1d=ktavaloc(0,ntouckl,klx1d)
            kax1l=ktavaloc(0,ntouckl,klx1l)
            do i=1,ntouckl
              klx1d%rbody(i)=(i+1)*2.d-3
              klx1l%rbody(i)=touckl(i)*tf
              do j=1,nlat
c factor: tf for toucke(#dp/p0,#element) 
                toucke(i,j)=toucke(i,j)*tf
              enddo
            enddo
            klx1%dbody(1)%k=ktflist+kax1d
            klx1%dbody(2)%k=ktflist+kax1l
            kax2=ktadaloc(0,3,klx2)
            klx2%dbody(1)=
     $           dtfcopy1(kxm2l(tampl,ntouckx,3,ntouckx,.true.))
            do i=1,ntouckx
              do j=1,ntouckz
                touckm(j,i,1)=touckm(j,i,1)*tf
                touckm(j,i,2)=touckm(j,i,2)*tf
              enddo
            enddo
            klx2%dbody(2)=dtfcopy1(kxm2l(touckm(1,1,1),
     $           ntouckz,ntouckx,ntouckz,.true.))
            klx2%dbody(3)=dtfcopy1(kxm2l(touckm(1,1,2),
     $           ntouckz,ntouckx,ntouckz,.true.))
c set list for toucke
            klx%rbody(1)=dble(id)
            klx%dbody(2)%k=ktflist+kax1
            klx%dbody(3)%k=ktflist+kax2
            klx%dbody(4)=dtfcopy1(
     $           kxm2l(toucke,ntouckl,nlat,ntouckl,.true.))
            call tflocal(klist(itoul))
            klist(itoul)=ktflist+kax
c            if(tfcheckelement(ktflist+kax,.true.))then
c              write(*,*)'itoul: ',itoul
c            endif
          endif
          pri=lfno .gt. 0
          if(pri)then
            if(caltouck)then
              write(lfno,*)
              do iii=0,int((ntouckl-1)/5)
                write(lfno,9104)((5*iii+i+1)*0.2d0,i=1,5)
 9104           format(
     1               ' Momentum acceptance:  ',5(f8.1,2x),'  %')
                do i=1,5
                  if(5*iii+i .le. ntouckl)then
                    tt=touckl(5*iii+i)*tf
                  else
                    tt=0.d0
                  endif
                  if(tt .ne. 0.d0)then
                    vout(i)=autofg(1.d0/tt,'9.6')
                  else
                    vout(i)='   ---'
                  endif
                enddo
                write(lfno,9105)(vout(i)(1:9),i=1,5)
 9105           format(
     1               ' Touschek lifetime:    ',5(a,1x),' sec')
              enddo
              write(lfno,*)
              write(lfno,'(a)')
     1             ' Touschek lifetime/100s for aperture '//
     1             '2Jx/(Nx**2 emitx'') + 2Jz/(Nz**2 emitz) < 1:'
              write(lfno,9131)'Nx',(int(tampl(k,1)),
     1             (max(0,min(999,
     $             nint(.01d0/touckm(m,k,1)))),m=1,ntouckz),
     1             k=1,ntouckx)
 9131         format(
     1             '  ',
     1             'Nz: 4.6 5.3   6 6.8 7.7 8.8  10  11  13  15',
     $             '  17  19  21  24  28  32  36  41  46  53',
     $             '  60  68  77  88 100'/
     1             '  ',a,
     1   '!---1---1---1---1---1---1---1---1---1---1---1---1',
     1   '---1---1---1---1---1---1---1---1---1---1---1---1---1'/,
     1             34(i4,'!',25(i4)/))
              write(lfno,'(a)')
     1             ' Touschek lifetime/100s for aperture '//
     1             '2Jy/(Ny**2 emitx'') + 2Jz/(Nz**2 emitz) < 1:'
              write(lfno,9131)'Ny',(int(tampl(k,2)),
     1             (max(0,min(999,
     $             nint(0.01d0/touckm(m,k,2)))),m=1,ntouckz),
     1             k=1,ntouckx)
            endif
          endif
        else
          intend=.true.
        endif
        if(intra)then
          write(lfno,*)'   Parameters with intrabeam scattering:'
        endif
        if(wspac)then
          write(lfno,*)'   Parameters with space charge:'
        endif
        vout(1)=autofg(pbunch ,'11.8')
        vout(2)=autofg(coumin*1.d2,'11.8')
        write(lfno,9103)(vout(i)(1:11),i=1,2)
 9103   format(  'Particles/bunch        =',a,'    ',
     $       1x,'Minimum coupling       =',a,' %  ')
        if(wspac)then
          write(lfno,*)
          trans=transs
          beam(1:21)=beams
          epi=.true.
          iret=3
        else
          iret=4
        endif
        return
      else
        caltouck=intra .and. de .lt. resib*10.d0 .and. .not. trpt
        pri=.false.
        if(calint)then
          if(intra)then
            rx=eintrb(emx0,emx,emxr)/emx
            ry=eintrb(emy0,emy,emyr)/emy
            rz=eintrb(emz0,emz,emzr)/emz
            rr=min(100.d0,max(0.01d0,(rx*ry*rz)**(1.d0/3.d0)))
            emx=emx*rr
            emy=emy*rr
            emz=emz*rr
          elseif(emx0 .ne. 0.d0)then
            if(it .ge. 20)then
              emxmax=min(max(emx,emx0),emxmax)
              emxmin=max(min(emx,emx0),emxmin)
              emx=sqrt(emxmax*emxmin)
            else
              emx=sqrt(emx*emx0)
            endif
            if(it .gt. 30)then
              emymax=min(max(emy,emy0),emymax)
              emymin=max(min(emy,emy0),emymin)
              emy=sqrt(emymax*emymin)
            else
              emy=sqrt(emy*emy0)
            endif
            emzmax=min(max(emz,emz0),emzmax)
            emzmin=max(min(emz,emz0),emzmin)
            emz=sqrt(emzmax*emzmin)
          endif
        else
          emxr=emx
          emyr=emy
          emzr=emz
        endif
        emx0=emx
        emy0=emy
        emz0=emz
        calint=.true.
c     ccintr=(rclassic/h0**2)**2/8.d0/pi
c     cintrb=ccintr*pbunch/emx/emy/emz
c     
c     cintrb=rclassic**2/8.d0/pi
c     1           *pbunch/(emx*h0)/(emy*h0)/(emz*h0)/h0
c     Here was the factor 2 difference from B-M paper.
c     Pointed out by K. Kubo on 6/18/2001.
c     
        cintrb=rclassic**2/4.d0/pi*pbunch
c     write(*,*)cintrb,emx,emy,emz
c        if(trpt)then
c          write(*,*)'tintraconv @ src/temit.f: ',
c     $          'Reference uninitialized emx1/emy1/emz1',
c     $          '(FIXME)'
c          stop
c        endif
        if(.not. trpt)then
          if(emx1 .gt. 0.01d0*emx)then
            rx=sqrt(emx/emx1)
          else
            emit(ia(1,1))=emx
            emit(ia(2,2))=emx
            rx=1.d0
          endif
          if(emy1 .gt. 0.01d0*emy)then
            ry=sqrt(emy/emy1)
          else
            emit(ia(3,3))=emy
            emit(ia(4,4))=emy
            ry=1.d0
          endif
          if(emz1 .gt. 0.01d0*emz)then
            rz=sqrt(emz/emz1)
          else
            emit(ia(5,5))=emz
            emit(ia(6,6))=emz
            rz=1.d0
          endif
          call tinitr(trans1)
          trans1(1,1)=rx
          trans1(2,2)=rx
          trans1(3,3)=ry
          trans1(4,4)=ry
          trans1(5,5)=rz
          trans1(6,6)=rz
c     write(*,*)'temit ',rx,ry,rx
c     write(*,*)'temit ',emy,emy1
          call tmulbs(emit,trans1,.false.,.false.)
          if(.not. synchm)then
            emit(ia(5,1))=0.d0
            emit(ia(5,2))=0.d0
            emit(ia(5,3))=0.d0
            emit(ia(5,4))=0.d0
            emit(ia(5,5))=sigz**2
            emit(ia(5,6))=0.d0
            emit(ia(6,6))=sige**2
            r(1:4,5)=0.d0
            r(5,5)=1.d0
            r(6,5)=0.d0
            r(6,1:5)=0.d0
            r(6,6)=1.d0
            r(5,1:4)=0.d0
            r(5,5)=1.d0
            r(5,6)=0.d0
          endif
          call tmulbs(emit,r,.false.,.false.)
          beam(22:42)=emit
          it=it+1
        else
          beam(22:42)=0.d0
          beam(1:21)=beamin
          it=itmax+1
        endif
        iret=2
        return
      endif
      iret=1
      return
      end

      subroutine tsymp(trans)
      implicit none
      integer*4 i
      real*8 trans(6,6),ri(6,7)
      call tinv6(trans,ri)
      call tmultr(ri,trans,6)
      do 10 i=1,6
c        do 20 j=1,6
          ri(1:6,i)=-ri(1:6,i)*.5d0
c20      continue
        ri(i,i)=ri(i,i)+1.5d0
10    continue
      call tmultr(trans,ri,6)
      return
      end

      real*8 function eintrb(em0,y,emr)
      implicit none
      real*8 em0,y,emr,eps

      integer itmax
      parameter (eps=1.d-10,itmax=30)
      real*8 em,a,y1
      integer it

      em=em0
      a=(y-emr)*em0**2
      y1=y
      it=0
1     em=em+(y1-em)/(em**3+2.d0*a)*em**3
      y1=emr+a/em**2
      if(abs(y1-em) .lt. eps*em)then
        eintrb=min(100.d0*em0,max(emr,y1,0.01d0*em0))
        return
      endif
      it=it+1
      if(it .gt. itmax)then
        eintrb=min(100.d0*em0,max(0.01d0*em0,em))
        return
      endif
      go to 1
      end

      subroutine tinv(r,ri,n,ndimr)
      implicit none
      integer*4 i,j,n,ndimr
      real*8 r(ndimr,n),ri(ndimr,n)
      do 10 i=1,n-1,2
        do 20 j=1,n-1,2
          ri(i  ,j  )= r(j+1,i+1)
          ri(i  ,j+1)=-r(j  ,i+1)
          ri(i+1,j  )=-r(j+1,i  )
          ri(i+1,j+1)= r(j  ,i  )
20      continue
10    continue
      return
      end

      subroutine tinv6(r,ri)
      implicit none
      real*8, intent(in):: r(6,6)
      real*8 ,intent(out)::ri(6,6)
      ri(1,1)= r(2,2)
      ri(1,2)=-r(1,2)
      ri(1,3)= r(4,2)
      ri(1,4)=-r(3,2)
      ri(1,5)= r(6,2)
      ri(1,6)=-r(5,2)
      ri(2,1)=-r(2,1)
      ri(2,2)= r(1,1)
      ri(2,3)=-r(4,1)
      ri(2,4)= r(3,1)
      ri(2,5)=-r(6,1)
      ri(2,6)= r(5,1)
      ri(3,1)= r(2,4)
      ri(3,2)=-r(1,4)
      ri(3,3)= r(4,4)
      ri(3,4)=-r(3,4)
      ri(3,5)= r(6,4)
      ri(3,6)=-r(5,4)
      ri(4,1)=-r(2,3)
      ri(4,2)= r(1,3)
      ri(4,3)=-r(4,3)
      ri(4,4)= r(3,3)
      ri(4,5)=-r(6,3)
      ri(4,6)= r(5,3)
      ri(5,1)= r(2,6)
      ri(5,2)=-r(1,6)
      ri(5,3)= r(4,6)
      ri(5,4)=-r(3,6)
      ri(5,5)= r(6,6)
      ri(5,6)=-r(5,6)
      ri(6,1)=-r(2,5)
      ri(6,2)= r(1,5)
      ri(6,3)=-r(4,5)
      ri(6,4)= r(3,5)
      ri(6,5)=-r(6,5)
      ri(6,6)= r(5,5)
      return
      end
