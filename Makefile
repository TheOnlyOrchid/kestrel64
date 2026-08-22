PROJECT := kestrel64
BUILD_DIR := build
SRC_DIR := src

NASM ?= nasm
CC_WIN ?= x86_64-w64-mingw32-gcc
WINE ?= wine

ASM_SOURCES := $(shell find $(SRC_DIR) -type f -name '*.asm')
OBJECTS := $(patsubst $(SRC_DIR)/%.asm,$(BUILD_DIR)/%.o,$(ASM_SOURCES))
TARGET := $(BUILD_DIR)/$(PROJECT).exe

.PHONY: all build run clean tree check-tools

all: build

build: check-tools $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CC_WIN) -nostdlib -Wl,-e,main -o $@ $^ -lkernel32

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(dir $@)
	$(NASM) -f win64 -g -F cv8 -o $@ $<

run: build
	$(WINE) $(TARGET)

clean:
	rm -rf $(BUILD_DIR)

tree:
	@printf "Project files:\n" && find . -maxdepth 4 -type f | sort

check-tools:
	@command -v $(NASM) >/dev/null || (echo "Missing: $(NASM)" && exit 1)
	@command -v $(CC_WIN) >/dev/null || (echo "Missing: $(CC_WIN) (install mingw-w64)" && exit 1)
	@command -v $(WINE) >/dev/null || (echo "Missing: $(WINE)" && exit 1)
