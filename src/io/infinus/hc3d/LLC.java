package io.infinus.hc3d;

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Logger;

import io.infinus.hc3d.modules.DataLog;
import io.infinus.hc3d.modules.Failsafe;


/*
 * V1:
 * 	- Continuously update data structure with received rounded floats (indexed by constants)
 *  - data stored in two-dimensional array
 *  - helper method for retrieving fields using single idenfitier
 * V2:
 *  - not just temperatures, but also tachometer values are received
 *  - the send buffer is sent every frame. -1 is sent when no data is sent
 *  
 *  
 * // TODO add tachometer data from pumps and fans
 */

public class LLC {

	/*
	 * LLC configuration
	 */
	
	
	public static final int ADAPTER_COUNT = 4;
	
	// LLC adapter identifiers
	static final int ADAPTER_TEMP_A = 0;
	static final int ADAPTER_RECIR = 1;
	static final int ADAPTER_PUMP = 2;
	static final int ADAPTER_RELAY = 3;
	
	// Field IDs. Need to be in accordance with field layout so that they can be found when calling helper methods
	// Only used for convenience access
	public static class IN{
		// TEMPA
		public static final int TEMP_A1 = 0;
		public static final int TEMP_A2 = 1;
		public static final int TEMP_A3 = 2;
		public static final int TEMP_A4 = 3;
		public static final int TEMP_A5 = 4;
		public static final int TEMP_A6 = 5;
		public static final int TEMP_A7 = 6;
		public static final int TEMP_A8 = 7;
		
		// RECIR
		public static final int PWM_FAN_RECIR_F = 8;
		public static final int PWM_FAN_RECIR_B = 9;
		public static final int TACH_FAN_RECIR_F = 10;
		public static final int TACH_FAN_RECIR_B = 11;
		
		// PUMP
		public static final int PWM_PUMP = 12;
		public static final int TACH_PUMP = 13;
		/*public static final int PWM_FAN_HE_OUT = 6;   TODO uncomment
		public static final int TACH_FAN_HE_OUT = 7;*/
		
		// RELAY
		public static final int RELAY_3DP_INTERLOCK_A = 14;
		public static final int RELAY_3DP_INTERLOCK_B = 15;
		public static final int RELAY_RAIL_12V = 16; // Fans and pumps for 3DP cooling and chamber temperature regulation
	}
	
	public static class OUT{
		// RECIR
		public static final int PWM_FAN_RECIR_F = 0;
		public static final int PWM_FAN_RECIR_B = 1;
		
		// PUMP
		public static final int PWM_PUMP = 2;
		
		// RELAY
		public static final int RELAY_3DP_INTERLOCK_A = 3;
		public static final int RELAY_3DP_INTERLOCK_B = 4;
		public static final int RELAY_RAIL_12V = 5; // Fans and pumps for 3DP cooling and chamber temperature regulation
	}
	// Indexed by adapter, values represent field count per adapter
	public static final int[] IN_FIELD_LAYOUT = new int[]{
			8, // TEMP_A
			4, // RECIR
			2, // FAN HE
			3 // RELAY
	};
	
	public static final int[] OUT_FIELD_LAYOUT = new int[]{
			0, // TEMP_A
			2, // RECIR
			1, // FAN HE
			3 // RELAY
	};
	
	/*
	 * End LLC configuration
	 */
	
	private static SerialConnection[] serialConnections = new SerialConnection[ADAPTER_COUNT];
	
	// Updated every frame
	public static float[][] inData = new float[ADAPTER_COUNT][];
	// Stored partially received lines
	static String[] serialReceiveBuffer = new String[ADAPTER_COUNT];
	
	// Sent every frame
	static float[][] outData = new float[ADAPTER_COUNT][];
	
	// First time an error is encountered, it is tolerated (could be because application started in the middle of frame transmission)
	// Otherwise, generate error application
	static boolean[] incomingFrameWasDropped = new boolean[ADAPTER_COUNT];
	
	// Index by field id, containing pair of adapter id and field index
	private static int[][] inFieldLookup;
	private static int[][] outFieldLookup;
	
	private static boolean isSettled = false;
	public static boolean getIsSettled() {
		return isSettled;
	}
	
