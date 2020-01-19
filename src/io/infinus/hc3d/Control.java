package io.infinus.hc3d;

public class Control {
	static boolean initialized = false;
	
	// Working fields for main temperaturePID controller
	static float previousError = 0;
	static float integral = 0;
	static float error;
	static float derrivative;
	static float output;
	
	final static float DT = LLC.TICK_INTERVAL; // not exactly, should be close enough
	
	// Control parameters, fetched from persisent storage on startup
	public static class Params{
		public static Param P;
		public static Param I;
		public static Param D;
		public static Param HCT;
		public static Param MANUAL_FAN_RECIR_F_PWM;
		public static Param MANUAL_FAN_RECIR_B_PWM;
		public static Param MANUAL_FAN_HE_I_PWM;
		public static Param MODE;
	}

	public static void init() {
		// Initialize and load stored values for parameters
		Params.P = new Param("P");
		Params.I = new Param("I");
		Params.D = new Param("D");
		Params.HCT = new Param("HCT");
		Params.MODE = new Param("MODE");
		Params.MANUAL_FAN_HE_I_PWM = new Param("HEFI");
		Params.MANUAL_FAN_RECIR_F_PWM = new Param("RCRF");
		Params.MANUAL_FAN_RECIR_B_PWM = new Param("RCRB");
		
		// Currenly RECIR is set to max on startup, and kept that way
		// Closing application will make the adapter go into failsafe mode which
		// will keep the PWM values at max
		LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1);
		LLC.setValue(LLC.OUT.PWM_FAN_HE_IN, 0);
		LLC.setValue(LLC.OUT.PWM_FAN_RECIR_B, 0);
		LLC.setValue(LLC.OUT.PWM_FAN_RECIR_F, 0);
		
		LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_A, 0);
		LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_B, 0);
		
		initialized = true;
	}
	
	public static void setMode(float pMode) {
		int mode = (int) pMode;
		switch(mode) {
		case C.MODE_ON:
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1);
			
			// HE IN fan will be set in PID loop, set recir to fixed values for now
			LLC.setValue(LLC.OUT.PWM_FAN_RECIR_B, 1);
			LLC.setValue(LLC.OUT.PWM_FAN_RECIR_F, 1);
			break;
		case C.MODE_MANUAL:
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1);
			
			// All fan outputs are set in llc serial tick
			break;
		case C.MODE_OFF:
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0);
			
			LLC.setValue(LLC.OUT.PWM_FAN_HE_IN, 0);
			LLC.setValue(LLC.OUT.PWM_FAN_RECIR_B, 0);
			LLC.setValue(LLC.OUT.PWM_FAN_RECIR_F, 0);
			
			// Cleanup PID controller
			previousError = 0;
			integral = 0;
			break;
		}
	}
	
	public static void onLLCTickComplete() {
		if(!initialized || !LLC.getIsSettled() || Params.MODE.getValue() == C.MODE_OFF) return;
		
		if(Params.MODE.getValue() == C.MODE_MANUAL) {
			// Apply manual output setpoints, skip PID calculations
			LLC.setValue(LLC.OUT.PWM_FAN_HE_IN, Params.MANUAL_FAN_HE_I_PWM.getValue());
			LLC.setValue(LLC.OUT.PWM_FAN_RECIR_B, Params.MANUAL_FAN_RECIR_B_PWM.getValue());
			LLC.setValue(LLC.OUT.PWM_FAN_RECIR_F, Params.MANUAL_FAN_RECIR_F_PWM.getValue());
			return;
		}
		
		// HC temp PID control
		// Based on Temp1
		// Currently only controlling HE_IN fan
		error = Params.HCT.getValue() - LLC.getValue(C.LLC_TEMP_SENSOR_OFFSET + 0);
		integral += error * DT;
		derrivative = (error - previousError) / DT;
		output = Params.P.getValue() * error + Params.I.getValue() * integral + Params.D.getValue() * derrivative;
		previousError = error;
		if(output < 0) output = 0;
		if(output > 1) output = 1;
		
		// Apply output
		LLC.setValue(LLC.OUT.PWM_FAN_HE_IN, output); // TODO anti windup?
	}
}
