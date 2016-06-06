      Subroutine ActTra(argp)
      use maccbk
      use tfstk
      implicit none
c     export
      integer parptr,lptr
c     
      integer*4 argp
      include 'inc/MACCODE.inc'
      include 'inc/MACVAR.inc'
      include 'inc/MACPHYS.inc'
      include 'inc/MACFILE.inc'
C     
      integer*4 NSPARM
      parameter (NSPARM=7)
      integer*4 nt$,np$,ex$,sigs$,sync$,elec$,posi$,prot$
      integer*4 nx$,ny$,nz$
      parameter (nt$=2,np$=3,ex$=4,sigs$=6,
     $     elec$=8,posi$=elec$+1,prot$=posi$+1,
     $     sync$=16,nx$=sync$+1,ny$=nx$+1,nz$=ny$+1)
c      integer*4 idxtws
      integer*4 nt,np,pexln
      integer*4 sptr,pltpw,pltps,plot$
      integer*4 idummy, npw, i,idx, nxp0,nxl0,j,k,nps
      integer*4 xbase,pbase,xptr,pptr,sync,nxp(3),nxl(3)
      integer*4 span$,cent$e
      integer*4 itfdummyline
      real*8  p0,charge,mass,em(2),sigs,sige
      real*8  v0,dist,comp,df,de,ex,ey,r0,r
      real*8 RgetGL
      integer*4 IgetGL,mctaloc
c     
c  K. Oide 9/10/1999
      character*1 xc(-3:3)
      data xc/'X','Y','Z',' ','x','y','z'/
      character*5 pc(-3:3)
      data pc /'PX   ','PY   ','PZ   ','  ',
     $     'px/p0','py/p0','dp/p0'/
ccccccc
      character*(MAXSTR) mess
      character*7  autofg
      character*3 tag(3)
      character*31 title(-6:6)
      character*8 partid
      data title/
     &     'MAPPED Z SPECTRUM',
     &     'MAPPED Y SPECTRUM',
     &     'MAPPED X SPECTRUM',
     &     'MAPPED Z PHASE SPACE',
     &     'MAPPED Y PHASE SPACE',
     &     'MAPPED X PHASE SPACE',
     &     'NONE ',
     &     'REAL X PHASE SPACE',
     &     'REAL Y PHASE SPACE',
     &     'REAL Z PHASE SPACE',
     &     'REAL X SPECTRUM',
     &     'REAL Y SPECTRUM',
     &     'REAL Z SPECTRUM'/
      data tag/'NX=','NY=','NZ='/
c     
c     for debug
c     call ptrace('acttra',1)
c     end debug
c      write(*,*)'ActTra-1 '
      parptr=mctaloc(22)
      ilist(1,parptr)=22
      xbase=parptr+16
      pbase=xbase+1
c     print *,'acttra(49 )>',ilist(1,30),ilist(2,30)
      sptr=mctaloc(NSPARM)
c     print *,'acttra(49 )>',parptr,sptr
      ilist(1,sptr)=NSPARM
      ilist(2,parptr+1)=sptr
c     print *,'acttra(52 )>',ilist(1,30),ilist(2,30)
c     
      if (ilist(2,argp+elec$) .ne. 0) then
         mass=elmass
         charge=-echarg
      else if(ilist(2,argp+posi$) .ne. 0) then
         mass=elmass
         charge=echarg
      else if(ilist(2,argp+prot$) .ne. 0) then
         mass=prmass
         charge=echarg
      else
         mass=elmass
         charge=echarg
      endif
      call RsetGL('$MASS$',mass,idummy)
 101  lptr=ilist(2,argp+1)
c      write(*,*)'ActTra-2 ',argp,lptr,idtype(lptr),icLINE
      if (idtype(lptr) .ne. icLINE) then
c
c******* K. Oide 7/6/1997 *********
c
c        call talocinit
        ilist(2,argp+1)=itfdummyline()
c        write(*,*)'ActTra-2.1 ',argp
        go to 101