	static {
		// Initialize all structures with -1 or empty strings
		for(int adapter = 0; adapter < ADAPTER_COUNT; adapter++) {
			serialReceiveBuffer[adapter] = "";
			inData[adapter] = new float[IN_FIELD_LAYOUT[adapter]];
			outData[adapter] = new float[OUT_FIELD_LAYOUT[adapter]];
			incomingFrameWasDropped[adapter] = false;
			for(int fieldIndex = 0; fieldIndex < IN_FIELD_LAYOUT[adapter]; fieldIndex++) {
				inData[adapter][fieldIndex] = -1;
			}
			
			for(int fieldIndex = 0; fieldIndex < OUT_FIELD_LAYOUT[adapter]; fieldIndex++) {
				outData[adapter][fieldIndex] = -1;
			}
		}
		
		inFieldLookup = generateLookupTable(IN_FIELD_LAYOUT);
		outFieldLookup = generateLookupTable(OUT_FIELD_LAYOUT);
	}
	
	// Use field layout to fill the supplied lookup table
	static int[][] generateLookupTable(int[] layout) {
		// Build lookup table for finding fields by Id in field layout
		int fieldCount = 0;
		for(int i = 0; i < layout.length; i++) {
			fieldCount += layout[i];
		}
		int[][] lookupTable = new int[fieldCount][];
		int fieldId = 0;
		for(int adapter = 0; adapter < layout.length; adapter++) {
			for(int fieldIndex = 0; fieldIndex < layout[adapter]; fieldIndex++) {
				lookupTable[fieldId] = new int[] {adapter, fieldIndex};
				fieldId++;
			}
		}
		return lookupTable;
	}

	static int sitlTick = 0;
	static int sitlTickDirection = 1;
	static int sitlTickTotal = 0;
	
	public static void init() {
		Main.log("Init LLC");
		// Initialize serial connections
		if(!Main.Config.sitlMode) {
			try {
				for(int adapter = 0; adapter < ADAPTER_COUNT; adapter++) {
					serialConnections[adapter] = new SerialConnection(Main.Config.serialPortIds[adapter]);
					serialConnections[adapter].openConnection();
				}
			} catch (IOException e1) {
				e1.printStackTrace();
				System.exit(1);
			}
		}
		
		int tickInterval;
		if(Main.Config.sitlMode) {
			tickInterval = 1;
		}else {
			tickInterval = C.LLC_TICK_INTERVAL;
		}
		
		// LLC tick (.1hz)
		new Timer().schedule(new TimerTask() {
			@Override
			public void run() {
				if(Main.stopping) return;
				
				if(Main.Config.sitlMode) {
					sitlTickTotal += 1;
					if(sitlTickTotal == 1000) {
						Main.log("SITL completed 1000 cycles, stopping.");
						System.exit(0);
					}
					// Perform simulated tick
					// Increase sitl tick counter
					sitlTick += sitlTickDirection;
					if(sitlTick == 45) {
						sitlTickDirection = -1;
					}else if(sitlTick == -1) {
						sitlTickDirection = 1;
					}
					// Update fake temperature values
					for(int i = 0; i < C.LLC_TEMP_SENSOR_COUNT; i++) {
						int fieldId = C.LLC_TEMP_SENSOR_OFFSET + i;
						inData
							[inFieldLookup[fieldId][0]]
							[inFieldLookup[fieldId][1]] = sitlTick;
					}
					Main.log("SITL: Setting temps to " + sitlTick);
				}else {
					// Perform real tick
					for(int i = 0; i < ADAPTER_COUNT; i++) {
						serialTick(i);
					}	
				}

				emitOnTickComplete();
				
				// Check if data for all fields is now received
				if(!isSettled) {
					boolean foundEmptyField = false;
					for(int adapter = 0; adapter < ADAPTER_COUNT; adapter++) {
						for(int fieldIndex = 0; fieldIndex < inData[adapter].length; fieldIndex++) {
							if(inData[adapter][fieldIndex] == -1) {
								foundEmptyField = true;
								break;
							}
						}
						if(foundEmptyField) {
							break;
						}
					}
					if(!foundEmptyField) {
						isSettled = true;
					}
				}
			}
		}, 0, tickInterval);
		Main.log("LLC ready.");
	}
	
