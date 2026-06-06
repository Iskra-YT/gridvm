ASM=nasm
ASMFLAGS=-f elf64

SRC_DIR=src
BUILD_DIR=build
INCLUDE_DIR=include

SRCS=$(wildcard $(SRC_DIR)/*.asm)
OBJS=$(patsubst $(SRC_DIR)/%.asm,$(BUILD_DIR)/%.o,$(SRCS))

TARGET=$(BUILD_DIR)/app

all: $(BUILD_DIR) $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(TARGET): $(OBJS)
	ld -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM) $(ASMFLAGS) $< -o $@ -I$(INCLUDE_DIR)/

clean:
	rm -rf $(BUILD_DIR)

run: all
	./$(TARGET)