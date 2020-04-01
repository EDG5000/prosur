package io.infinus.hc3d.modules;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import io.infinus.hc3d.C;
import io.infinus.hc3d.LLC;
import io.infinus.hc3d.Main;
import io.infinus.hc3d.Main.Config;
import io.infinus.hc3d.Util;

/*
 * Log to CSV file named after the the time the session was started
 * A session is started when the HC3D application is started
 * Every line in the log file has a 
 */

public class DataFileLogging {
	static File file;
	static FileOutputStream outputStream;
	static String line;
	
	public static void onLLCTickComplete() {
		if(Config.sitlMode) return;
		if(LLC.getValue(LLC.OUT.RELAY_RAIL_12V) != 1f) {
			// When 12V relay is off, Control.java has turned of the pump because all temps are low. Only log when there are high temps.
			if(file != null) {
				file = null;
			}
			return;
		}
		
		if(file == null) {
			String dataLogFolder = Main.Config.dataLogFolder + "/datalog";
			File folder = new File(dataLogFolder);
			if(!folder.exists()) {
				Main.log("Creating datalog folder...");
				folder.mkdirs();
			}
			String dataLogFilePath = dataLogFolder + "/" + Util.getDateString() + ".csv";
			file = new File(dataLogFilePath);
			// I thought this was not needed, but I am getting exceptions
			try {
				file.createNewFile();
				Main.log("DataFileLog: Created file " + dataLogFilePath);
			} catch (IOException e1) {
				Main.log("Failed to create file at " + dataLogFilePath);
				Main.printStackTrace(e1);
				System.exit(1);
			}
			try {
				outputStream = new FileOutputStream(file);
			} catch (FileNotFoundException e) {
				Main.printStackTrace(e);
				System.exit(1);
			}
		}
		
		line = Util.getDateString() + "\t";
		for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
			float val = LLC.getValue(C.LLC_TEMP_SENSOR_OFFSET + i);
			//val = Math.round(val/100) * 100; // Round to 2 digits
			line += String.format("%05.2f", val);
			if(i != C.LLC_TEMP_SENSOR_COUNT-1) {
				line += "\t";
			}
		}
		line += "\n";
		try {
			outputStream.write(line.getBytes());
		} catch (IOException e) {
			Main.log("Unable to write to datalog file at " + file.getAbsolutePath());
			Main.printStackTrace(e);
			System.exit(1);
		}
	}
	
	public static void close() {
		try {
			if(outputStream != null) {
				outputStream.close();
			}
		} catch (IOException e) {
			e.printStackTrace();
			Main.printStackTrace(e);
		}
	}
}
