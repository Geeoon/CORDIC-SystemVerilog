HDL_DIR := ./temp
BUILD_DIR := ./build
TB_DIR := ./tests/testbenches
PACKAGE_DIR := ./tests/packages
HDL_FILES := $(shell find $(HDL_DIR) -name '*.sv' -or -name '*.v' -or -name '*.svh')
PACKAGE_FILES := $(shell find $(PACKAGE_DIR) -name '*.sv' -or -name '*.v')
TB_FILES := $(shell find $(TB_DIR) -name '*.sv' -or -name '*.v')

VERILATOR_BUILD_DIR := $(BUILD_DIR)/verilator
# VERILATOR-NO-WARNINGS := -Wno-MODDUP -Wno-INITIALDLY -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-MULTIDRIVEN -Wno-TIMESCALEMOD -Wno-PINMISSING
VERILATOR-NO-WARNINGS := -Wno-INITIALDLY -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND
VERILATOR-FLAGS := --binary -j 0 $(VERILATOR-NO-WARNINGS) --trace --trace-vcd --no-stop-fail --Mdir $(VERILATOR_BUILD_DIR) # --coverage-line

all: cordic.vcd cordic_sine_tb.vcd

# Verilator
cordic_tb.vcd: $(HDL_FILES) $(PACKAGE_FILES) $(TB_FILES)
	mkdir -p $(VERILATOR_BUILD_DIR)
	verilator $(VERILATOR-FLAGS) --top-module cordic_tb $(HDL_FILES) $(PACKAGE_FILES) $(TB_FILES)
	$(VERILATOR_BUILD_DIR)/Vcordic_tb

cordic_sine_tb.vcd: $(HDL_FILES) $(SIM_FILES)
	mkdir -p $(VERILATOR_BUILD_DIR)
	verilator $(VERILATOR-FLAGS) --top-module cordic_sine_tb $(HDL_FILES) $(PACKAGE_FILES) $(TB_FILES)
	$(VERILATOR_BUILD_DIR)/Vcordic_sine_tb

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

FORCE: ;
