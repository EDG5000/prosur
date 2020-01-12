package io.infinus.hc3d;

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;


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
	
	public static final int TICK_INTERVAL = 1000;
	static final int LLC_ADAPTER_COUNT = 4;
	
	// LLC adapter identifiers
	static final int ADAPTER_TEMP_A = 0;
	static final int ADAPTER_RECIR = 1;
	static final int ADAPTER_FAN_HE = 2;
	static final int ADAPTER_RELAY = 3;
	
	// Field IDs. Need to be in accordance with field layout so that they can be found when calling helper methods
	// Only used for convenience access
	public static class IN{
		// TEMPA
		public static final int TEMP_A1 = 0;
		public static final int TEMP_A2 = 1;
		
		// RECIR
		public static final int PWM_FAN_RECIR_F = 2;
		public static final int PWM_FAN_RECIR_B = 3;
		public static final int TACH_FAN_RECIR_F = 4;
		public static final int TACH_FAN_RECIR_B = 5;
		
		// FAN HE
		public static final int PWM_FAN_HE_IN = 6;
		public static final int TACH_FAN_HE_IN = 7;
		/*public static final int PWM_FAN_HE_OUT = 6;   TODO uncomment
		public static final int TACH_FAN_HE_OUT = 7;*/
		
		// RELAY
		public static final int RELAY_3DP_INTERLOCK_A = 8;
		public static final int RELAY_3DP_INTERLOCK_B = 9;
		public static final int RELAY_RAIL_12V = 10; // Fans and pumps for 3DP cooling and chamber temperature regulation

		// PUMPS
		// TODO uncomment
		/*public static final int PWM_PUMP_HE = 2;
		public static final int PWM_PUMP_THR_EXH = 3;
		public static final int TACH_PUMP_HE = 4;
		public static final int TACH_PUMP_THR_EXH = 5;*/
	}
	
	public static class OUT{
		// RECIR
		public static final int PWM_FAN_RECIR_F = 0;
		public static final int PWM_FAN_RECIR_B = 1;
		
		// FAN HE
		public static final int PWM_FAN_HE_IN = 2;
		
		// RELAY
		public static final int RELAY_3DP_INTERLOCK_A = 3;
		public static final int RELAY_3DP_INTERLOCK_B = 4;
		public static final int RELAY_RAIL_12V = 5; // Fans and pumps for 3DP cooling and chamber temperature regulation
	}
	// Indexed by adapter, values represent field count per adapter
	static final int[] IN_FIELD_LAYOUT = new int[]{
			2, // TEMP_A
			4, // RECIR
			2, // FAN HE
			3 // RELAY
	};
	
	static final int[] OUT_FIELD_LAYOUT = new int[]{
			0, // TEMP_A
			2, // RECIR
			1, // FAN HE
			3 // RELAY
	};
	
	/*
	 * End LLC configuration
	 */
	
	private static SerialConnection[] serialConnections = new SerialConnection[LLC_ADAPTER_COUNT];
	
	// Updated every frame
	static float[][] inData = new float[LLC_ADAPTER_COUNT][];
	// Stored partially received lines
	static String[] serialReceiveBuffer = new String[LLC_ADAPTER_COUNT];
	
	// Sent every frame
	static float[][] outData = new float[LLC_ADAPTER_COUNT][];
	
	// First time an error is encountered, it is tolerated (could be because application started in the middle of frame transmission)
	// Otherwise, generate error application
	static boolean[] incomingFrameWasDropped = new boolean[LLC_ADAPTER_COUNT];
	
	// Index by field id, containing pair of adapter id and field index
	private static int[][] inFieldLookup;
	private static int[][] outFieldLookup;
	
	static {
		// Initialize all structures with -1 or empty strings
		for(int adapter = 0; adapter < LLC_ADAPTER_COUNT; adapter++) {
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

	public static void init() {
		Main.log("Init LLC");
		// Initialize serial connections
		try {
			for(int adapter = 0; adapter < LLC_ADAPTER_COUNT; adapter++) {
				serialConnections[adapter] = new SerialConnection(Main.Config.serialPortIds[adapter]);
				serialConnections[adapter].openConnection();
			}
		} catch (IOException e1) {
			e1.printStackTrace();
			System.exit(1);
		}
		
		// LLC tick (.1hz)
		new Timer().schedule(new TimerTask() {
			@Override
			public void run() {
				for(int i = 0; i < LLC_ADAPTER_COUNT; i++) {
					serialTick(i);
				}
				emitOnTickComplete();
			}
		}, 0, TICK_INTERVAL);
		Main.log("LLC ready.");
	}
	
	private static void emitOnTickComplete() {
		Main.onLLCTickComplete();
		Control.onLLCTickComplete();
		//Temperatures.onLLCTickComplete();
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
		 outData
			[outFieldLookup[fieldId][0]]
			[outFieldLookup[fieldId][1]]
		 = value;
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
				Main.log("IN " + adapter + ": "+ dataToParse);
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
			
			/*
			 * Write outgoing data structure
			 */
			// Serialize data structure
			String line = "";
			for(int i = 0; i < outData[adapter].length; i++) {
				line += outData[adapter][i];
				if(i != outData.length-1) {
					line += ",";
				}
			}
			Main.log("OUT: " + adapter + ": " + line);
			line += "\n";
			serialConnections[adapter].sendData(line.getBytes());
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
}
