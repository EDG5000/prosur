package io.infinus.hc3d.modules;

import io.infinus.hc3d.C;
import io.infinus.hc3d.LLC;
import io.infinus.hc3d.Main;

/*
 * When temperatures exceed a given maximum, turn off 3DP interlock and 12V rail relays
 * to effectively stop the printer as well as the pump from doing any more damage.
 */

public class Failsafe {
	static boolean failsafeActive = false;
	public static void onLLCTickComplete() {
		if(failsafeActive) {
			return;
		}
		boolean limitExceeded = false;
		if(!failsafeActive) {
			for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
				int fieldIndex = C.LLC_TEMP_SENSOR_OFFSET + i;
				float temp = LLC.getValue(fieldIndex);
				if(i == C.TEMP_SENSOR_MOT_E || i == C.TEMP_SENSOR_MOT_X || i == C.TEMP_SENSOR_MOT_Y || i == C.TEMP_SENSOR_MOT_Z) {
					if(temp > C.FAILSAFE_TEMP_MOT) {
						Main.log("Failsafe: Motor temperature limit of "+C.FAILSAFE_TEMP_MOT+" for sensor " + fieldIndex + " exceeded. Temp was: " + temp);
						limitExceeded = true;
					}
				}else if(i == C.TEMP_SENSOR_CHBR || i == C.TEMP_SENSOR_CHTR) {
					if(temp > C.FAILSAFE_TEMP_CHAMBER) {
						Main.log("Failsafe: Chamber temperature limit of "+C.FAILSAFE_TEMP_CHAMBER+" for sensor " + fieldIndex + " exceeded. Temp was: " + temp);
						limitExceeded = true;
					}
				}
			}			
		}
		if(limitExceeded) {
			Main.log("Activating failsafe.");
			// Setting both interlocks high cuts of power to 3d printer
			LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_A, 1);
			LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_B, 1);
			
			// Turning off the 12V rail will disable pumps and fans
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0);
		}
	}
}
