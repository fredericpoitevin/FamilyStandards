c       
c       this program reads two PDB containing COMs.
c       The 1st PDB is the reference
c       The second is worked on:
c         each of its chain is assigned the closest remaining
c         chain in the reference file.
c         A global RMSD is computing based on this correspondance.
c
        integer nchmax
        parameter (nchmax=10)
c  
        integer i,k,nch,ich,jch,jchmin
        integer taken(nchmax),closest(nchmax)
        real*8 dist,distmin
        real*8 crd(2,3*nchmax)
        real*8 rmsd
        character line*80,ch(2,nchmax)
        character*128 fref,fmov,ftmp,fcorr
c
1       format(a)
2       format(21x,a1,8x,3f8.3)
3       format(a1,",",a1)
4       format("... chain COM rmsd =",f8.3)
c
        call getarg(1,fref)
        call getarg(2,fmov)
        call getarg(3,fcorr)
c
        ftmp=fref
        do 99 i = 1,2
         if(i.eq.2) ftmp=fmov
         nch=0
         open(unit=1,file=ftmp,status='unknown')
100       read(1,1,end=102) line
          nch=nch+1
          read(line,2) ch(i,nch),crd(i,3*(nch-1)+1),
     1                           crd(i,3*(nch-1)+2),
     2                           crd(i,3*(nch-1)+3)
          goto 100
102       continue
         close(unit=1)
99      continue
c       
        do 200 ich = 1,nch
          distmin=1.d4
          do 201 jch = 1,nch
            if(taken(jch).eq.1) goto 201
            dist = 0.d0
            do 202 k = 1,3
              dist = dist
     1             + (crd(1,3*(jch-1)+k)-crd(2,3*(ich-1)+k))**2
202         continue
            if(dist.lt.distmin) then
              distmin=dist
              jchmin = jch
            endif
201       continue
          closest(ich) = jchmin
          taken(jchmin) = 1
200     continue
c
        open(unit=1,file=fcorr,status='unknown')
        rmsd=0.d0
        do 300 ich = 1,nch
          jch=closest(ich)
          write(1,3) ch(1,jch),ch(2,ich)
          do 301 k = 1,3
            rmsd = rmsd 
     1      + (crd(1,3*(jch-1)+k)-crd(2,3*(ich-1)+k))**2
301       continue
300     continue
        rmsd=sqrt(rmsd/real(nch))
        write(6,4) rmsd
        close(unit=1)
c       
        stop
        end
c
