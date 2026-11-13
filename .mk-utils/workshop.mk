# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# 		=====================        #
#       =  Config. Talleres =        #
#       =====================		 #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

LEVELS := 1 2 3 4 
TALLER := $(addprefix taller-0, $(LEVELS))
ASM    := $(addprefix asm-0, $(LEVELS))

T_FOLDER := taller/

$(TALLER): taller-%: $(T_FOLDER)level%.c
	$(CC) $(CFLAGS) -o $@ $<

$(ASM): asm-%: $(T_FOLDER)level%.asm
	$(AS) $(ASFLAGS) -o $*.o $<
	$(LD) $(LDFLAGS) $* -o $<

.PHONY: clear
clear:
	rm -i taller-0*