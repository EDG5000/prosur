package io.infinus.hc3d;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JCheckBoxMenuItem;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;

import org.ini4j.Ini;
import org.ini4j.IniPreferences;
import org.ini4j.InvalidFileFormatException;

import com.formdev.flatlaf.FlatDarculaLaf;

public class Main{
	
	/*
	 * Config
	 */
	private final static int DISP_WIDTH = 800 - 0; // Develop with assumed window size matched with production display
	private final static int DISP_HEIGHT = 480 - 0; // Substract OS status bar if present
	// TODO use layout which calculates this automtivally?
	private final static int SENSOR_DATA_TABLE_HEIGHT = 100;
	private final static Color MAIN_TEXT_COLOR = Color.white;
	private final static boolean SELF_TEST_TEMPERATURE = false; // Verifies temperature calib and dumps to console
	//static JLabel[] temperatureLabels = new JLabel[Temperatures.SENSOR_COUNT];
	static WebcamComponent webcamComponent;
	public static java.util.prefs.Preferences prefs; // Used to populate Config class manually as well as a backing store for every ParamControl
	private final static Font FONT_MAIN = new Font("RobotoMono-Regular", Font.PLAIN, 12);
	
	public static class Params{
		public static Param P;
		public static Param I;
		public static Param D;
		public static Param HC_TEMP_SET;		
	}
	
	static {
		System.setProperty("awt.useSystemAAFontSettings","on");
		System.setProperty("swing.aatext", "true");
		System.setProperty("java.awt.headless", "false"); // Required when running jar without desktop environment loaded
		   System.setProperty("sun.java2d.uiScale", "1");

	}
		
	static boolean uiReady = false;
	
	// INI config
	public static class Config{
		public static String[] serialPortIds = new String[LLC.LLC_ADAPTER_COUNT];
		public static int webcamIndex = -1;
		public static String webcamDeviceName;
		public static boolean webcamEnabled = false;
		public static boolean calibrationMode;
		public static boolean llcEnabled = false;
	}

	public static String applicationFolder;
	
	public static void onLLCTickComplete() {
		if(!uiReady) {
			// UI still initializing
			return;
		}
		// Update temperature labels
		/*for(int i = 0; i < Temperatures.SENSOR_COUNT; i++) {
			temperatureLabels[i].setText(Temperatures.getTemperature(i) + "°C");
		}*/
		for(int i = 0; i < dataLabels.length; i++) {
			int row = (int) Math.floor(i / 12f);
			int column = i % 12; 
			String value = getDataValueAt(row, column);
			dataLabels[i].setText(value);
		}
	}
	
	public static void onError(String error) {
		// TODO show on UI
		System.out.println("Error encountered: " + error);
	}
	