c         call errmsg('actTra',
c     &        pname(lptr)(:lpname(lptr))//'is not a line name.',0,4)
c         pexln=0
c         idxtws=0
c         return
c**********************************
      else
c.......for debug
c     print *,'argument for track',pname(lptr),ilist(2,idval(lptr))
c.......end debug
c      write(*,*)'ActTra-2.2 ',lptr,ilist(2,idval(lptr))
         if (ilist(2,idval(lptr)) .le. 0) then
            call expnln(lptr)
         endif
c       write(*,*)'ActTra-2.3 ',lptr,ilist(2,idval(lptr))
         call filaux(idval(lptr))
         pexln=ilist(2,idval(lptr))
      endif
      dist=rlist(ilist(2,pexln)+1)
      comp=rlist(ilist(2,pexln)+2)
      df=RgetGL('FSHIFT',idummy)
      de=RgetGL('ESHIFT',idummy)
      if((df .ne. -comp*de) .and. (de .ne. 0.0d0)) then
         call RsetGL('FSHIFT',-comp*de,idummy)
      endif
c.....for debug
c     print *,'length of line',pname(lptr),'is',dist
c.....end debug
c.....parameters for ploting
      plot$=IgetGL('$PLOT$',idummy)
      nps=0
      npw=0
      i=plot$
 1000 continue
      if(i .le. 0) go to 1100
      if(abs(ilist(1,i+1)) .le. 3) then
         nps=nps+1
      else if(abs(ilist(1,i+1)) .le. 6) then
         npw=npw+1
      endif
      i=ilist(2,i)
      go to 1000
 1100 continue
c      write(*,*)'ActTra-2.9 '
      pltpw=mctaloc(npw+1)
      pltps=mctaloc(nps+1)
      ilist(2,parptr+4)=pltpw
      ilist(2,parptr+5)=pltps
      ilist(1,pltpw)=npw+1
      ilist(1,pltps)=nps+1
c     print *,'at 1100 nps ',nps
      i=plot$
 1200 continue
      if(i .le. 0) go to 1300
      if(abs(ilist(1,i+1)) .le. 3) then
         pltps=pltps+1
         ilist(2,pltps)=mctaloc(4)
         call v_copy(rlist(i+1),rlist(ilist(2,pltps)),3)
      else if(abs(ilist(1,i+1)) .le. 6) then
         pltpw=pltpw+1
         ilist(2,pltpw)=mctaloc(ilist(1,i)-1)
         call v_copy(rlist(i+1),rlist(ilist(2,pltpw)),ilist(1,i)-1)
      endif
      i=ilist(2,i)
      go to 1200
 1300 continue
c     
      nt=ilist(2,argp+nt$)
      np=ilist(2,argp+np$)
c      write(*,*)'ActTra-3 ',np
      if(ilist(2,argp+ex$) .ne. 0)then
        ex=rlist(ilist(2,argp+ex$))
      else
        ex=0.0
      endif
      em(1)=ex
      if(ilist(2,argp+ex$+1) .ne. 0)then
        ey=rlist(ilist(2,argp+ex$+1))
      else
        ey=0.0
      endif
      em(2)=ey
      if(ilist(2,argp+sigs$) .ne. 0)then
        sigs=rlist(ilist(2,argp+sigs$))
      else
        sigs=0.0
      endif
      if(ilist(2,argp+sigs$+1) .ne. 0)then
        sige=rlist(ilist(2,argp+sigs$+1))
      else
        sige=0.0
      endif
      sync=ilist(2,argp+sync$)
      do i=1,3
         nxp(i)=ilist(2,argp+nx$+i-1)
         if (nxp(i) .eq. 0) then
            nxl(i)=0
         else
            nxl(i)=ilist(1,nxp(i))-1
         endif
      enddo
      p0=RgetGL('MOMENTUM',idummy)
      v0=cveloc*p0/sqrt(p0**2+mass**2)
      if(dist .ne. 0.d0)then
        call RsetGL('OMEGA0',2.D0*PI*v0/dist,idx)
      endif
c.....put scalar parameters in parameter list.
      ilist(1,sptr+1)=np
      ilist(1,sptr+2)=nt
      rlist(sptr+3)=p0
      rlist(sptr+4)=charge
      rlist(sptr+5)=mass
      ilist(1,sptr+6)=sync
c     
c     print *,np,nt,p0,charge,mass,sync,ex,ey,sigs,sige
c     
c.....construct initial value list.
c     call pr_mem_map
c     if(igetgl('$COD$',idummy) .ne. 0)then
c     call  twis(pexln,idxtws,.true.)
c     endif
c     call plttws(pexln,idxtws)
c     ilist(2,parptr+2)=idxtws
      ilist(2,parptr+2)=0
      do i=1,2
c       write(*,*)'ActTra-3.3 ',i,ilist(2,1)
         xptr=mctaloc(np)
c      write(*,*)'ActTra-3.35 ',i,np
         pptr=mctaloc(np)
c      write(*,*)'ActTra-3.4 ',i,np,xptr,pptr
         ilist(2,xbase)=xptr
         ilist(2,pbase)=pptr
c     beta=rlist(idxtws+1+7*(i-1))
c     alpha=rlist(idxtws+2+7*(i-1))
c     r0=sqrt(em(i)*beta)
         r0=1.d0
         nxp0=nxp(i)
         nxl0=nxl(i)
c     write(*,*)'ActTra-3.5 ',i,np,nxp0,nxl0
         do j=0,np-1
            if(nxl0.eq.0) then
               r=r0
            else
               r=r0*rlist(nxp0+mod(j,nxl0)+1)
            endif
            rlist(xptr+j)=r
            rlist(pptr+j)=0.d0
         enddo
c     write(*,*)'ActTra-3.6 ',np,xptr,pptr
         xbase=xbase+2
         pbase=pbase+2
      enddo
c     
c      write(*,*)'ActTra-4 '
      xptr=mctaloc(np)
      pptr=mctaloc(np)
      ilist(2,xbase)=xptr
      ilist(2,pbase)=pptr
      nxp0=nxp(3)
      nxl0=nxl(3)
      do j=0,np-1
         if(nxl0.eq.0) then
            rlist(pptr+j)=0.0
         else
            rlist(pptr+j)=rlist(nxp0+mod(j,nxl0)+1)
         endif
         rlist(xptr+j)=0.0d0
      enddo
c     
      call tfsetbeamlinename(pname(lptr))
c      write(*,*)'ActTra-5',pexln,parptr,mstk
      call track(pexln,parptr)
      if(np .gt. 0)then
         do k=1,3
            mess=' '
            j=1
            do i=1,nxl(k)
               mess(j:j+6)=autofg(rlist(nxp(k)+i),'S7.4')
               j=j+7
               if(j .gt. 70)then
                  write(outfl,'(1x,a,a)')tag(k),mess(1:j-1)
                  j=1
               endif
            enddo
            if(j .ne. 1)then
               write(outfl,'(1x,a,a)')tag(k),mess(1:j-1)
            endif
         enddo
c     
c.....maketop-drawer output
         pltpw= ilist(2,parptr+4)
         pltps= ilist(2,parptr+5)
         npw=ilist(1,pltpw)-1
         nps=ilist(1,pltps)-1
         do i=1,npw
            span$=ilist(2,pltpw+i)+3
            cent$e=span$+1
c     npart$=span$-1
c     write(*,*)i,npw,span$,cent$e
            write(partid,'(A4,I4.4)')'ID::',ilist(1,span$-2)
            call tdjin$(ilist(1,pltpw+i),rlist(span$),rlist(cent$e),
     &           'tune','amplitude',
     &           title(ilist(1,ilist(2,pltpw+i))),partid)
c     call kdjin$(ilist(1,pltpw+i),rlist(span$),rlist(cent$e),
c     &             'tune','amplitude',
c     &             title(ilist(1,ilist(2,pltpw+i))),partid)
         enddo
         do i=1,nps
            span$=ilist(2,pltps+i)+3
            write(partid,'(A4,I4.4)')'ID::',ilist(1,span$-2)
            call tdplt$(ilist(1,pltps+i),
     &           xc(ilist(1,ilist(2,pltps+i))),
     &           pc(ilist(1,ilist(2,pltps+i))),
     &           title(ilist(1,ilist(2,pltps+i))),
     &           partid,.false.)
c     call $kdcmd('plot',ilist(1,pltps+i),
c     &             xc(abs(ilist(1,ilist(2,pltps+i)))),
c     &             pc(abs(ilist(1,ilist(2,pltps+i)))),
c     &             title(ilist(1,ilist(2,pltps+i))),
c     &             partid,.false.)
         enddo
      endif
      do i=1,6
         call tfreem(ilist(2,parptr+15+i),np)
c         call freeme(ilist(2,parptr+15+i),np)
      enddo
c     for debug
c     call ptrace('acttra',-1)
c     end debug
      return
      end
