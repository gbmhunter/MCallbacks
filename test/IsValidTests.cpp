//!
//! @file 			IsValidTests.cpp
//! @author 		Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
//! @created		2014-03-20
//! @last-modified 	2014-09-14
//! @brief 			Contains Callback::IsValid() function tests.
//! @details
//!					See README.rst in root dir for more info.

//===== SYSTEM LIBRARIES =====//
#include <iostream>

//====== USER LIBRARIES =====//
#include "MUnitTest/api/MUnitTestApi.hpp"

//===== USER SOURCE =====//
#include "../api/MCallbacksApi.hpp"

namespace MCallbacksTests
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

		
	MTEST(CallbacksValidTest)
	{
		ClassWithFunction classWithFunction;

		MCallbacks::CallbackGen<ClassWithFunction, void, uint32_t> callBackGen(&classWithFunction, &ClassWithFunction::TryAndCallMe);

		MCallbacks::Callback<void, uint32_t> callBack;

		// Assign the callback
		callBack = callBackGen;

		//callBack.Execute(2);

		CHECK_EQUAL(true, callBack.IsValid());

	}

	MTEST(CallbacksInvalidTest)
	{

		MCallbacks::Callback<void, uint32_t> callBack;

		// Callback hasn't been assigned, so invalid
		CHECK_EQUAL(false, callBack.IsValid());

	}

} // namespace MCallbacksTests
