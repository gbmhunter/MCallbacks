#
# @file 			Makefile
# @author 			Geoffrey Hunter <gbmhunter@gmail.com> (wwww.mbedded.ninja)
# @edited 			n/a
# @date 			2013-08-29
# @last-modified	2014-09-14
# @brief 			Makefile for Linux-based make, to compile the MCallbacks library and run unit test code.
# @details
#					See README.rst

SHELL := /bin/bash

SRC_COMPILER := g++
SRC_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard src/*.cpp))
SRC_LD_FLAGS := 
SRC_CC_FLAGS := -Wall -g -c  -I. -std=c++11

TEST_COMPILER := g++
TEST_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard test/*.cpp))
TEST_LD_FLAGS := 
TEST_CC_FLAGS := -Wall -g -c -I. -std=c++11

EXAMPLE_COMPILER := g++
EXAMPLE_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard example/*.cpp))
EXAMPLE_LD_FLAGS := 
EXAMPLE_CC_FLAGS := -Wall -g -c -I. -std=c++11

DEP_LIB_PATHS := -L ../MAssert -L ../MUnitTest
DEP_LIBS := -l MAssert -l MUnitTest
DEP_INCLUDE_PATHS := -I../


.PHONY: depend clean

# All
all: src test example
	
	# Run unit tests:
	@./test/Tests.elf

#======== SRC LIB ==========	

src : $(SRC_OBJ_FILES)
	# Make slot-machine library
	ar r libMCallbacks.a $(SRC_OBJ_FILES)
	
# Generic rule for src object files
src/%.o: src/%.cpp
	# Compiling src/ files
	$(SRC_COMPILER) $(SRC_CC_FLAGS) $(DEP_INCLUDE_PATHS) -MD -o $@ $<
	@cp $*.d $*.P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d
	# g++ $(SRC_CC_FLAGS) -c -o $@ $<

-include $(SRC_OBJ_FILES:.o=.d)
	
# ======== DEPENDENCIES ========

deps :
	# Downloading and building dependencies...
	if [ ! -d ../MUnitTest ]; then \
	git clone https://github.com/mbedded-ninja/MUnitTest ../MUnitTest; \
	fi;
	$(MAKE) -C ../MUnitTest/ all
	if [ ! -d ../MAssert ]; then \
	git clone https://github.com/mbedded-ninja/MAssert ../MAssert; \
	fi;
	$(MAKE) -C ../MAssert/ all
	
# ======== TEST ========
	
# Compiles unit test code
test : deps $(TEST_OBJ_FILES) | src
	# Compiling unit test code
	g++ $(TEST_LD_FLAGS) -o ./test/Tests.elf $(TEST_OBJ_FILES) $(DEP_LIB_PATHS) $(DEP_LIBS) -L./ -lMCallbacks

# Generic rule for test object files
test/%.o: test/%.cpp
	# Compiling test/ files
	$(TEST_COMPILER) $(TEST_CC_FLAGS) $(DEP_INCLUDE_PATHS) -MD -o $@ $<
	@cp $*.d $*.P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d
	# g++ $(TEST_CC_FLAGS) -c -o $@ $<

-include $(TEST_OBJ_FILES:.o=.d)
	
# ===== EXAMPLE ======

# Compiles example code
example : $(EXAMPLE_OBJ_FILES) src
	# Compiling example code
	g++ $(EXAMPLE_LD_FLAGS) -o ./example/example.elf $(EXAMPLE_OBJ_FILES) $(DEP_LIB_PATHS) $(DEP_LIBS) -L./ -lMCallbacks
	
# Generic rule for test object files
example/%.o: example/%.cpp
	$(EXAMPLE_COMPILER) $(EXAMPLE_CC_FLAGS) $(DEP_INCLUDE_PATHS) -c -o $@ $<
	
# ====== CLEANING ======
	
clean: clean-src clean-deps clean-ut
	
clean-src:
	@echo " Cleaning src object files..."; $(RM) ./src/*.o
	@echo " Cleaning src dependency files..."; $(RM) ./src/*.d
	@echo " Cleaning Slot Machine static library..."; $(RM) ./*.a
	@echo " Cleaning test object files..."; $(RM) ./test/*.o
	@echo " Cleaning test dependency files..."; $(RM) ./test/*.d
	@echo " Cleaning test executable..."; $(RM) ./test/*.elf
	@echo " Cleaning example object files..."; $(RM) ./example/*.o
	@echo " Cleaning example executable..."; $(RM) ./example/*.elf
	
clean-deps:
	@echo " Cleaning deps...";
	$(MAKE) -C ../MUnitTest/ clean
	$(MAKE) -C ../MAssert/ clean
	
clean-ut:
	@echo " Cleaning test object files..."; $(RM) ./test/*.o
	@echo " Cleaning test executable..."; $(RM) ./test/*.elf

	
