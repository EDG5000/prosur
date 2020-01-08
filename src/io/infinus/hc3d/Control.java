package io.infinus.hc3d;

public class Control {
	public static void init() {
		
	}
	
	// Working fields for main temperaturePID controller
	static float previousError = 0;
	static float integral = 0;
	static float error;
	static float derrivative;
	static float output;
	
	final static float DT = LLC.TICK_INTERVAL; // not exactly, should be close enough
	
	
	public static void onLLCTickComplete() {
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
		error = Main.Params.HC_TEMP_SET.getValue() - Temperatures.getTemperature(0);
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
