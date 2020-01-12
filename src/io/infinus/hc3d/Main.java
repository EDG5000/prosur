package io.infinus.hc3d;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.prefs.BackingStoreException;

import javax.swing.JCheckBoxMenuItem;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;
import javax.swing.UIManager;

import org.ini4j.Ini;
import org.ini4j.IniPreferences;
import org.ini4j.InvalidFileFormatException;

import com.formdev.flatlaf.FlatDarculaLaf;

public class Main{
	static {
		System.setProperty("awt.useSystemAAFontSettings","on");
		System.setProperty("swing.aatext", "true");
		System.setProperty("java.awt.headless", "false"); // Required when running jar without desktop environment loaded
		System.setProperty("sun.java2d.uiScale", "1");
	}
	
	static WebcamComponent webcamComponent;
	
	// INI preferences
	public static IniPreferences prefs; // Used to populate Config class manually as well as a backing store for every ParamControl
	public static Ini prefsIni;
	public static boolean prefsDirty = false;
	
	// Runtime fields
	static boolean uiReady = false;
	public static String applicationFolder;
	List<ParamControl> controls = new ArrayList<ParamControl>();
	static JLabel[] dataLabels = null; 
	
	// Operational parameters
	public static class Params{
		public static Param P;
		public static Param I;
		public static Param D;
		public static Param HCT;
		public static Param ACTIVE;
	}
	
	// INI Config
	public static class Config{
		public static String[] serialPortIds = new String[LLC.LLC_ADAPTER_COUNT];
		public static int webcamIndex = -1;
		public static String webcamDeviceName;
		public static boolean webcamEnabled = false;
		public static boolean calibrationMode;
		public static boolean llcEnabled = false;
	}
	
	public static void onLLCTickComplete() {
		if(!uiReady) {
			// UI still initializing
			return;
		}
		// Update temperature labels
		for(int i = 0; i < dataLabels.length; i++) {
			int row = i / 12;
			int column = i % 12; 
			String value = getDataValueAt(row, column);
			dataLabels[i].setText(value);
		}
	}
	
	public static void onError(String error) {
		Main.log("Error encountered: " + error);
	}
	
