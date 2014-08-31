==============================================================
SlotMachineCpp
==============================================================

.. image:: https://api.travis-ci.org/mbedded-ninja/SlotmachineCpp.png?branch=master   
	:target: https://travis-ci.org/mbedded-ninja/SlotmachineCpp

- Author: gbmhunter <gbmhunter@gmail.com> (http://www.mbedded.ninja)
- Created: 2014-01-14
- Last Modified: 2014-09-01
- Version: v1.2.1.0
- Company: mbedded.ninja
- Project: Free Code Libraries
- Language: C++
- Compiler: GCC	
- uC Model: Any
- Computer Architecture: Any
- Operating System: Any
- Documentation Format: Doxygen
- License: GPLv3

.. role:: bash(code)
	:language: bash

Description
===========

A type-independent method-capable callback and event library for C++.

Usage
=====

::

	class ClassWithFunction
	{
		public:
	
			ClassWithFunction(){};
	
			void TryAndCallMe(uint32_t x)
			{
				std::cout << "I was called!\r\n";
			}
	};
	
	function CallTheCallback(SlotMachine::Callback<void, uint32_t> callBack)
	{
		// Run the callback function. This will print "I was called!" to stdout
		callBack.Execute(2);
	}


	int main()
	{
		// Create an object with a method to call (this is what the callback will call)
		ClassWithFunction classWithFunction;

		// Create the callback, calling a method of object classWithFunction
		SlotMachine::CallbackGen<ClassWithFunction, void, uint32_t> callBack(&classWithFunction, &ClassWithFunction::TryAndCallMe);

		// Pass the callback to another function (just as an example)
		CallTheCallback(callBack);
	}
	
	

Installation
============

1. Clone the git repo onto your local storage.

2. Run `make all` to compile and run unit tests.

3. To include slotmachine-cpp into your embedded (or otherwise) firmware/software project, copy the repo into your project folder (or other suitable place) and include the file "api/Slotmachine.hpp" from your C++ code. No source files need to be compiled.


External Dependencies
=====================

The following table lists all of slotmachine-cpp's external dependencies.

====================== ==================== ======================================================================
Dependency             Delivery             Usage
====================== ==================== ======================================================================
<stdio.h>              Standard C library   snprintf()
<stdlib.h> 	           Standard C library   realloc(), malloc(), calloc(), free()
====================== ==================== ======================================================================


Issues
======

See GitHub Issues.

Limitations
===========

Only supports callback methods with one input argument. Plan to expand this to an arbitary amount (up to a suitable limit) in the future.

Usage
=====

Not yet added...

FAQ
===

Not yet added...

Changelog
=========

========= ========== ===================================================================================================
Version   Date       Comment
========= ========== ===================================================================================================
v1.2.1.0  2014-09-01 Fixed issue with '.travis.yml' file.
v1.2.0.0  2014-09-01 Removed UnitTest++ library from 'test/', it is now an external dependency, closes #7. Downloads UnitTest++ library as part of install step in the travis/yml config file.
v1.1.2.2  2014-09-01 Deleted the 'package.json' file. Added Cpp to title in README, closes #6.
v1.1.2.1  2014-08-30 Fixed the version number in the 'package.json' file.
v1.1.2.0  2014-08-30 Added 'package.json' file for clib support, closes #4. Fixed website references in README, closes #5.
v1.1.1.0  2014-03-20 Added Callback::IsValid() so user can check whether callback is valid before calling Execute(). Added associated unit tests in IsValidTests.cpp.
v1.1.0.0  2014-01-22 Added check for valid callback in 'Execute()' function. Added invalid callback unit test. Added 'Usage' section to README. Removed printing to stdout in assignment operator overload.
v1.0.0.0  2014-01-16 Initial commit. Library supports method callbacks with one input argument.
========= ========== ===================================================================================================