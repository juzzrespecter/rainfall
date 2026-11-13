OVA_LINK ?= https://cdn.intra.42.fr/isos/RainFall_v2.ova
OVA ?= RainFall_v2.ova
QCOW ?= $(addsuffix .qcow2, $(basename $(OVA)))
T_FOLDER ?= taller/
BIN_FOLDER ?= bin/

LEVELS := 1 2 3 4 5 6 7 8 9
RETRIEVE := $(addprefix retrieve-, $(LEVELS))

define ova_to_vmdk
$(addsuffix .vmdk, $(word 1, $(subst _, ,$(basename $(1))))-disk001)
endef
VMDK ?= $(call ova_to_vmdk,$(OVA))

CC ?= cc
CFLAGS ?= -m32 -no-pie -fno-stack-protector -ggdb -Wno-implicit-function-declaration -mpreferred-stack-boundary=2 -z execstack

AS := nasm
ASFLAGS := -f elf64
LD := ld
LDFLAGS := -m elf_i386 
SAFE_RM := rm -i

.PHONY: all
all: run

.SECONDARY: $(OVA) $(VMDK)
.INTERMEDIATE: $(OVA) $(VMDK)

$(OVA):
	wget -O $(OVA) $(OVA_LINK)

$(VMDK): | $(OVA)
	tar fx $(OVA)

$(QCOW): $(VMDK)
	qemu-img convert -p -f vmdk -O qcow $(VMDK) $(QCOW)

.PHONY: run
run: $(QCOW)
	qemu-system-x86_64 -enable-kvm -m 2G -drive file=$(QCOW),if=virtio -nic user,hostfwd=tcp::4242-:4242

## HEX translate util
.PHONY: hex
hex:
	@$(if $(STRING),,$(error "STRING var not set; nothing is done"))
	@python -c "print([f'0x{chunk.encode(\"ascii\").hex()}' for chunk in [r'$${STRING}'[i:i+4] for i in range(0, len(r'$${STRING}'), 4)]])"

.PHONY: check_running_vm
check_running_vm:
	@pgrep -f "qemu-system-x86_64" >/dev/null || ( echo "RainFall VM is not running! Run it with make run "; exit 1 )

.PHONY: retrieve-%
retrieve-%: check_running_vm
	scp -P 4242 level$*@127.0.0.1:/home/level$*/case ./level$*


.PHONY: shellcode
shellcode: 	shellcode.bin
shellcode.bin:	shellcode.asm	
	$(AS) $(ASFLAGS) -o $(basename $@).o $<
	objcopy --dump-section .text=$@ $(basename $@).o
	xxd -i $@


# Eliminamos ficheros intermedios de imagen
.PHONY: clear-deps
clear-deps:
	$(SAFE_RM) $(OVA) $(VMDK)

MK_UTILS := .mk-utils/
$(info test=$(MK_UTILS)utils.mk)
-include $(MK_UTILS)workshop.mk
-include $(MK_UTILS)utils.mk

