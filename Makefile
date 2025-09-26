HDL_DIR := ./cordic_generated/pipelined
BUILD_DIR := ./build
SIM_DIR := ./tests
HDL_FILES := $(shell find $(HDL_DIR) -name '*.sv' -or -name '*.v' -or -name '*.svh')
SIM_FILES := $(shell find $(SIM_DIR) -name '*.sv' -or -name '*.v')
VERILATOR_BUILD_DIR := $(BUILD_DIR)/verilator
# VERILATOR-NO-WARNINGS := -Wno-MODDUP -Wno-INITIALDLY -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-MULTIDRIVEN -Wno-TIMESCALEMOD -Wno-PINMISSING
VERILATOR-NO-WARNINGS := -Wno-INITIALDLY -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND
VERILATOR-FLAGS := --binary -j 0 $(VERILATOR-NO-WARNINGS) --trace --Mdir $(VERILATOR_BUILD_DIR)

all: cordic.vcd

# Verilator
cordic.vcd: $(HDL_FILES) $(SIM_FILES)
	mkdir -p $(VERILATOR_BUILD_DIR)
	verilator $(VERILATOR-FLAGS) --top-module cordic_tb $(HDL_FILES) $(SIM_FILES)
	$(VERILATOR_BUILD_DIR)/Vcordic_tb

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

FORCE: ;
