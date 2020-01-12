package io.infinus.hc3d;

public class Control {
	private static boolean active = false;
	
	// Working fields for main temperaturePID controller
	static float previousError = 0;
	static float integral = 0;
	static float error;
	static float derrivative;
	static float output;
	
	final static float DT = LLC.TICK_INTERVAL; // not exactly, should be close enough
	
	public static void init() {
		// Currenly RECIR is set to max on startup, and kept that way
		// Closing application will make the adapter go into failsafe mode which
		// will keep the PWM values at max
		LLC.setValue(LLC.OUT.PWM_FAN_RECIR_B, 1);
		LLC.setValue(LLC.OUT.PWM_FAN_RECIR_F, 1);
	}
	
	public static void on() {
		LLC.setValue(LLC.OUT.PWM_FAN_HE_IN, .1f); // Ensure a gradual start in case time to next tick is long
		LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1);
		active = true;
	}
	
	public static void off() {
		active = false;
		// Cleanup PID controller
		previousError = 0;
		integral = 0;
		// Turn off fans and pumps
		LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0);
	}
	
	public static void onLLCTickComplete() {
		if(!active) return;
		/*
		 * TODO if
		 * 
		 * !enable ||
		 * !LLC.populated
		 * 
		 * return;
		 */
		
		
		// HC temp PID control
		// Based on Temp1
		// Currently only controlling HE_IN fan
		error = Main.Params.HCT.getValue() - Temperatures.getTemperature(0);
		integral += error * DT;
		derrivative = (error - previousError) / DT;
		output = Main.Params.P.getValue() * error + Main.Params.I.getValue() * integral + Main.Params.D.getValue() * derrivative;
		previousError = error;
		// Apply output
		LLC.setValue(LLC.OUT.PWM_FAN_HE_IN, output); // TODO min/max, anti windup
		
		/*
		    error := setpoint − measured_value
		    integral := integral + error × dt
		    derivative := (error − previous_error) / dt
		    output := Kp × error + Ki × integral + Kd × derivative
		    previous_error := error
		    wait(dt)
		    goto loop
		 */
		
		
		
	}
}
