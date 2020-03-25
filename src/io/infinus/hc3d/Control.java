package io.infinus.hc3d;

import io.infinus.hc3d.modules.Failsafe;

public class Control {
	static float[] lastTemperatures = new float[C.LLC_TEMP_SENSOR_COUNT];
	
	public static final float TEMP_DEADBAND_UPPER = C.TEMP_PUMP_THRESHOLD + (C.TEMP_PUMP_DEADBAND/2f);
	public static final float TEMP_DEADBAND_LOWER = C.TEMP_PUMP_THRESHOLD - (C.TEMP_PUMP_DEADBAND/2f);
	
	static {
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			lastTemperatures[i] = -1;
		}
	}
	
	/*final static int ACTION_NOTHING = 0;
	final static int ACTION_DISABLE = 1;
	final static int ACTION_ENABLE = 2;*/
	
	static boolean initial = true;
	
	//static int lastAction = ACTION_NOTHING;
	
	public static void onLLCTickComplete() {
		if(Failsafe.failsafeActive) {
			// Do not touch the relays when the failsafe was activated, the failsafe is to be permament
			return;
		}

		if(initial) {
			// In case relay is still set to 1 when HLC is rebooted, set LLC value to 0 just in case
			// Will be set to 1 again if a high temperature is detected
			initial = false;
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0f);
			
			// Fix cooling pump (assinged to HE_FAN) to 35% duty cycle to reduce noise. Tested to provide enough cooling
			LLC.setValue(LLC.OUT.PWM_FAN_HE_IN, .35f); //TODO test this statement, should work fine. (enable LLC logging to see PWM vlaues?)
		}
		
		 
		
		
		/*for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			
		}*/
		
		
		boolean riserFound = false;
		//boolean dropperFound = false;
		boolean allTempsLow = true;
		
		//int action = ACTION_NOTHING;
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			if(Temperature.temperatures[i] > TEMP_DEADBAND_LOWER) {
				// Not all temps are below lower deadband boundary
				allTempsLow = false;
			}
			
			if(Temperature.temperatures[i] > TEMP_DEADBAND_UPPER && lastTemperatures[i] <= TEMP_DEADBAND_UPPER){
				// Temp just increased to above the upper deadband limit
				riserFound = true;
			}
		}
		
		if(riserFound) {
			Main.log("Watercooling threshold temperature exceeded.");
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1f);
		}else if(allTempsLow) {
			Main.log("Dropped below watercooling threshold temperature condition.");
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0f);
		}

		/////////// !!!!!!!!!!!!!!
		// TODO add explanation: why did the system drop below temp thresh? Log which sensor and which value
		
		/*if(action == ACTION_DISABLE) {

		}else if(action == ACTION_ENABLE) {

		}*/
		
		// Store last temperatures
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			lastTemperatures[i] = Temperature.temperatures[i];
		}
	}
}
