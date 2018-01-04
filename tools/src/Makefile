#
EXT=
NAME2=renumber
NAME3=chaincom
NAME4=com_pare

DIR=..
NAMEFUL2=$(DIR)/$(NAME2)$(EXT)
NAMEFUL3=$(DIR)/$(NAME3)$(EXT)
NAMEFUL4=$(DIR)/$(NAME4)$(EXT)

FC = gfortran
FFLAGS = -c -u -C -O -fimplicit-none -fcray-pointer -ffixed-line-length-none
LDFLAGS = -O

.f.o :
	$(FC) $(FFLAGS) $<

OBJECTS2 = \
$(NAME2).o

$(NAME2) : $(OBJECTS2)
	$(FC) -o $(NAMEFUL2) $(LDFLAGS) $(OBJECTS2)

OBJECTS3 = \
$(NAME3).o

$(NAME3) : $(OBJECTS3)
	$(FC) -o $(NAMEFUL3) $(LDFLAGS) $(OBJECTS3)

OBJECTS4 = \
$(NAME4).o

$(NAME4) : $(OBJECTS4)
	$(FC) -o $(NAMEFUL4) $(LDFLAGS) $(OBJECTS4)

clean:
	touch junk.o; rm -f *.o $(NAMEFUL2) $(NAMEFUL3) $(NAMEFUL4)
