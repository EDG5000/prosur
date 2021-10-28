/**
 * @file
 * Proportional-integral (PI) control law.
 *
 * This module implements a simple position-type PI controller:
 * <pre>
 *   u = [ kp * e + ki * sum(e) ] >> shift
 * </pre>
 * <tt>shift</tt> is a right bit shift used to scale the output of the
 * controller down from the 32-bit intermediate result.
 *
 * An anti-windup provision is implemented on the PI integrator to prevent
 * deep saturation (aka integrator windup):
 * - The new control output with the latest integrator value is computed.
 * - If the control output exceeds either output limit, <i>and</i> the latest
 *   change in the integrator is in the same direction, then the new integrator
 *   value is not saved for the next call.
 * - Otherwise, the integrator is saved for the next call.
 */

#include <stdbool.h>
#include "stdint.h"
#include "libraries/pi_control/pi_control.h"

/**
 * Proportional-integral (PI) control law.
 *
 * @param[in,out]  p    control parameter and state structure
 * @param[in]      e    error signal
 *
 * @return              control output <code>u</code>
 */
int16_t pi_control (struct PIControl *p, int16_t e)
{
  bool int_ok;      /* Whether or not the integrator should update */
  int32_t new_i;    /* Proposed new integrator value */
  int32_t u;        /* Control output */
  
  /* Compute new integrator and the final control output. */
  new_i = p->i + e;
  u = (p->kp * (int32_t)e + p->ki * new_i) >> p->shift;

  /* Check for saturation.  In the event of saturation in any one direction,
     inhibit saving the integrator if doing so would deepen the saturation. */
  int_ok = true;
     
  /* Positive saturation? */
  if (u > p->max)
  {
    /* Clamp the output */
    u = p->max;

    /* Error is the same sign? Inhibit integration. */
    if (e > 0)
    {
      int_ok = false;
    }
  }
  /* Repeat for negative sign */
  else if (u < p->min)
  {
    u = p->min;
    
    if (e < 0)
    {
      int_ok = false;
    }
  }
  
  /* Update the integrator if allowed. */
  if (int_ok)
  {
    p->i = new_i;
  }

  return (int16_t) u;
}

/**
 * Initializes the PI control.
 *
 * This function resets the PI integrator to zero.
 *
 * @param[in,out]  p  control parameter structure
 */
void pi_control_init (struct PIControl *p)
{
  p->i = 0L;
}
