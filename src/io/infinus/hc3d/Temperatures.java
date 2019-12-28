package io.infinus.hc3d;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
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
			LLC.IN.TEMP_A0,
			LLC.IN.TEMP_A1,
			LLC.IN.TEMP_A2,
			LLC.IN.TEMP_A3,
			LLC.IN.TEMP_A4,
			LLC.IN.TEMP_A5,
			LLC.IN.TEMP_B0,
			LLC.IN.TEMP_B1,
			LLC.IN.TEMP_B2,
			LLC.IN.TEMP_B3,
			LLC.IN.TEMP_B4,
			LLC.IN.TEMP_B5
	};
	
	static {
		SENSOR_COUNT = SENSOR_FIELD_IDS.length;
	}
	
	static boolean calibrating = false;
	static int samplesCollected = -1;
	
	final static int CALIB_SAMPLE_COUNT = 60 * 10; // 10 minutes of sampling time
	
	static List<Sample> samples;
	
	private static BufferedWriter calibDiagnosticFileWriter;
	
	private static class Sample{
		float time; // Time since 00:00 today. Float is used to maintain uniformity
		float[] thermistorVoltages;
		float refTemp0; // Main ref
		float refTemp1; // Used for consistency check
		public String toString() {
			String line = time + ",";
			line += refTemp0 + ",";
			line += refTemp1 + ",";

			// Add thermistor voltages to string
			for(int i = 0; i < thermistorVoltages.length; i++) {
				line += thermistorVoltages[i] + ",";
			}
			
			// Add calulated temperatures using exising calibration data for verification of calculations applying calibration data
			if(ThermistorCalibrationData.calibrationData != null) {
				for(int sensorIndex = 0; sensorIndex < thermistorVoltages.length; sensorIndex++) {
					line += temperatureFromThermistorVoltage(sensorIndex, thermistorVoltages[sensorIndex]);
					if(sensorIndex != thermistorVoltages.length-1) {
						line += ",";
					}
				}
			}
			return line;
		}
	}
	
	// Find matching two points from calibration data and linearly interpolate between those points to calculate the temperature based on input voltage
	private static float temperatureFromThermistorVoltage(int sensorIndex, float voltage) {
		/*
		voltage /= 4;
		if(voltage >= 4.20){
			return 100;
		}
		if(voltage <= 3.60){
			return 0;
		}
		*/
		
		ThermistorCalibrationData.DataPoint pointA = null;
		ThermistorCalibrationData.DataPoint pointB = null;
		
		// Get the two points the voltage is in between
		for(ThermistorCalibrationData.DataPoint point : ThermistorCalibrationData.calibrationData){
			float pointVoltage = point.thermistorVoltages[sensorIndex];
			if(voltage > pointVoltage){
				pointA = point;
			}
			if(voltage < pointVoltage){
				pointB = point;
				break; 
			}
		}
		
		float pointAVoltage = pointA.thermistorVoltages[sensorIndex];
		float pointBVoltage = pointB.thermistorVoltages[sensorIndex];
		
		// Interpolate linearly between the two points
		double voltageSpan = pointBVoltage - pointAVoltage; // Voltage span between A & B
		// Abolute position of voltage between A & B in volts
		double positionVoltage = voltage - pointAVoltage;
		// Relative position of voltage between A & B (0-1)
		double positionRelative =  positionVoltage / voltageSpan;
		// Percent span
		double percentSpan = pointB.refTemp0 - pointA.refTemp0;
		// Apply relative position to percent span
		double positionPercentage = positionRelative * percentSpan;
		// Add position percentage to base percentage of point A
		double percentage = pointA.refTemp0 + positionPercentage;
		
		return Math.round(percentage * 10) / 10;
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
		try {
			String path = Util.getApplicationFolder() + "/" + "calib-diag-all.csv";
			if(new File(path).exists()) {
				throw new RuntimeException("Error: Unable to perform calibration: Diagnostic output file for all samples already exists.");
			}
			calibDiagnosticFileWriter =  new BufferedWriter(new FileWriter(path));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void onLLCTickComplete() {
		if(!calibrating) return;
		if(samplesCollected == CALIB_SAMPLE_COUNT) {
			calibrating = false;
			samplesCollected = -1;
				
			// All samples collected
			// Keep only one sample per 1 deg C temperature change
			List<Sample> keptSamples = new ArrayList<Sample>();
			float lastTemp = 0;
			for(Sample sample: samples) {
				// Check if both reference temperature sensor are within .4 deg C of each other, otherwise abort process
				if(Math.abs(sample.refTemp0  - sample.refTemp1) > .4) {
					throw new RuntimeException("Error: Temp references inconsistent. T0-T1 = " + (sample.refTemp0 - sample.refTemp1) + " Time: " + sample.time);
				}
				
				if(Math.abs(sample.refTemp0 - lastTemp) >= 1) {
					// Difference with last extracted sample is now 1 or more, keep this sample
					keptSamples.add(sample);
					lastTemp = sample.refTemp0;
				}
			}
			
			// Write generated Java array initiliazer code to console
			// If calibration data already exists, this also adds calculated temperatures based on existing calibration data at the end of each row
			for(Sample sample : keptSamples) {
				System.out.println("{" + sample.toString() + "},\n");
			}
		}else {
			Sample sample = new Sample();
			sample.thermistorVoltages = new float[SENSOR_FIELD_IDS.length];
			// Copy thermistor voltages from LLC incoming buffer
			for(int i = 0; i < SENSOR_FIELD_IDS.length; i++) {
				sample.thermistorVoltages[i] = LLC.getValue(SENSOR_FIELD_IDS[i]);
			}
			// Copy reference temperatures from LLC incoming buffer
			sample.refTemp0 = LLC.getValue(LLC.IN.TEMP_TREF0);
			sample.refTemp1 = LLC.getValue(LLC.IN.TEMP_TREF1);
			sample.time = System.currentTimeMillis() % (1000 * 60 * 60); // Substract full days to obtain timestamp for today only
			samples.add(sample);
			try {
				calibDiagnosticFileWriter.write(sample.toString() + "\n");
				calibDiagnosticFileWriter.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
