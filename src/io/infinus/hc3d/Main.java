package io.infinus.hc3d;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import com.github.sarxos.webcam.Webcam;
import com.github.sarxos.webcam.WebcamPanel;
import com.github.sarxos.webcam.WebcamResolution;


public class Main {
	
	/*
	 * Config
	 */
	private final static int DISP_WIDTH = 800 - 0; // Develop with assumed window size matched with production display
	private final static int DISP_HEIGHT = 480 - 20; // Substract OS status bar if present
	private final static int TEMPERATURE_LABEL_HEIGHT = 40;
	private final static int TEMPERATURE_LABELS_COUNT = 12;
	private final static Color MAIN_TEXT_COLOR = Color.white;
	static JLabel[] temperatureLabels = new JLabel[TEMPERATURE_LABELS_COUNT];
	
	private final static Font FONT_MAIN = new Font("RobotoMono-Regular", Font.PLAIN, 12);
	
	static {
		System.setProperty("awt.useSystemAAFontSettings","on");
		System.setProperty("swing.aatext", "true");
	}
			
	public static void main(String[] args) throws InterruptedException {

		
		// Container
		JPanel containerPanel = new JPanel();
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
		JPanel layout = new JPanel(new GridLayout(1, TEMPERATURE_LABELS_COUNT));
		layout.setBounds(0, 0, DISP_WIDTH, TEMPERATURE_LABEL_HEIGHT);
		layout.setOpaque(false);
		layout.setBackground(new Color(255, 255, 255, 127)); // Semi transparent black
		for(JLabel label: temperatureLabels) {
			label.setFont(FONT_MAIN);
			label.setForeground(MAIN_TEXT_COLOR);
			label.setPreferredSize(new Dimension(DISP_WIDTH, DISP_HEIGHT));
			layout.add(label);
		}
		
		// Frame
		JFrame frame = new JFrame("Test webcam panel");
		frame.setExtendedState(frame.getExtendedState() | JFrame.MAXIMIZED_BOTH);
		frame.setResizable(true);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		// Create hieracrchy
		frame.add(containerPanel);
		containerPanel.add(webcamPanel);
		
		frame.pack();
		frame.setVisible(true);
	}
}
