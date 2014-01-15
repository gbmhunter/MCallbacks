#
# @file 		Makefile
# @author 		Geoffrey Hunter <gbmhunter@gmail.com> (wwww.cladlab.com)
# @edited 		n/a
# @date 		2013/08/29
# @brief 		Makefile for Linux-based make, to compile ClideCpp library and run unit test code.
# @details
#				See README.rst

# Define the compiler to use (e.g. gcc, g++)
CC = g++

# Define any compile-time flags (e.g. -Wall, -g)
CFLAGS = -Wall -g -std=c++0x

# Define any directories containing header files other than /usr/include.
# Prefix every directory with "-I" e.g. "-I./src/include"
INCLUDES = -I./include

# Define library paths in addition to /usr/lib
# if I wanted to include libraries not in /usr/lib I'd specify
# their path using -Lpath, something like:
LFLAGS = -L./test/UnitTest++

# Define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname 
#   option, something like (this will link in libmylib.so and libm.so:
LIBS = -lUnitTest++

SRC_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard src/*.cpp))
SRC_LD_FLAGS := 
SRC_CC_FLAGS := -Wall -g

TEST_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard test/*.cpp))
TEST_LD_FLAGS := 
TEST_CC_FLAGS := -Wall -g

EXAMPLE_OBJ_FILES := $(patsubst %.cpp,%.o,$(wildcard example/*.cpp))
EXAMPLE_LD_FLAGS := 
EXAMPLE_CC_FLAGS := -Wall -g

.PHONY: depend clean

# All
all: clideLib test example
	
	# Run unit tests:
	@./test/ClideTest.elf

#======== CLIDE LIB ==========	

clideLib : $(SRC_OBJ_FILES)
	# Make Clide library
	ar r libClide.a $(SRC_OBJ_FILES)
	
# Generic rule for src object files
src/%.o: src/%.cpp
	# Compiling src/ files
	$(COMPILE.c) -MD -o $@ $<
	@cp $*.d $*.P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d
	# g++ $(SRC_CC_FLAGS) -c -o $@ $<

-include $(SRC_OBJ_FILES:.o=.d)
	
	
# ======== TEST ========
	
# Compiles unit test code
test : $(TEST_OBJ_FILES) | clideLib unitTestLib
	# Compiling unit test code
	g++ $(TEST_LD_FLAGS) -o ./test/ClideTest.elf $(TEST_OBJ_FILES) -L./test/UnitTest++ -lUnitTest++ -L./ -lClide
	
# Generic rule for test object files
#test/%.o: test/%.cpp
#	g++ $(TEST_CC_FLAGS) -c -o $@ $<

# Generic rule for test object files
test/%.o: test/%.cpp
	# Compiling src/ files
	$(COMPILE.c) -MD -o $@ $<
	@cp $*.d $*.P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d
	# g++ $(TEST_CC_FLAGS) -c -o $@ $<

-include $(TEST_OBJ_FILES:.o=.d)
	
unitTestLib:
	# Compile UnitTest++ library (has it's own Makefile)
	$(MAKE) -C ./test/UnitTest++/ all
	
# ===== EXAMPLE ======

# Compiles example code
example : $(EXAMPLE_OBJ_FILES) clideLib
	# Compiling example code
	g++ $(EXAMPLE_LD_FLAGS) -o ./example/example.elf $(EXAMPLE_OBJ_FILES) -L./ -lClide
	
# Generic rule for test object files
example/%.o: example/%.cpp
	g++ $(EXAMPLE_CC_FLAGS) -c -o $@ $<
	
# ====== CLEANING ======
	
clean: clean-ut clean-clide
	# Clean UnitTest++ library (has it's own Makefile)
	$(MAKE) -C ./test/UnitTest++/ clean
	
clean-ut:
	@echo " Cleaning test object files..."; $(RM) ./test/*.o
	@echo " Cleaning test executable..."; $(RM) ./test/*.elf
	
clean-clide:
	@echo " Cleaning src object files..."; $(RM) ./src/*.o
	@echo " Cleaning src dependency files..."; $(RM) ./src/*.d
	@echo " Cleaning Clide static library..."; $(RM) ./*.a
	@echo " Cleaning test object files..."; $(RM) ./test/*.o
	@echo " Cleaning test dependency files..."; $(RM) ./test/*.d
	@echo " Cleaning test executable..."; $(RM) ./test/*.elf
	@echo " Cleaning example object files..."; $(RM) ./example/*.o
	@echo " Cleaning example executable..."; $(RM) ./example/*.elf

	