	public static void main(String[] args) throws InterruptedException {
		try {
		    UIManager.setLookAndFeel(new FlatDarculaLaf());
		} catch( Exception ex ) {
		    System.err.println( "Failed to initialize LaF" );
		}

		System.out.println("Infinus HC3D 0.1 (c) Joel Meijering");
		if(args.length == 0) {
			throw new RuntimeException("Application folder argument must be supplied.");
		}
		applicationFolder = args[0];
		
		// Load INI config
		Ini ini = null;
		try {
			File configFile = new File(applicationFolder + "/config.ini");
			if(!configFile.exists()) {
				throw new RuntimeException("config.ini not present in " + applicationFolder);
			}
			ini = new Ini(configFile);
			
		} catch (InvalidFileFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		prefs = new IniPreferences(ini);
		Params.P = new Param("P");
		Params.I = new Param("I");
		Params.D = new Param("D");
		Params.HC_TEMP_SET = new Param("HC_TEMP");
		Config.serialPortIds[LLC.ADAPTER_TEMP1] = prefs.node("main").get("serialPortIdA", "");
		Config.serialPortIds[LLC.ADAPTER_RECIR] = prefs.node("main").get("serialPortIdB", "");
		Config.serialPortIds[LLC.ADAPTER_FAN_HE] = prefs.node("main").get("serialPortIdTREF", "");
		Config.webcamEnabled = prefs.node("main").getBoolean("webcamEnabled", false);
		Config.webcamDeviceName = prefs.node("main").get("webcamDeviceName", "");
		Config.calibrationMode = prefs.node("main").getBoolean("calibrationMode", false);
		Config.llcEnabled = prefs.node("main").getBoolean("llcEnabled", false);
		
		/*
		 * Load native library for v4l4j
		 */
		if(Config.webcamEnabled) {
			System.out.println("Loading v4lvj native libraries.");
			if(System.getProperty("os.arch").equals("arm")) {
				// Assumes Linux armhf
				System.load(applicationFolder + "/lib/v4l4j/libv4l4j-linux-armhf.so");
			}else {
				// Assumed Linux x64
				System.load(applicationFolder + "/lib/v4l4j/libv4l4j-linux-x86_64.so");
			}
			System.out.println("Libraries loaded.");
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
		}
		
		if(Main.SELF_TEST_TEMPERATURE) {
			for(int voltage = 0; voltage < 1024; voltage++) {
				System.out.println(Temperatures.temperatureFromThermistorVoltage(0, voltage));
			}
			System.exit(0);
		}
	}
	
	List<ParamControl> controls = new ArrayList<ParamControl>();
	static JLabel[] dataLabels = null; 
	
	static void createAndShowGui() {

		
		/*
		 * Create UI
		 */
		System.out.println("Starting UI create");
		
		// Frame

		JFrame frame = new JFrame("HC3D");
		
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		// Frame panel
		JLayeredPane layeredPane = frame.getLayeredPane();
		
		//framePanel.setLayout(null);
		//framePanel.setBounds(0, 0, DISP_WIDTH, DISP_HEIGHT);
		
		// Webcam component
		if(Config.webcamEnabled) {
			System.out.println("Starting webcam init");
			webcamComponent = new WebcamComponent();
			webcamComponent.setBounds(0, 0, DISP_WIDTH, DISP_HEIGHT);
		}
		
		// UI Container
		JPanel uiContainer = new JPanel(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		uiContainer.setBounds(0, 0, DISP_WIDTH, DISP_HEIGHT);
		//uiContainer.setBackground(Color.cyan);
		
		// Activity switch
		JCheckBoxMenuItem activeCheckbox = new JCheckBoxMenuItem("Active");
		

		

		
		// Create hierarchy
		//frame.add(framePanel);
		//frame.add(layeredPane);
		
		if(Config.webcamEnabled) {
			layeredPane.add(webcamComponent, JLayeredPane.DEFAULT_LAYER);
		}
		layeredPane.add(uiContainer, JLayeredPane.POPUP_LAYER);
			
		
			c.gridx = 0;
			c.gridy = 0;
			c.anchor = GridBagConstraints.NORTHEAST;
			c.weighty = .2f;
			c.fill = GridBagConstraints.NONE;
			uiContainer.add(activeCheckbox, c);
			
			

			JPanel testGrid = new JPanel(new GridLayout(4, 12));
			testGrid.setPreferredSize(new Dimension(DISP_WIDTH, 200));
			testGrid.setBackground(Color.blue);
			dataLabels = new JLabel[4*12];
			for(int i = 0; i < 4*12; i++) {
				dataLabels[i] = new JLabel("A");
				testGrid.add(dataLabels[i]);
			}
			c.gridx = 0;
			c.gridy = 1;
			c.gridwidth = 1;
			c.fill = GridBagConstraints.BOTH;
			uiContainer.add(testGrid, c);
			
			JPanel testGrid2 = new JPanel(new GridLayout(1, 4));
			testGrid2.setPreferredSize(new Dimension(DISP_WIDTH, 25));
			testGrid2.setBackground(Color.blue);
			
			// Add controls for modifiing the runtime parameters
			for(Param param : new Param[] {Params.P, Params.I, Params.D}) {
				ParamControl control = new ParamControl(param, 0.01f, 2);
				testGrid2.add(control);
			}
			testGrid2.add(new ParamControl(Params.HC_TEMP_SET, 1f, 0));
			
			c.gridx = 0;
			c.gridy = 2;
			c.gridwidth = 1;
			c.fill = GridBagConstraints.BOTH;
			uiContainer.add(testGrid2, c);
			
			/*
			c.gridx = 3;
			c.gridy = 1;
			c.gridwidth = 1;
			c.fill = GridBagConstraints.HORIZONTAL;
			c.weightx = .25;
			
			*/
			
			
		    //natural height, maximum width
		/*
		    c.fill = GridBagConstraints.HORIZONTAL;
		    JButton button;
		    button = new JButton("Button 1");
		    c.weightx = 0.5;
		    c.fill = GridBagConstraints.HORIZONTAL;
		    c.gridx = 0;
		    c.gridy = 0;
		    uiContainer.add(button, c);
		 
		    button = new JButton("Button 2");
		    c.fill = GridBagConstraints.HORIZONTAL;
		    c.weightx = 0.5;
		    c.gridx = 1;
		    c.gridy = 0;
		    uiContainer.add(button, c);
		 
		    button = new JButton("Button 3");
		    c.fill = GridBagConstraints.HORIZONTAL;
		    c.weightx = 0.5;
		    c.gridx = 2;
		    c.gridy = 0;
		    uiContainer.add(button, c);
		 
		    button = new JButton("Long-Named Button 4");
		    c.fill = GridBagConstraints.HORIZONTAL;
		    c.ipady = 40;      //make this component tall
		    c.weightx = 0.0;
		    c.gridwidth = 3;
		    c.gridx = 0;
		    c.gridy = 1;
		    uiContainer.add(button, c);
		 
		    button = new JButton("5");
		    c.fill = GridBagConstraints.HORIZONTAL;
		    c.ipady = 0;       //reset to default
		    c.weighty = 1.0;   //request any extra vertical space
		    c.anchor = GridBagConstraints.PAGE_END; //bottom of space
		    c.insets = new Insets(10,0,0,0);  //top padding
		    c.gridx = 1;       //aligned with button 2
		    c.gridwidth = 2;   //2 columns wide
		    c.gridy = 2;       //third row
		    uiContainer.add(button, c);
		    */
				
		frame.pack();
		frame.setSize(DISP_WIDTH, DISP_HEIGHT);
		frame.setVisible(true);
	    GraphicsEnvironment graphics = GraphicsEnvironment.getLocalGraphicsEnvironment();
	    GraphicsDevice device = graphics.getDefaultScreenDevice();
		//device.setFullScreenWindow(frame);
		
		System.out.println("UI ready");
		uiReady = true;
	}
	
	private static String getDataValueAt(int rowIndex, int columnIndex) {
		int fieldIndex = -1;
		// TODO Auto-generated method stub
		switch(rowIndex) {
			case 0:
				return "TEMP" + (columnIndex+1);
			case 1:
				// Retrieve temperature value
				if(columnIndex < Temperatures.SENSOR_COUNT) {
					return Temperatures.getTemperature(columnIndex) + "°C";
				}else {
					return "?";
				}
				
			case 2:
				// TODO add pumps somewhere
				// First 6 on this line will be fans
				switch(columnIndex) {
					case 0:
						return "RECIR F";
					case 1:
						return "RECIR B";
					case 2:
						return "HE IN";
					default:
						return "-";
				}
			case 3: 
				// TODO add pumps somewhere
				// First 6 on this line will be fans
				
				switch(columnIndex) {
					case 0:
						fieldIndex = LLC.IN.PWM_FAN_RECIR_F;
						break;
					case 1:
						fieldIndex = LLC.IN.PWM_FAN_RECIR_B;
						break;
					case 2:
						fieldIndex = LLC.IN.PWM_FAN_HE_IN;
						break;
					default:
						return "-";
				}
				return Math.round(LLC.getValue(fieldIndex)*100) + "%";
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
						return "-";
				}
				return Math.round(LLC.getValue(fieldIndex)) + " RPM";
		}
		return null;
	}
}
