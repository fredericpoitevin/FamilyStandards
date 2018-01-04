c
c       This program takes in 6 arguments:
c       - original PDB file
c       - residue correspondance number file
c       - chain correspondance number file
c       - bew PDB file name
c       - keep flag: (0) keep all / (1) only keep commons
c       - revert flag: (0) normal usage 
c                      (1) revert usage: apply species numbering and 
c                          do not change chain name
c       
        integer nchmax,nresmax
        parameter (nchmax=20)
        parameter (nresmax=1000)
c       
        integer narg
        integer ich,i,j,k,ichok,nch
        integer keep_flag,revert_flag
        integer resnew(nresmax),keep(nresmax)
        character*128 fpdb,fres,fchn,fout
        character line*80,chold(nchmax)*1,chnew(nchmax)*1
        character left*21,ch*1,right*54
        character tmparg*64
c       
1       format(a)
2       format(a1,1x,a1)
3       format(1x,i4,1x,i4,1x,i1)
4       format(a21,a1,i4,a54)
c       
        narg=iargc()
        if(narg.lt.6) then
          write(6,*) "not enough arguments"
          goto 999
        endif
        call getarg(1,fpdb)
        call getarg(2,fres)
        call getarg(3,fchn)
        call getarg(4,fout)
        call getarg(5,tmparg)
                read(tmparg,*) keep_flag
        call getarg(6,tmparg)
                read(tmparg,*) revert_flag
c
        if(revert_flag.eq.0) then
          ich=0
          open(unit=1,file=fchn,status='unknown')
100         read(1,1,end=101) line
            ich=ich+1
c            read(line,2) chold(ich),chnew(ich)
            read(line,2) chnew(ich),chold(ich)
            goto 100
101         continue
          close(unit=1)
          nch=ich
        endif
c       
        open(unit=1,file=fres,status='unknown')
200       read(1,1,end=201) line
          read(line,3) i,j,k
          if(revert_flag.eq.0) then
            resnew(i) = j
            keep(i) = k
            if(keep_flag.eq.0) then
              keep(i) = 1
            endif
          else
            resnew(j) = i
            keep(j) = k
            if(keep_flag.eq.0) then
              keep(j) = 1
            endif
          endif
          goto 200
201       continue
        close(unit=1)
c       
        open(unit=1,file=fpdb,status='unknown')
        open(unit=2,file=fout,status='unknown')
300       read(1,1,end=301) line
          if(line(1:4).eq."ATOM") then
            read(line,4) left,ch,i,right
            if(keep(i).eq.1) then
              if(revert_flag.eq.0) then
                ichok=0
                do 302 ich = 1,nch
                  if(chold(ich).eq.ch) then
                    ichok=ich
                  endif
302             continue
                if(ichok.ne.0) then
                  write(2,4) left,chnew(ichok),resnew(i),right
                endif
              else
                write(2,4) left,ch,resnew(i),right
              endif
            endif
          endif
          goto 300
301       continue
        close(unit=2)
        close(unit=1)
c       
999     continue
        stop
        end
