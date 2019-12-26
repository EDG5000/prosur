package io.infinus.hc3d;

public class ThermistorCalibrationData {
	// Will contain calculated temperatures at the end of each row for verification in some cases
	// The values should match refTemp0
	// Layout: refTemp0, refTemp1, voltage0...[, temp0...]
	// Will be null in all cases after static iniailization
	// Only calibrationData will be populated, if rawCalibrationData was populated in code
	private static float[][] rawCalibrationData = null;
	
	// Accessed by Temperatures at runtime
	public static DataPoint[] calibrationData;
	public static class DataPoint{
		public float time; // Time today in millis
		public float refTemp0;
		public float refTemp1;
		public float[] thermistorVoltages;
		public float[] thermistorTemperatures; // Can be null in some cases
	}
	static {
		// Place raw data into data structure to facilitate access of the data
		for(float[] values: rawCalibrationData) {
			DataPoint dataPoint = new DataPoint();
			dataPoint.time = values[0];
			dataPoint.refTemp0 = values[1];
			dataPoint.refTemp1 = values[2];
			dataPoint.thermistorVoltages = new float[Temperatures.SENSOR_COUNT];
			dataPoint.thermistorTemperatures = new float[Temperatures.SENSOR_COUNT];
			for(int sensorIndex = 0; sensorIndex < Temperatures.SENSOR_COUNT; sensorIndex++) {
				dataPoint.thermistorVoltages[sensorIndex] = values[sensorIndex + 2];
				dataPoint.thermistorTemperatures[sensorIndex] = values[sensorIndex + 2 + Temperatures.SENSOR_COUNT];
			}
		}
	}
	
}