	public static void main(String[] args) throws InterruptedException {
		Runtime.getRuntime().addShutdownHook(new Thread()
		{
		    @Override
		    public void run()
		    {
		    	Main.log("Infinus HC3D is closing.");
		    }
		});
		Main.log("Infinus HC3D 0.1 (c) Joel Meijering");
		if(args.length == 0) {
			throw new RuntimeException("Application folder argument must be supplied.");
		}
		applicationFolder = args[0];
		
		// Load INI config
		try {
			File configFile = new File(applicationFolder + "/config.ini");
			if(!configFile.exists()) {
				throw new RuntimeException("config.ini not present in " + applicationFolder);
			}
			prefsIni = new Ini(configFile);
			
		} catch (InvalidFileFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		prefs = new IniPreferences(prefsIni);
		Params.P = new Param("P");
		Params.I = new Param("I");
		Params.D = new Param("D");
		Params.HCT = new Param("HCT");
		Params.ACTIVE = new Param("ACTIVE");
		Config.serialPortIds[LLC.ADAPTER_TEMP_A] = prefs.node("main").get("serialPortTempA", "");
		Config.serialPortIds[LLC.ADAPTER_RECIR] = prefs.node("main").get("serialPortRecir", "");
		Config.serialPortIds[LLC.ADAPTER_FAN_HE] = prefs.node("main").get("serialPortFanHe", "");
		Config.serialPortIds[LLC.ADAPTER_RELAY] = prefs.node("main").get("serialPortRelay", "");
		Config.webcamEnabled = prefs.node("main").getBoolean("webcamEnabled", false);
		Config.webcamDeviceName = prefs.node("main").get("webcamDeviceName", "");
		Config.calibrationMode = prefs.node("main").getBoolean("calibrationMode", false);
		Config.llcEnabled = prefs.node("main").getBoolean("llcEnabled", false);
		
		/*
		 * Load native library for v4l4j
		 */
		if(Config.webcamEnabled) {
			Main.log("Loading v4lvj native libraries.");
			if(System.getProperty("os.arch").equals("arm")) {
				// Assumes Linux armhf
				System.load(applicationFolder + "/lib/v4l4j/libv4l4j-linux-armhf.so");
			}else {
				// Assumed Linux x64
				System.load(applicationFolder + "/lib/v4l4j/libv4l4j-linux-x86_64.so");
			}
			Main.log("Libraries loaded.");
		}
		
		if(Config.calibrationMode) {
			Temperatures.startCalib();
		}else {
			// Start UI init in other thread, not sure if beneficial, but is seems conventional
	        javax.swing.SwingUtilities.invokeLater(new Runnable() {
	            public void run() {
	                Main.createAndShowGui();
	            }
	        });
		}
		
		if(Config.llcEnabled) {
			LLC.init();
			Control.init();
		
			// Start control, otherwise it will be started once the user switches it on
			if(Params.ACTIVE.getValue() == 1) {
				Control.on();
			}else {
				Control.off();
			}
		}
		
		if(C.SELF_TEST_TEMPERATURE) {
			for(int voltage = 0; voltage < 1024; voltage++) {
				Main.log(Temperatures.temperatureFromThermistorVoltage(0, voltage));
			}
			System.exit(0);
		}
		
		// Periodic flushing of changes to INI settings (used when modifing parameters
		// Checks if dirty flag is high and flushes the buffer in that case
		new Timer().schedule(new TimerTask() {
			@Override
			public void run() {
				if(!prefsDirty) return;
				flushPreferences();
			}
		}, 0, 5000);
	}
	
	public static void flushPreferences() {
		try {
			Main.prefs.node("main").flush();
			Main.prefsIni.store();
		} catch (BackingStoreException | IOException e) {
			e.printStackTrace();
		}
	}
	
	static void createAndShowGui() {
		Main.log("Starting UI create");
		try {
		    UIManager.setLookAndFeel(new FlatDarculaLaf());
		} catch( Exception ex ) {
		    System.err.println("Failed to initialize LaF");
		}
		// Frame
		JFrame frame = new JFrame("HC3D");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		JLayeredPane pane = frame.getLayeredPane();
		
		// Webcam component
		if(Config.webcamEnabled) {
			Main.log("Starting webcam init");
			webcamComponent = new WebcamComponent();
			webcamComponent.setBackground(new Color(111,0,0)); // Maroon test color
			webcamComponent.setPreferredSize(new Dimension(C.DISP_WIDTH, C.DISP_HEIGHT));
			webcamComponent.setOpaque(true);
			webcamComponent.setBounds(0, 0, C.DISP_WIDTH, C.DISP_HEIGHT);
			pane.add(webcamComponent, JLayeredPane.DEFAULT_LAYER);
		}
		JPanel testPanel = new JPanel();
		testPanel.setBounds(0, 0, C.DISP_WIDTH, C.DISP_HEIGHT);
		testPanel.setSize(new Dimension(C.DISP_WIDTH, C.DISP_HEIGHT));
		testPanel.setBackground(new Color(111,0,0)); // Maroon test color
		pane.add(testPanel);
		
		// UI Container
		JPanel uiContainer = new JPanel(new GridBagLayout());
		uiContainer.setBounds(0, 0, C.DISP_WIDTH, C.DISP_HEIGHT);
		GridBagConstraints c = new GridBagConstraints();
		uiContainer.setOpaque(false);
		uiContainer.setBackground(new Color(0,0,0,0));
		pane.add(uiContainer, JLayeredPane.POPUP_LAYER);
		
		// Activity switch
		JCheckBoxMenuItem activeCheckbox = new JCheckBoxMenuItem("ON", Params.ACTIVE.getValue() == 1f);
		activeCheckbox.setBackground(new Color(0, 0, 0, C.UI_BG_OPACITY));
		activeCheckbox.setForeground(Color.white);
		activeCheckbox.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				int active = activeCheckbox.getState() ? 1 : 0;
				Params.ACTIVE.setValue(active);
				if(active == 1) {
					Control.on();
				}else {
					Control.off();
				}
			}
		});
		activeCheckbox.setFont(C.FONT_MAIN_LARGE);
		c.gridx = 0;
		c.gridy = 0;
		c.anchor = GridBagConstraints.NORTHEAST;
		c.fill = GridBagConstraints.NONE;
		c.gridheight = 1;
		c.gridwidth = 1;
		c.weighty = .1; // Required to make cells use all the space available
		uiContainer.add(activeCheckbox, c);

		// Data table
		JPanel dataGrid = new SemiTransparentPanel(new GridLayout(C.DATA_TABLE_ROWS, C.DATA_TABLE_COLS));
		dataGrid.setPreferredSize(new Dimension(C.DISP_WIDTH, 120));
		dataGrid.setBackground(new Color(0, 0, 0, C.UI_BG_OPACITY));
		dataLabels = new JLabel[C.DATA_TABLE_ROWS*C.DATA_TABLE_COLS];
		for(int i = 0; i < dataLabels.length; i++) {
			dataLabels[i] = new JLabel("");
			dataLabels[i].setForeground(Color.white);
			dataLabels[i].setHorizontalAlignment(JLabel.CENTER);
			dataLabels[i].setVerticalAlignment(JLabel.CENTER);
			// Even rows are headers and therefore displayed bold
			if(i/C.DATA_TABLE_ROWS == 0 || i/C.DATA_TABLE_ROWS == 2) { // Layout: HDR, VAL, HDR, VAL, VAL
				dataLabels[i].setFont(C.FONT_MAIN_BOLD);
			}else {
				dataLabels[i].setFont(C.FONT_MAIN);
			}
			dataGrid.add(dataLabels[i]);
		}
		c.gridx = 0;
		c.gridy = 1;
		c.anchor = GridBagConstraints.NORTH;
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridheight = 1;
		c.gridwidth = 1;
		c.weighty = 6; // Required to make cellls use all the space available
		uiContainer.add(dataGrid, c);

		// Tuning controls
		JPanel tuningControlsGrid = new SemiTransparentPanel(new GridLayout(1, 4));
		tuningControlsGrid.setPreferredSize(new Dimension(C.DISP_WIDTH, 50));
		for(Param param : new Param[] {Params.P, Params.I, Params.D}) {
			ParamControl control = new ParamControl(param, 0.01f, 2);
			tuningControlsGrid.add(control);
		}
		tuningControlsGrid.add(new ParamControl(Params.HCT, 1f, 0));
		c.gridx = 0;
		c.gridy = 2;
		c.anchor = GridBagConstraints.SOUTH;
		c.fill = GridBagConstraints.BOTH;
		c.gridheight = 1;
		c.gridwidth = 1;
		c.weighty = .3; // Required to make cells use all the space available
		uiContainer.add(tuningControlsGrid, c);
		
		// Wrap up UI		
		frame.pack();
		frame.setSize(C.DISP_WIDTH, C.DISP_HEIGHT + 50);
		frame.setVisible(true);
	    //GraphicsEnvironment graphics = GraphicsEnvironment.getLocalGraphicsEnvironment();
	    //GraphicsDevice device = graphics.getDefaultScreenDevice();
		// TODO uncomment
	    //device.setFullScreenWindow(frame);
		
		Main.log("UI ready");
		uiReady = true;
	}
	
	private static String getDataValueAt(int rowIndex, int columnIndex) {
		int fieldIndex = -1;
		switch(rowIndex) {
			// Row 0: Temp Sensor Header
			case 0:
				return "T" + (columnIndex+1);
			// Row 1: Temp Sensor Values
			case 1:
				// Retrieve temperature value
				if(columnIndex < Temperatures.SENSOR_COUNT) {
					return Temperatures.getTemperature(columnIndex) + "°C";
				}else {
					return "-";
				}
			// Row 2: Pump/Fan/Relay Header
			case 2:
				// First 6 on this line will be fans
				switch(columnIndex) {
					case 0:
						return "RCRF";
					case 1:
						return "RCRB";
					case 2:
						return "HEFI";
					case 3:
						return "R3IA";
					case 4: 
						return "R3IB";
					case 5:
						return "R12V";
					default:
						return "";
				}
			// Row 3: Pump/Fan/Relay Values
			case 3: 
				// First 6 on this line will be fans
				switch(columnIndex) {
					case 0:
						fieldIndex = LLC.IN.PWM_FAN_RECIR_F;
						return Math.round(LLC.getValue(fieldIndex)*100) + "%";
					case 1:
						fieldIndex = LLC.IN.PWM_FAN_RECIR_B;
						return Math.round(LLC.getValue(fieldIndex)*100) + "%";
					case 2:
						fieldIndex = LLC.IN.PWM_FAN_HE_IN;
						return Math.round(LLC.getValue(fieldIndex)*100) + "%";
					case 3:
						fieldIndex = LLC.IN.RELAY_3DP_INTERLOCK_A;
						return Math.round(LLC.getValue(fieldIndex)) + "";
					case 4:
						fieldIndex = LLC.IN.RELAY_3DP_INTERLOCK_B;
						return Math.round(LLC.getValue(fieldIndex)) + "";
					case 5:
						fieldIndex = LLC.IN.RELAY_RAIL_12V;
						return Math.round(LLC.getValue(fieldIndex)) + "";
					default:
						return "";
				}
				
			// Row 4: Pump/Fan Values
			case 4:
				// TODO add pumps somewhere
				// First 6 on this line will be fans
				switch(columnIndex) {
					case 0:
						fieldIndex = LLC.IN.TACH_FAN_RECIR_F;
						break;
					case 1:
						fieldIndex = LLC.IN.TACH_FAN_RECIR_B;
						break;
					case 2:
						fieldIndex = LLC.IN.TACH_FAN_HE_IN;
						break;
					default:
						return "";
				}
				return Math.round(LLC.getValue(fieldIndex)) + "R";
		}
		//Main.log("Error: No matching value found for row " + rowIndex + " Column: " + columnIndex);
		return null;
	}

	public static void log(String str) {
		if (str == null)
			return;
		str = "[" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "] " + str;
		System.out.println(str);
	}

	public static void log(Object str) {
		if (str == null)
			return;
		if (str instanceof String) {
			log((String) str);
		} else {
			log("Log: Unable to log non-string object.");
		}
	}
	
	public static void log(double val) {
		log(String.valueOf(val));
	}
	
	public static void log(int val) {
		log(String.valueOf(val));
	}
	public static void log(float val) {
		log(String.valueOf(val));
	}
	public static void log(byte val) {
		log(String.valueOf(val));
	}
	public static void log(long val) {
		log(String.valueOf(val));
	}
}
