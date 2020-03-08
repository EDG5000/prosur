package io.infinus.hc3d;

import io.infinus.hc3d.modules.Failsafe;

public class Control {
	static float[] lastTemperatures = new float[C.LLC_TEMP_SENSOR_COUNT];
	
	public static final float TEMP_DEADBAND_UPPER = C.TEMP_PUMP_THRESHOLD + (C.TEMP_PUMP_THRESHOLD/2f);
	public static final float TEMP_DEADBAND_LOWER = C.TEMP_PUMP_THRESHOLD - (C.TEMP_PUMP_THRESHOLD/2f);
	
	static {
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			lastTemperatures[i] = -1;
		}
	}
	
	final static int ACTION_NOTHING = 0;
	final static int ACTION_DISABLE = 1;
	final static int ACTION_ENABLE = 2;
	
	static boolean initial = true;
	
	static int lastAction = -1;
	
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
		}
		
		int action = ACTION_NOTHING;
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			if(Temperature.temperatures[i] > lastTemperatures[i] && Temperature.temperatures[i] > TEMP_DEADBAND_UPPER){
				// Temp just increased to above the upper deadband limit
				action = ACTION_ENABLE;
				break;
			}else if(Temperature.temperatures[i] < lastTemperatures[i] && Temperature.temperatures[i] < TEMP_DEADBAND_LOWER) {
				// Temp just dropped to below the lower deadband limit
				// Set desired action to DISABLE, unless it was requested to be enabled for another sensor
				if(action != ACTION_ENABLE) {
					action = ACTION_DISABLE;
				}
			}
		}
		
		if(action != lastAction) {
			if(action == ACTION_DISABLE) {
				Main.log("Watercooling threshold temperature exceeded.");
				LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0f);
			}else if(action == ACTION_ENABLE) {
				Main.log("Dropped below watercooling threshold temperature condition.");
				LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 1f);
			}
		}

		lastAction = action;

		// Store last temperatures
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			lastTemperatures[i] = Temperature.temperatures[i];
		}
	}
}
