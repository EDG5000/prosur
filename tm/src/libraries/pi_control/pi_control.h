/*
	Proportional-integral (PI) control law header file.
 
	For many applications, PI control is sufficient, and PID control is nontrivial to implement correctly.
	This is a PI controller written with integer arithmetic.  The implementation uses a struct to hold both
	the gain parameters and the integrator value, so many controllers can be implemented with the same
	code.  The error is passed as an argument to the function, so care should be taken to make sure that the
	error computation, which occurs outside the controller in the user's code, does not cause overflow.

	Integrator wind-up is a phenomenon that can occur when the output is saturated.  This controller checks
	the output for saturation and, if the P+I terms exceed the desired control range, the new integrator
	value is not saved if doing so would deepen the saturation. This helps to prevent extreme overshoot
	during large disturbances or setpoint steps.

	This controller is implemented with integer math.  To provide fractional gain resolution, a right bit
	shift is performed on the final result.  Adjusting the shift parameter scales the net control gain by
	a factor of two for coarse adjustment.  The gain parameters kp and ki can then be used to make fine
	adjustsments.
	
	https://www.embeddedrelated.com/showcode/346.php
*/

#pragma once

/** PI control data structure.  This structure contains configuration (the
    proportional and integral gain, plus a final divisor), output limits, and
    an integration accumulator (the PI controller's state variable). */
struct PIControl
{
  int16_t kp;          /**< Proportional gain constant */
  int16_t ki;          /**< Integral gain constant */
  uint8_t shift; 	   /**< Right shift to divide */
  int16_t max;         /**< Maximum value */
  int16_t min;         /**< Minimum value */
  int32_t i;           /**< Current integrator value */
};

/* Prototypes */
int16_t pi_control (struct PIControl *p, int16_t e);
void pi_control_init (struct PIControl *p);
