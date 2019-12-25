package io.infinus.hc3d;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
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

import com.github.sarxos.webcam.Webcam;
import com.github.sarxos.webcam.WebcamPanel;
import com.github.sarxos.webcam.WebcamResolution;


public class Main{
	
	/*
	 * Config
	 */
	private final static int DISP_WIDTH = 800 - 0; // Develop with assumed window size matched with production display
	private final static int DISP_HEIGHT = 480 - 20; // Substract OS status bar if present
	private final static int TEMPERATURE_LABEL_HEIGHT = 40;
	private final static Color MAIN_TEXT_COLOR = Color.white;
	static JLabel[] temperatureLabels = new JLabel[Temperatures.SENSOR_COUNT];
	
	private final static Font FONT_MAIN = new Font("RobotoMono-Regular", Font.PLAIN, 12);
	
	static {
		System.setProperty("awt.useSystemAAFontSettings","on");
		System.setProperty("swing.aatext", "true");
	}
		
	// INI config
	public static class Config{
		public static String[] serialPortIds = new String[LLC.LLC_ADAPTER_COUNT];
	}

	public static void onLLCTickComplete() {
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
		
		/*
		 * Create UI
		 */
		
		// Container
		JLayeredPane containerPanel = new JLayeredPane();
		containerPanel.setBackground(Color.cyan);
		containerPanel.setLayout(null); // Use absolute positioning for now (allows easily overlaying labels)
		
		// Webcam panel
		Webcam webcam = Webcam.getDefault();
		webcam.setViewSize(WebcamResolution.VGA.getSize());
		WebcamPanel webcamPanel = new WebcamPanel(webcam);
		webcamPanel.setFPSDisplayed(true);
		webcamPanel.setDisplayDebugInfo(true);
		webcamPanel.setImageSizeDisplayed(true);
		webcamPanel.setMirrored(true);
		webcamPanel.setBounds(0, 0, DISP_WIDTH, DISP_HEIGHT);
		
		// Temperature label panel
		JPanel temperaturePanel = new JPanel(new GridLayout(1, Temperatures.SENSOR_COUNT));
		
		temperaturePanel.setBounds(0, 300, DISP_WIDTH, TEMPERATURE_LABEL_HEIGHT);
		//temperaturesPanel.setOpaque(false);
		temperaturePanel.setBackground(new Color(0, 0, 0, 127)); // Semi transparent black
		for(JLabel label: temperatureLabels) {
			label = new JLabel();
			label.setText("-");
			label.setFont(FONT_MAIN);
			label.setForeground(MAIN_TEXT_COLOR);
			label.setPreferredSize(new Dimension(DISP_WIDTH, DISP_HEIGHT));
			temperaturePanel.add(label);
		}
		
		// Frame
		JFrame frame = new JFrame("Test webcam panel");
		frame.setExtendedState(frame.getExtendedState() | JFrame.MAXIMIZED_BOTH);
		frame.setResizable(true);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		// Create hierarchy
		frame.add(containerPanel);
		containerPanel.add(webcamPanel, 1);
		containerPanel.add(temperaturePanel, 0);
		//containerPanel.setComponentZOrder(temperaturePanel, 0);
		//containerPanel.setComponentZOrder(webcamPanel, 1);
		
		frame.pack();
		frame.setVisible(true);
		
		LLC.init();
		Temperatures.init();
		
		if(Main.mode.equals("calibrate-thermistors")) {
			// TODO activate calibration mode
			Temperatures.startCalib();
		}
	}


	
}