	private static void emitOnTickComplete() {
		if(Main.Config.dataLogEnabled) {
			DataLog.onLLCTickComplete();
		}
		Control.onLLCTickComplete();
		/*
		Failsafe.onLLCTickComplete();
		Temperature.onLLCTickComplete();
		
		*/
	}
	
	// Get value from incoming data by field ID
	public static float getValue(int fieldId) {
		return inData
			[inFieldLookup[fieldId][0]]
			[inFieldLookup[fieldId][1]]
		;
	}
	
	// Store value in outgoing data structure by field ID and value
	public static void setValue(int fieldId, float value) {
		Main.log("Setting value for field " + fieldId + " to " + value);
		int adapter = outFieldLookup[fieldId][0];
		 outData
			[adapter]
			[outFieldLookup[fieldId][1]]
		 = value;
		 writeOutgoingData(adapter);
	}
	
	/*
	 * Read into receive buffer
	 * If a line is completed, update the fields accordingly
	 * Write the full outgoing data array
	 */
	private static void serialTick(int adapter) {
		try {
			/*
			 * Process incoming data
			 */
			// Read into buffer
			byte[] dataRead = serialConnections[adapter].readDataBlock();
			if(dataRead != null && dataRead.length > 0) {
				serialReceiveBuffer[adapter] += new String(dataRead);
			}
			
			int lastIndexOfNewline = serialReceiveBuffer[adapter].lastIndexOf("\n");
			if(lastIndexOfNewline != -1) {
				// A newline was found in the buffer, this means we have enough data to process it
				// Extract data we want to process
				String dataToParse = serialReceiveBuffer[adapter].substring(0, lastIndexOfNewline);
				// Overwrite buffer with the part that will not be processed in this tick
				serialReceiveBuffer[adapter] = serialReceiveBuffer[adapter].substring(lastIndexOfNewline+1); // Add +1 to skip the newline which will always be at the beginning?
				// Further filter the data we want to parse by only keeping the last line
				// In some cases this will not make a difference (when no newline is present)
				String[] lines = dataToParse.split("\n");
				
				// Reduce it to 1 line
				dataToParse = lines[lines.length-1];
				if(C.LLC_RAW_LOGGING) {
					Main.log("IN " + adapter + ": "+ dataToParse);
				}
				
				String[] components = dataToParse.split(",");
				
				// Check component count. Should be fieldCount + 1 (identifier is added at beginning)
				if(components.length != IN_FIELD_LAYOUT[adapter] + 1) {
					// Dropping line. Can happen when application starts in the middle of frame transmission from LLC
					// Should happen no more than max 1 times per sesssion
					if(incomingFrameWasDropped[adapter]) {
						Main.onError("Dropped more than one frame for adapter " + adapter + " Frame: " + dataToParse + " Expected component count:  " + (IN_FIELD_LAYOUT[adapter] + 1) + " Actual component count: " + components.length);
					}else {
						incomingFrameWasDropped[adapter] = true;
					}
				}else {
					// Parse components and store into main data structure
					for(int fieldIndex = 0; fieldIndex < IN_FIELD_LAYOUT[adapter]; fieldIndex++) {
						// Shift component index by one to account for the device identifier which takes up the first position
						float fieldValue = Float.parseFloat(components[fieldIndex+1]);
						inData[adapter][fieldIndex] = fieldValue;
					}
				}
			}
			

		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
	
	private static void writeOutgoingData(int adapter) {
		/*
		 * Write outgoing data structure
		 */
		// Serialize data structure
		String line = "";
		for(int i = 0; i < outData[adapter].length; i++) {
			line += outData[adapter][i];
			if(i != outData[adapter].length-1) {
				line += ",";
			}
		}
		//if(C.LLC_RAW_LOGGING) {
			Main.log("OUT: " + adapter + ": " + line);
		//}
		line += "\n";
		serialConnections[adapter].sendData(line.getBytes());
		try {
			Thread.sleep(1000); // Not sure if LLC can handle rapid data. Hacky "fix"
		}catch(InterruptedException e) {
			e.printStackTrace();
		}
	}
}
