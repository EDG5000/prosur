package io.infinus.hc3d;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
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
	
	final static int CALIB_SAMPLE_COUNT = 60 * 20; // 10 minutes of sampling time
	//final static int CALIB_SAMPLE_COUNT = 30;
			
	static List<Sample> samples;
	
	private static BufferedWriter calibDiagnosticFileWriter;
	
	public static class Sample{
		int time; // Time since 00:00 today. Float is used to maintain uniformity
		float[] thermistorVoltages;
		//float[] thermistorTemperatures;
		float refTemp0; // Main ref
		float refTemp1; // Used for consistency check
		public Sample() {}
		public Sample(String line) {
			String[] components = line.split(",");
			float[] values = new float[components.length];
			for(int i = 0; i < components.length; i++) {
				values[i] = Float.parseFloat(components[i]);
			}
			populateFromFloatArray(values);
		}
		
		public Sample(float[] values) {
			populateFromFloatArray(values);
		}
		
		private void populateFromFloatArray(float[] values) {
			time = (int) values[0];
			refTemp0 = values[1];
			refTemp1 = values[2];
			thermistorVoltages = new float[SENSOR_COUNT];
			for(int i = 0; i < SENSOR_COUNT; i++) {
				thermistorVoltages[i] = values[i+3];
			}
			/*
			if(values.length > SENSOR_COUNT+3) {
				thermistorTemperatures = new float[SENSOR_COUNT];
				// Additional sanity-check data is available, store this as well
				for(int i = 0; i < SENSOR_COUNT; i++) {
					thermistorTemperatures[i] = values[i+SENSOR_COUNT+3]; 
				}
			}
			*/
		}
		public String toString() {
			String line = time + ",";
			line += refTemp0 + ",";
			line += refTemp1;

			// Add thermistor voltages to string
			for(int i = 0; i < thermistorVoltages.length; i++) {
				line += "," + thermistorVoltages[i];
			}
			
			/*
			// Add calulated temperatures using exising calibration data for verification of calculations applying calibration data
			if(ThermistorCalibrationData.calibrationData != null) {
				for(int sensorIndex = 0; sensorIndex < thermistorVoltages.length; sensorIndex++) {
					line += "," + temperatureFromThermistorVoltage(sensorIndex, thermistorVoltages[sensorIndex]);
				}
			}
			*/
			return line;
		}
	}
	
	// Find matching two points from calibration data and linearly interpolate between those points to calculate the temperature based on input voltage
	// TODO make private
	public static float temperatureFromThermistorVoltage(int sensorIndex, float voltage) {
		Sample pointA = null;
		Sample pointB = null;
		
		// Get the two points the voltage is in between
		for(Sample point : ThermistorCalibrationData.calibrationData){
			float pointVoltage = point.thermistorVoltages[sensorIndex];
			if(voltage > pointVoltage){
				pointA = point;
			}
			if(voltage < pointVoltage){
				pointB = point;
				break; 
			}
		}
		
		// Hacky testy "fixy"
		if(pointA == null || pointB == null) return 0;
		
		float pointAVoltage = pointA.thermistorVoltages[sensorIndex];
		float pointBVoltage = pointB.thermistorVoltages[sensorIndex];
		
		
		
		// Interpolate linearly between the two points
		double voltageSpan = pointBVoltage - pointAVoltage; // Voltage span between A & B
		// Abolute position of voltage between A & B in volts
		double positionVoltage = voltage - pointAVoltage;
		// Relative position of voltage between A & B (0-1)
		double positionRelative =  positionVoltage / voltageSpan;
		// Percent span
		double temperatureSpan = pointB.refTemp0 - pointA.refTemp0;
		// Apply relative position to percent span
		double positionTemperature = positionRelative * temperatureSpan;
		// Add position percentage to base percentage of point A
		double temperature = pointA.refTemp0 + positionTemperature;
		
		System.out.println("Interpolating for "+voltage+" between " +pointAVoltage + " and " + pointBVoltage + ". Result: " + temperature);
		
		return Math.round(temperature * 10) / 10;
	}
	
	public static float getTemperature(int sensorIndex) {
		float voltage = LLC.getValue(SENSOR_FIELD_IDS[sensorIndex]);
		return temperatureFromThermistorVoltage(sensorIndex, voltage);
	}
	
	public static void startCalib() {
		System.out.println("Starting thermistor calibration.");
		samples = new ArrayList<Sample>();
		
		try {
			String path = Main.applicationFolder + "/" + "calib-diag-all.csv";
			// When file containing calibration data exists, run the data bake process instead, with the existing data
			if(new File(path).exists()) {
				// Parse file into List<Sample>
				String rawFileData = new String(Files.readAllBytes(Paths.get(path)), StandardCharsets.UTF_8);
				String[] lines = rawFileData.split("\n");
				for(String line : lines) {
					samples.add(new Sample(line));
				}
				
				// Process raw calibration data 
				// Keep only one sample per 1 deg C temperature change
				List<Sample> keptSamples = new ArrayList<Sample>();
				// Sort samples by refTemp. Assumed is at least one cycle of 0-100 deg C is experienced during calibration
				// Without sorting the later check would ignore any samples after a temperature peak has been reached (when desencing)
				// TODO improvement:
				// The algorythm should perhaps consider any peaks a session separator and in post processing of the data, the sessions can be merged by averaging the tref assigned to each degree
				// Keep the original raw calibration data so the algo can be optimized later on with the old data!
				samples.sort(new Comparator<Sample>() {
					@Override
					public int compare(Sample sample1, Sample sample2) {
						return Math.round(sample1.refTemp0) - Math.round(sample2.refTemp0);
					}
				});
				float lastTemp = 0;
				// Filter samples, only keep one sample per rounded temperature of refTemp0
				for(Sample sample: samples) {
					// Discard samples with -1 ref temp; most likely LLC was still waiting for data while calib was already running
					if(sample.refTemp0 == -1) continue;
					
					// Check if both reference temperature sensor are within .4 deg C of each other, otherwise abort process
					if(Math.abs(sample.refTemp0  - sample.refTemp1) > 2) {
						throw new RuntimeException("Error: Temp references inconsistent. T0-T1 = " + (sample.refTemp0 - sample.refTemp1) + " Time: " + sample.time);
					}
					
					if(Math.abs(sample.refTemp0 - lastTemp) >= 1) {
						// Difference with last extracted sample is now 1 or more, keep this sample
						keptSamples.add(sample);
						lastTemp = sample.refTemp0;
					}
				}
				System.out.println("Generated calibration data: ");
				// Write generated Java array initiliazer code to console
				// If calibration data already exists, this also adds calculated temperatures based on existing calibration data at the end of each row
				for(Sample sample : keptSamples) {
					// Add f notation for java float initialisation as well as accolades
					System.out.println("{" + sample.toString().replace(",", "f,") + "f},");
				}
				System.out.println("Calibration baking complete. Exiting.");
				System.exit(0);
			}else {
				// Start calibrating
				calibDiagnosticFileWriter =  new BufferedWriter(new FileWriter(path));
				samplesCollected = 0;
				calibrating = true; // Checked at LLC tick 
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/*
	 * Only used when calibrating
	 */
	public static void onLLCTickComplete() {
		if(!calibrating) return;
		if(samplesCollected == CALIB_SAMPLE_COUNT) {
			//calibrating = false;
			//samplesCollected = -1;
			System.out.println("Calibration complete. Re-run to bake calibration data.");
			System.exit(0);
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
			sample.time = (int)(System.currentTimeMillis() % (1000 * 60 * 60)); // Substract full days to obtain timestamp for today only
			samples.add(sample);
			System.out.println("Collected calibration sample " + samplesCollected + "/" + CALIB_SAMPLE_COUNT + ": " + sample.toString());
			try {
				calibDiagnosticFileWriter.write(sample.toString() + "\n");
				calibDiagnosticFileWriter.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			samplesCollected++;
		}
	}
}
