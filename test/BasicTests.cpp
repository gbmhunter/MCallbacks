//!
//! @file 			BasicTests.cpp
//! @author 		Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
//! @created		2014-01-14
//! @last-modified 	2014-09-01
//! @brief 			Contains basic tests.
//! @details
//!					See README.rst in root dir for more info.


// System libraries
#include <iostream>

// User libraries
#include "unittest-cpp/UnitTest++/UnitTest++.h"

// User source
#include "../api/Slotmachine.hpp"


namespace SlotmachineTest
{
	class ClassWithFunction
	{
	public:
		bool iWasCalled;

		ClassWithFunction()
		{
			iWasCalled = false;
		}


		void TryAndCallMe(uint32_t x)
		{
			std::cout << "I was called!\r\n";
			iWasCalled = true;
		}

	};


	SUITE(BasicTests)
	{
		
		TEST(BasicTest)
		{			
			ClassWithFunction classWithFunction;

			SlotMachine::CallbackGen<ClassWithFunction, void, uint32_t> callBackGen(&classWithFunction, &ClassWithFunction::TryAndCallMe);

			SlotMachine::Callback<void, uint32_t> callBack;
			
			callBack = callBackGen;


			callBack.Execute(2);

			CHECK_EQUAL(true, classWithFunction.iWasCalled);

		}
		
		TEST(InvalidTest)
		{

			SlotMachine::Callback<void, uint32_t> callBack;

			// Callback hasn't been assigned, so invalid
			callBack.Execute(2);

			// If it made it to this point, invalid callback hasn't crashed the system, so we are good :-)
			CHECK(true);

		}


	} // SUITE(BasicTests)
} // namespace SlotmachineTest
