==============================================================
Slotmachine
==============================================================

.. image:: https://api.travis-ci.org/gbmhunter/slotmachine-cpp.png?branch=master   
	:target: https://travis-ci.org/gbmhunter/slotmachine-cpp

- Author: gbmhunter <gbmhunter@gmail.com> (http://www.cladlab.com)
- Created: 2014/01/14
- Last Modified: 2014/01/16
- Version: v1.0.0.0
- Company: CladLabs
- Project: Free Code Libraries
- Language: C++
- Compiler: GCC	
- uC Model: n/a
- Computer Architecture: n/a
- Operating System: n/a
- Documentation Format: Doxygen
- License: GPLv3

.. role:: bash(code)
	:language: bash

Description
===========

A type-independent method-capable callback and event library for C++.

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

======== ========== ===================================================================================================
Version  Date       Comment
======== ========== ===================================================================================================
v1.0.0.0 2014/01/16 Initial commit. Library supports method callbacks with one input argument.
======== ========== ===================================================================================================