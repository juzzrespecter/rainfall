# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# 		=====================        #
#       =  Config. Deps     =        #
#       =====================		 #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# Gestión e instalación de utilidades para 
# el desarrollo del proyecto.

VENV ?= .venv
PWNTOOLs ?= 

$(VENV):
	python -m venv $(VENV)

.PHONY: pwntools
pwntools: $(VENV)/bin/pwn

$(VENV)/bin/pwn: | $(VENV)
	$(VENV)/bin/pip install pwntools

r2:
	git clone https://github.com/radareorg/radare2.git r2

.PHONY: pwndbg
pwndbg:
	curl --proto '=https' --tlsv1.2 -LsSf 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb -u

.PHONY: install-utils
install-utils: pwntools r2 pwndbg

.PHONY: clear-utils
clear-utils:
	rm -r ~/.local/lib/pwndbg-gdb ~/.local/bin/pwndbg
	rm -rf $(VENV)
	rm -rf r2
