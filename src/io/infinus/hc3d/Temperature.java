package io.infinus.hc3d;

/*
 * < -100 = error condition
 * 		-127: LLC was unable to retrieve value
 * 		-126: Temp sensor behaviour rejected by HLC
 */

public class Temperature {
	public static float[] temperatures = new float[C.LLC_TEMP_SENSOR_COUNT];
	static {
		for(int i = 0; i < temperatures.length; i++) {
			temperatures[i] = -1;
		}
	}
	
	public static void onLLCTickComplete() {
		// Update the last accepted temperature value, if new value is accepted
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			int fieldIndex = C.LLC_TEMP_SENSOR_OFFSET + i;
			float temp = LLC.getValue(fieldIndex);
			/*
			if(temp == -1) {
				// LLC still settling, abort operation, wait for next tick.
				break;
			}
			// When temperatures are positive (-1 means LLC settling, -127 means sensor disconnect),
			// 
			// Reject if
			// - a stored value is available AND
			// - new value is settled AND
			// - absolte offset above 5 centigrate
			if(temperatures[i] != -1 && temp != -1 && Math.abs(temp - temperatures[i]) > 5){
				// Temp sensor behaviour rejected
				temp = -126;
			}
			*/
			if(temp != 85f) {
				// When exactly 85 is measured, do not update the value
				temperatures[i] = temp;
			}
			
		}
	}

}
