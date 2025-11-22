.PHONY: help
help:
	@echo "Comandos disponíveis:"
	@echo "    help - Mostra essa pagina de help"
	@echo "    lint - Checa errors de sintaxe nos arquivo .vhd"


.PHONY: lint
lint:
	ghdl syntax --std=08 src/components/*.vhd tests/*.vhd


