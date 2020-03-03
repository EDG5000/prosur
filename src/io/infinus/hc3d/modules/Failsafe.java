package io.infinus.hc3d.modules;

import io.infinus.hc3d.C;
import io.infinus.hc3d.LLC;
import io.infinus.hc3d.Main;
import io.infinus.hc3d.Temperature;

/*
 * When temperatures exceed a given maximum, turn off 3DP interlock and 12V rail relays
 * to effectively stop the printer as well as the pump from doing any more damage.
 */

public class Failsafe {
	public static boolean failsafeActive = false; // Also read by Control
	static boolean awaitingFirstData = true; // To ensure the first sample gets accepted even if is seems like it has a high offset compared to the previous value
	
	public static void onLLCTickComplete() {
		if(failsafeActive) {
			return;
		}
		boolean limitExceeded = false;

		// Check if any of the accepted temperatures have exceeded the temperature limit
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			float temp = Temperature.temperatures[i];
			if(i == C.TEMP_SENSOR_MOT_E || i == C.TEMP_SENSOR_MOT_X || i == C.TEMP_SENSOR_MOT_Y || i == C.TEMP_SENSOR_MOT_Z) {
				if(temp > C.FAILSAFE_TEMP_MOT) {
					Main.log("Failsafe: Motor temperature limit of "+C.FAILSAFE_TEMP_MOT+" for sensor " + i + " exceeded. Temp was: " + temp);
					limitExceeded = true; // Do not break from loop, check for other errors as well just in case
				}
			}else if(i == C.TEMP_SENSOR_CHBR || i == C.TEMP_SENSOR_CHTR) {
				if(temp > C.FAILSAFE_TEMP_CHAMBER) {
					Main.log("Failsafe: Chamber temperature limit of "+C.FAILSAFE_TEMP_CHAMBER+" for sensor " + i + " exceeded. Temp was: " + temp);
					limitExceeded = true;
				}
			}
		}			
		if(limitExceeded) {
			failsafeActive = true;
			Main.log("Activating failsafe.");
			// Setting both interlocks high cuts of power to 3d printer
			LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_A, 1);
			LLC.setValue(LLC.OUT.RELAY_3DP_INTERLOCK_B, 1);
			
			// Turning off the 12V rail will disable pumps and fans
			LLC.setValue(LLC.OUT.RELAY_RAIL_12V, 0);
		}
	}
}
