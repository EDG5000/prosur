package io.infinus.hc3d;

import java.io.File;
import java.util.List;

/*
 * Allows reading of temperature by index
 * Applies scaling based on calibration
 * Performs calibration procedure
 * Manages calibration data
 */

public class Temperatures {
	public static int SENSOR_COUNT;
	public static final int[] SENSOR_FIELD_IDS = new int[] {
			LLC.IN.TEMP_A1,
			LLC.IN.TEMP_A2,
			LLC.IN.TEMP_A3,
			LLC.IN.TEMP_A4,
			LLC.IN.TEMP_A5,
			LLC.IN.TEMP_A6,
			LLC.IN.TEMP_B1,
			LLC.IN.TEMP_B2,
			LLC.IN.TEMP_B3,
			LLC.IN.TEMP_B4,
			LLC.IN.TEMP_B5,
			LLC.IN.TEMP_B6
	};
	
	static {
		SENSOR_COUNT = SENSOR_FIELD_IDS.length;
	}
	
	static boolean calibrating = false;
	static int samplesCollected = -1;
	
	final static int CALIB_SAMPLE_COUNT = 60 * 10; // 10 minutes of sampling time
	
	static List<Sample> samples;
	
	private static File calibDiagnosticFile;
	
	private static class Sample{
		long time;
		float[] thermistorVoltages;
		float refTemp0;
		float refTemp1;
	}
	
	public static void init() {
		// TODO load calib data from disk
	}
	
	public static float getTemperature(int sensorIndex) {
		float voltage = LLC.getValue(SENSOR_FIELD_IDS[sensorIndex]);
		// TODO convert to deg C
		return voltage;
	}
	
	public static void startCalib() {
		// Collect samples for X seconds
		samplesCollected = 0;
		calibrating = true;
		calibDiagnosticFile = new File(Util.getApplicationFolder() + "/" + "calib-diag.csv");
	}
	
	public static void onLLCTickComplete() {
		if(!calibrating) return;
		if(samplesCollected == CALIB_SAMPLE_COUNT) {
			calibrating = false;
			samplesCollected = -1;
				
			Sample sample = new Sample();
			sample.thermistorVoltages = new float[SENSOR_FIELD_IDS.length];
			// Copy thermistor voltages from LLC incoming buffer
			for(int i = 0; i < SENSOR_FIELD_IDS.length; i++) {
				sample.thermistorVoltages[i] = LLC.getValue(SENSOR_FIELD_IDS[i]);
			}
			// Copy reference temperatures from LLC incoming buffer
			sample.refTemp0 = LLC.getValue(LLC.IN.TEMP_TREF0);
			sample.refTemp1 = LLC.getValue(LLC.IN.TEMP_TREF1);
			sample.time = System.currentTimeMillis();
		}
	}
}
