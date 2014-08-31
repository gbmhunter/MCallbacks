#
# @file 			Makefile
# @author 			Geoffrey Hunter <gbmhunter@gmail.com> (wwww.mbedded.ninja)
# @edited 			n/a
# @date 			2013-08-29
# @last-modified	2014-09-01
# @brief 			Makefile for Linux-based make, to compile the SlotMachine library and run unit test code.
# @details
#					See README.rst

SHELL := /bin/bash

# Define the compiler to use (e.g. gcc, g++)
CC = g++

# Define any compile-time flags (e.g. -Wall, -g)
CFLAGS = -Wall -g -std=c++0x

# Define any directories containing header files other than /usr/include.
# Prefix every directory with "-I" e.g. "-I./src/include"
INCLUDES = -I./include

SRC_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard src/*.cpp))
SRC_LD_FLAGS := 
SRC_CC_FLAGS := -Wall -g

TEST_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard test/*.cpp))
TEST_LD_FLAGS := 
TEST_CC_FLAGS := -Wall -g

EXAMPLE_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard example/*.cpp))
EXAMPLE_LD_FLAGS := 
EXAMPLE_CC_FLAGS := -Wall -g

DEP_LIB_PATHS := -L ../unittest-cpp
DEP_LIBS := -l UnitTest++
DEP_INCLUDE_PATHS := -I../

.PHONY: depend clean

# All
all: slotMachineLib test example
	
	# Run unit tests:
	@./test/SlotMachineTest.elf

#======== CLIDE LIB ==========	

slotMachineLib : $(SRC_OBJ_FILES)
	# Make slot-machine library
	ar r libSlotMachine.a $(SRC_OBJ_FILES)
	
# Generic rule for src object files
src/%.o: src/%.cpp
	# Compiling src/ files
	$(COMPILE.c) $(DEP_INCLUDE_PATHS) -MD -o $@ $<
	@cp $*.d $*.P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d
	# g++ $(SRC_CC_FLAGS) -c -o $@ $<

-include $(SRC_OBJ_FILES:.o=.d)
	
	
# ======== TEST ========
	
# Compiles unit test code
test : $(TEST_OBJ_FILES) | slotMachineLib unitTestLib
	# Compiling unit test code
	g++ $(TEST_LD_FLAGS) -o ./test/SlotMachineTest.elf $(TEST_OBJ_FILES) $(DEP_LIB_PATHS) $(DEP_LIBS) -L./ -lSlotMachine

# Generic rule for test object files
test/%.o: test/%.cpp
	# Compiling src/ files
	$(COMPILE.c) $(DEP_INCLUDE_PATHS) -MD -o $@ $<
	@cp $*.d $*.P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d
	# g++ $(TEST_CC_FLAGS) -c -o $@ $<

-include $(TEST_OBJ_FILES:.o=.d)
	
unitTestLib:
	# Compile UnitTest++ library (has it's own Makefile)
	# Save source dir
	pushd .; \
	cd ../unittest-cpp; \
	cmake .; \
	$(MAKE) all; \
	# Go back to source dir
	
# ===== EXAMPLE ======

# Compiles example code
example : $(EXAMPLE_OBJ_FILES) slotMachineLib
	# Compiling example code
	g++ $(EXAMPLE_LD_FLAGS) -o ./example/example.elf $(EXAMPLE_OBJ_FILES) $(DEP_LIB_PATHS) $(DEP_LIBS) -L./ -lSlotMachine
	
# Generic rule for test object files
example/%.o: example/%.cpp
	g++ $(EXAMPLE_CC_FLAGS) $(DEP_INCLUDE_PATHS) -c -o $@ $<
	
# ====== CLEANING ======
	
clean: clean-ut clean-slot-machine
	# Clean UnitTest++ library (has it's own Makefile)
	cd ../unittest-cpp; \
	make clean;
	
clean-ut:
	@echo " Cleaning test object files..."; $(RM) ./test/*.o
	@echo " Cleaning test executable..."; $(RM) ./test/*.elf
	
clean-slot-machine:
	@echo " Cleaning src object files..."; $(RM) ./src/*.o
	@echo " Cleaning src dependency files..."; $(RM) ./src/*.d
	@echo " Cleaning Slot Machine static library..."; $(RM) ./*.a
	@echo " Cleaning test object files..."; $(RM) ./test/*.o
	@echo " Cleaning test dependency files..."; $(RM) ./test/*.d
	@echo " Cleaning test executable..."; $(RM) ./test/*.elf
	@echo " Cleaning example object files..."; $(RM) ./example/*.o
	@echo " Cleaning example executable..."; $(RM) ./example/*.elf

	
