//!
//! @file 			BasicTests.cpp
//! @author 		Geoffrey Hunter <gbmhunter@gmail.com> (www.cladlab.com)
//! @created		2014/01/14
//! @last-modified 	2014/01/16
//! @brief 			Contains basic tests.
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

			std::cout << "callBack.obj = " << callBack.obj << "\r\n";
			std::cout << "callback.func = " << callBack.func << "\r\n";

			callBack.Execute(2);

			CHECK_EQUAL(true, classWithFunction.iWasCalled);

		}
		

	} // SUITE(BasicTests)
} // namespace SlotmachineTest
