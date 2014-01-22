//!
//! @file 			Callback.hpp
//! @author 		Geoffrey Hunter <gbmhunter@gmail.com> (www.cladlab.com)
//! @created		2014/01/14
//! @last-modified 	2014/01/16
//! @brief			Contains the CallbackBase, Callback and CallbackGen classes.
//! @details
//!					See README.rst in root dir for more info.

#ifndef __cplusplus
	#error Please build with C++ compiler
#endif

//===============================================================================================//
//======================================== HEADER GUARD =========================================//
//===============================================================================================//

#ifndef SLOTMACHINE_CALLBACK_H
#define SLOTMACHINE_CALLBACK_H

//===============================================================================================//
//========================================== INCLUDES ===========================================//
//===============================================================================================//

// System headers
#include <stdint.h>
#include <iostream>
#include <string.h>

// User headers

//===============================================================================================//
//======================================== NAMESPACE ============================================//
//===============================================================================================//

namespace SlotMachine
{

	//! @brief		This is a base class for the Caller class.
	//! @details	Always requires the return type, and accepts 0 or 1 function arguments whose type needs to be specified.
	template<class returnType, class fArg1Type>
	class CallbackBase
	{	
		
	public:

		typedef returnType (CallbackBase::*funcT)(fArg1Type);

		//===============================================================================================//
		//======================================= PUBLIC VARIABLES ======================================//
		//===============================================================================================//


		CallbackBase *obj;
		funcT func;
			
		//===============================================================================================//
		//========================================= PUBLIC METHODS ======================================//
		//===============================================================================================//

		returnType Execute(fArg1Type fArg1)
		{
			std::cout << "Error: Should never get here!";
			// To keep the compiler happy
			return returnType();
		}

	protected:


		
	};

	//! @brief		This is used to create objects that can be assigned to a callback function and then executed.
	//! @details	Uses the same template arguments as CallerBase.
	template<class returnType, class fArg1Type>
	class Callback : public virtual CallbackBase<returnType, fArg1Type>
	{

	public:

		//Callback *obj;

		//! @brief	Constructor
		Callback()
		{
			this->obj = 0;
		}

		Callback& operator=(const Callback<returnType, fArg1Type> &callback)
		{
			// Check if the right-hand side Callback object has been initialised
			if(&callback != NULL)
			{
				this->obj = callback.obj;
				this->func = callback.func;

			}
			else
				Callback();
			return *this;
		}

		returnType Execute(fArg1Type fArg1)
		{
			if(this->obj == NULL)
				return (returnType)NULL;

			// Callback is NOT NULL
			return (this->obj->*this->func)(fArg1);

		}

	protected:

	};

	//! @brief		This can generate callbacks to member functions!
	//! @details	Note that this has one more type than the callback classes, that is, a type for the object that the callback function belongs to.
	template<class objType, class returnType, class fArg1 = void, class fArg2 = void>
	class CallbackGen : public Callback<returnType, fArg1>
	{
	public:

		// Create method pointer type (points to method of a particular class
		typedef returnType (objType::*funcT)(fArg1);


		//! @brief		Constructor
		CallbackGen(objType* obj, funcT func)
		{
			// This memcpy() trick is used to assign (copy) objects of different types.
			// This trick is key to how the callbacks are type independent
			memcpy(&this->func, &func, sizeof(func));
			memcpy(&this->obj, &obj, sizeof(obj));
		}
	protected:
		CallbackGen();
	};

} // namespace Slotmachine

#endif	// #ifndef SLOTMACHINE_CALLBACK_H

// EOF
