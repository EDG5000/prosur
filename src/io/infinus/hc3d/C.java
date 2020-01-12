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
	public static final int DATA_TABLE_ROWS = 5;
	public static final int DATA_TABLE_COLS = 12;
	public static final int LLC_TEMP_SENSOR_OFFSET = 0; // Temp sensor LLC id = temp sensor index + LLC offset
}
