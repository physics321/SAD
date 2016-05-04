      use maccbk
      implicit none
      include 'inc/MACFILE.inc'
      include 'inc/MACCODE.inc'
      include 'inc/MACKW.inc'
      include 'inc/MACTTYP.inc'
      include 'inc/MACMISC.inc'
c
      character*30 dat
c
      character*19 versionid,versiondate
      character*25 builtdate
      common /version/ versionid,versiondate
c                      /'         1111111111'/
c                      /'1234567890123456789'/
      data versionid   /'1.0.10.9.4k64      '/
      data versiondate /'5/4/2016 19:00:00  '/
c
      call fdate1(dat)
      call buildinfo_get_string('Built:Date', builtdate)
c
      write(*,*)
     $     '*** Welcome to SAD Ver.',versionid(1:len_trim(versionid)),
     $     ' built at ',builtdate(1:len_trim(builtdate)),' ***'
      write(*,*)'*** Today: ',dat(1:len_trim(dat)),' ***'
c
      call inimem
      call inifil
      call initbl
      call tftokinit
      call ktfinitshare
c
      call toplvl
      end
