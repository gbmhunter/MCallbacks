//!
//! @file 			IsValidTests.cpp
//! @author 		Geoffrey Hunter <gbmhunter@gmail.com> (www.cladlab.com)
//! @created		2014/03/20
//! @last-modified 	2014/03/20
//! @brief 			Contains Callback::IsValid() function tests.
//! @details
//!					See README.rst in root dir for more info.

#include "./UnitTest++/src/UnitTest++.h"

#include "../api/Slotmachine.hpp"

#include <iostream>

namespace SlotmachineTest
{
	class ClassWithFunction
	{
	public:
		bool iWasCalled;

		ClassWithFunction()
		{
			// Init as false, callback sets it to true
			iWasCalled = false;
		}

		void TryAndCallMe(uint32_t x)
		{
			iWasCalled = true;
		}

	};

	SUITE(IsValidTests)
	{
		
		TEST(ValidTest)
		{			
			ClassWithFunction classWithFunction;

			SlotMachine::CallbackGen<ClassWithFunction, void, uint32_t> callBackGen(&classWithFunction, &ClassWithFunction::TryAndCallMe);

			SlotMachine::Callback<void, uint32_t> callBack;
			
			// Assign the callback
			callBack = callBackGen;

			//callBack.Execute(2);

			CHECK_EQUAL(true, callBack.IsValid());

		}
		
		TEST(InvalidTest)
		{

			SlotMachine::Callback<void, uint32_t> callBack;

			// Callback hasn't been assigned, so invalid
			CHECK_EQUAL(false, callBack.IsValid());

		}


	} // SUITE(IsValidTests)
} // namespace SlotmachineTest