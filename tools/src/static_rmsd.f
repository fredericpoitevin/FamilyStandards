c
c       this programs assumes both PDB given as input are clean
c       in that they only contain the same ATOM lines.
c       It computes the RMSD between them, without affecting them.       
c
        integer natmax
        parameter (natmax=50000)
c       
        integer idx,k,iat,nat1,nat2
        real*8 crd1(3*natmax),crd2(3*natmax)
        real*8 diff,rmsd
        character*64 fpdb1,fpdb2
        character line*80
c
1       format(a)
2       format(30x,3(f8.3))
3       format(f6.2)
c
        call getarg(1,fpdb1)
        call getarg(2,fpdb2)
c
        nat1=0       
        open(unit=1,file=fpdb1,status='unknown')
101       read(1,1,end=201) line
          if(line(1:4).ne."ATOM") goto 101
          nat1 = nat1 + 1
          idx=3*(nat1-1)
          read(line,2) crd1(idx+1),crd1(idx+2),crd1(idx+3)
          goto 101
201       continue
        close(unit=1)
c
        nat2=0
        open(unit=1,file=fpdb2,status='unknown')
102       read(1,1,end=202) line
          if(line(1:4).ne."ATOM") goto 102
          nat2 = nat2 + 1
          idx=3*(nat2-1)
          read(line,2) crd2(idx+1),crd2(idx+2),crd2(idx+3)
          goto 102
202       continue
        close(unit=1)
c       
        if(nat1.ne.nat2) then
          write(6,*) "ERROR: NAT1.NE.NAT2"
          goto 999
        endif
c
        rmsd=0.d0
        do 300 iat = 1,nat1
          do 301 k = 1,3
            idx=3*(iat-1)+k
            diff = crd2(idx)-crd1(idx)
            rmsd = rmsd + diff**2
301       continue
300     continue
        rmsd=rmsd/real(nat1)
        rmsd=sqrt(rmsd)
c
        write(6,3) rmsd
c
999     continue
        stop
        end
