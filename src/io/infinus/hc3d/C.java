package io.infinus.hc3d;

import java.awt.Font;

public class C {
	/*
	 * Config
	 */
	public final static int DISP_WIDTH = 800 - 0; // Develop with assumed window size matched with production display
	public final static int DISP_HEIGHT = 480 - 0; // Substract OS status bar if present
	public final static boolean SELF_TEST_TEMPERATURE = false; // Verifies temperature calib and dumps to console
	public final static Font FONT_MAIN = new Font("Fira Code", Font.PLAIN, 16);
	public final static Font FONT_MAIN_LARGE = new Font("Fira Code", Font.PLAIN, 25);
	public final static Font FONT_MAIN_BOLD = new Font("Fira Code", Font.BOLD, 16);
	public static final float UI_BG_OPACITY = .5f;
	// Adjust Main.getDataValueAt accordingly
	//public static final int DATA_TABLE_ROWS = 5;
	//public static final int DATA_TABLE_COLS = 12;
	public static final int LLC_TEMP_SENSOR_OFFSET = 0; // Temp sensor LLC id = temp sensor index + LLC offset
	public static final int LLC_TEMP_SENSOR_COUNT = 8;
	public static final int MODE_OFF = 0;
	public static final int MODE_MANUAL = 1;
	public static final int MODE_ON = 2;
	public static final float FAILSAFE_TEMP_MOT = 65;
	public static final float FAILSAFE_TEMP_CHAMBER = 90;
	public static final int TEMP_SENSOR_MOT_Z = 0;
	public static final int TEMP_SENSOR_MOT_X = 1;
	public static final int TEMP_SENSOR_MOT_Y = 2;
	public static final int TEMP_SENSOR_MOT_E = 3;
	public static final int TEMP_SENSOR_CHTR = 4;
	public static final int TEMP_SENSOR_CHBR = 5;
	public static final boolean LLC_RAW_LOGGING = true; // Dumps serial data to log
	public static final float TEMP_PUMP_THRESHOLD = 38;
	public static final float TEMP_PUMP_DEADBAND = 2;
	public static int LLC_TICK_INTERVAL = 1000;
	public static final boolean ENABLE_TEMPERATURE_FAILSAFE = false;
}
