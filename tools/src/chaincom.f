c
c       this programs reads in a PDB file and outputs one
c       with the COM of each chains
c       
        integer nchmax
        parameter (nchmax = 10)
c
        integer k,ich
        integer nch,nres(nchmax)
        real*8 x(3),com(nchmax,3)
        character*1 ch_old,ch,chain(nchmax)
        character*128 fpdb,fcom
        character line*80,left*21
c
1       format(a)
2       format(a21,a1,8x,3f8.3)
c
        call getarg(1,fpdb)
        call getarg(2,fcom)
c
        ch_old="Z"
        nch = 0
c       
        open(unit=1,file=fpdb,status='unknown')
100       read(1,1,end=200) line
          if(nch.eq.6) then
            nch=nch-1
            goto 200
          endif
          if(line(1:4).ne."ATOM") goto 100
          read(line,2) left,ch,x(1),x(2),x(3)
          if(ch.ne.ch_old) then
            ch_old = ch
            nch = nch + 1
            nres(nch) = 0
            chain(nch) = ch
            do 102 k = 1,3
              com(nch,k) = 0.d0
102         continue
          else
            nres(nch) = nres(nch) + 1
            do 101 k = 1,3
              com(nch,k) = com(nch,k) + x(k)
101         continue
          endif
          goto 100
200       continue
        close(unit=1)
c       
        open(unit=1,file=fcom,status='unknown')
        do 300 ich = 1,nch
          do 301 k = 1,3
            x(k) = com(ich,k)/real(nres(ich))
301       continue
          write(1,2) left,chain(ich),x(1),x(2),x(3)
300     continue
        close(unit=1)
c        
        stop
        end
