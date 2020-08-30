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
	
	static boolean initial = true;
	
	public static void onLLCTickComplete() {
		if(Failsafe.failsafeActive) {
			// Do not touch the relays when the failsafe was activated, the failsafe is to be permament
			return;
		}

		if(initial) {
			// In case relay is still set to 1 when HLC is rebooted, set LLC value to 0 just in case
			// Will be set to 1 again if a high temperature is detected
			initial = false;
			//LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0f);
			
			/*
			 * The following values are constant and (currently) not adjusted under any condition by Control
			 * TODO the following values do not work; after some time USB seems to reset itself causing the values to reset on LLC
			 * Also values of -1 are written causing problems!
			 */
			
			// Fix cooling pump (assinged to HE_FAN) to 35% duty cycle to reduce noise. Tested to provide enough cooling
			//LLC.setValue(LLC.OUT.PWM_PUMP, 1f); //TODO test this statement, should work fine. (enable LLC logging to see PWM value?)
			// Watercooling heatsink fans
			//LLC.setValue(LLC.OUT.PWM_FAN_RECIR_B, 1f); 
			//LLC.setValue(LLC.OUT.PWM_FAN_RECIR_F, 1f);
			
			// Relay (and thus pumps and fans) are always on
			// Below lines are commented out because sensors are reporting junk values too frequently
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1f);
			LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_A, 1f);
			LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_B, 1f);
		}
		/*
		boolean riserFound = false;
		boolean allTempsLow = true;
		
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
		
		if(riserFound && LLC.getValue(LLC.IN.RELAY_RAIL_12V) < 0.5f) {
			Main.log("Watercooling threshold temperature exceeded.");
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1f);
		}else if(allTempsLow && LLC.getValue(LLC.IN.RELAY_RAIL_12V) > 0.5f) {
			Main.log("Dropped below watercooling threshold temperature condition.");
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0f);
		}
		
		// Store last temperatures
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			lastTemperatures[i] = Temperature.temperatures[i];
		}
		*/
	}
}
