.PHONY: help
help:
	@echo "Comandos disponíveis:"
	@echo "    help - Mostra essa pagina de help"
	@echo "    lint - Checa errors de sintaxe nos arquivo .vhd"


.PHONY: lint
lint:
	ghdl syntax src/*.vhd src/components/*.vhd src/fpga/*.vhd tests/*.vhd


.PHONY: test
test:
	./run_test.sh tb_semctl
	./run_test.sh tb_reg_deslocamento


.PHONY: clean
clean:
	rm -f tb_* *.vcd *.cf *.o

