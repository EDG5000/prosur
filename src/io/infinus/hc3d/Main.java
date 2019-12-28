package io.infinus.hc3d;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.GridLayout;
import java.io.File;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;

import org.ini4j.Ini;
import org.ini4j.IniPreferences;
import org.ini4j.InvalidFileFormatException;

public class Main{
	
	/*
	 * Config
	 */
	private final static int DISP_WIDTH = 800 - 0; // Develop with assumed window size matched with production display
	private final static int DISP_HEIGHT = 480 - 0; // Substract OS status bar if present
	private final static int TEMPERATURE_LABEL_HEIGHT = 40;
	private final static Color MAIN_TEXT_COLOR = Color.white;
	static JLabel[] temperatureLabels = new JLabel[Temperatures.SENSOR_COUNT];
	
	static WebcamComponent webcamComponent;
	
	private final static Font FONT_MAIN = new Font("RobotoMono-Regular", Font.PLAIN, 12);
	
	static {
		System.setProperty("awt.useSystemAAFontSettings","on");
		System.setProperty("swing.aatext", "true");
		System.setProperty("java.awt.headless", "false");
	}
		
	static boolean uiReady = false;
	
	// INI config
	public static class Config{
		public static String[] serialPortIds = new String[LLC.LLC_ADAPTER_COUNT];
		public static int webcamIndex = -1;
		public static String webcamDeviceName;
		public static boolean webcamEnabled = false;
	}

	public static void onLLCTickComplete() {
		if(!uiReady) {
			// UI still initializing
			return;
		}
		// Update temperature labels
		for(int i = 0; i < Temperatures.SENSOR_COUNT; i++) {
			temperatureLabels[i].setText(Temperatures.getTemperature(i) + "°C");
		}
	}
	
	public static String mode = null;
	
	public static void onError(String error) {
		// TODO show on UI
		System.out.print("Error encountered: " + error);
	}
	
	public static void main(String[] args) throws InterruptedException {
		if(args.length > 0) {
			mode = args[0];
		}
		
		// Load INI config
		Ini ini = null;
		try {
			File configFile = new File(Util.getApplicationFolder() + "/config.ini");
			if(!configFile.exists()) {
				throw new RuntimeException("config.ini not present in " + Util.getApplicationFolder());
			}
			ini = new Ini(configFile);
			
		} catch (InvalidFileFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		java.util.prefs.Preferences prefs = new IniPreferences(ini);
		Config.serialPortIds[LLC.LLC_A] = prefs.node("main").get("serialPortIdA", "");
		Config.serialPortIds[LLC.LLC_B] = prefs.node("main").get("serialPortIdB", "");
		Config.serialPortIds[LLC.LLC_TREF] = prefs.node("main").get("serialPortIdTREF", "");
		Config.webcamEnabled = prefs.node("main").getBoolean("webcamEnabled", false);
		Config.webcamDeviceName = prefs.node("main").get("webcamDeviceName", "");
		
		if(Config.webcamEnabled) {
			System.loadLibrary("v4l4j");
		}
		
		// Initialize webcam and webcam panel
		if(Config.webcamEnabled) {
			System.out.println("Starting webcam init");
			webcamComponent = new WebcamComponent();
			webcamComponent.setBounds(0, 0, DISP_WIDTH, DISP_HEIGHT);
		}
		
        //Schedule a job for the event-dispatching thread:
        //creating and showing this application's GUI.
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                Main.createAndShowGui();
            }
        });
		
		//LLC.init();
		
		if(Main.mode != null && Main.mode.equals("calibrate-thermistors")) {
			Temperatures.startCalib();
		}
	}
	
	static void createAndShowGui() {

		

		
		/*
		 * Create UI
		 */
		System.out.println("Starting UI createy");
		// Container
		JLayeredPane containerPanel = new JLayeredPane();
		containerPanel.setBackground(Color.cyan);
		//containerPanel.setLayout(null); // Use absolute positioning for now (allows easily overlaying labels)
		
		// Temperature label panel
		JPanel temperaturePanel = new JPanel(new GridLayout(1, Temperatures.SENSOR_COUNT));
		
		temperaturePanel.setBounds(0, 0, DISP_WIDTH, TEMPERATURE_LABEL_HEIGHT);
		//temperaturesPanel.setOpaque(false);
		temperaturePanel.setBackground(new Color(0, 255, 0, 127)); // Semi transparent black
		for(int i = 0; i < temperatureLabels.length; i++) {
			temperatureLabels[i] = new JLabel();
			temperatureLabels[i].setText("-");
			temperatureLabels[i].setFont(FONT_MAIN);
			temperatureLabels[i].setForeground(MAIN_TEXT_COLOR);
			temperatureLabels[i].setPreferredSize(new Dimension(DISP_WIDTH, DISP_HEIGHT));
			temperaturePanel.add(temperatureLabels[i]);
		}
		
		// Frame
		System.out.println("Preparing frame");
	      GraphicsEnvironment graphics =
	    	      GraphicsEnvironment.getLocalGraphicsEnvironment();
	    	      GraphicsDevice device = graphics.getDefaultScreenDevice();
		
		
		JFrame frame = new JFrame("Test webcam panel");
		frame.setExtendedState(JFrame.MAXIMIZED_BOTH); 
		frame.setUndecorated(true);
		//frame.setBounds(0, 0, DISP_WIDTH, DISP_HEIGHT);
		frame.setResizable(false);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		

		
		// Create hierarchy
		frame.add(containerPanel);
		if(Config.webcamEnabled) {
			containerPanel.add(webcamComponent, JLayeredPane.DEFAULT_LAYER);
		}
		containerPanel.add(temperaturePanel, JLayeredPane.POPUP_LAYER);
		
		frame.pack();
		frame.setVisible(true);
		device.setFullScreenWindow(frame);
		
		System.out.println("UI ready");
		uiReady = true;
	}


	
}
