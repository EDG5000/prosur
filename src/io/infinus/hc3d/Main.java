package io.infinus.hc3d;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.ini4j.Ini;
import org.ini4j.IniPreferences;
import org.ini4j.InvalidFileFormatException;

/*
 * TODO
 * - proper filteren van temp waarden zodat de gebruikt kunntn worden
 * - auto pump speed based on temp
 * - failsafe
 */

import io.infinus.hc3d.modules.DataLog;

public class Main{
	public static boolean stopping = false; // Set high when application is being killed
	static {
		System.setProperty("awt.useSystemAAFontSettings","on");
		System.setProperty("swing.aatext", "true");
		System.setProperty("java.awt.headless", "false"); // Required when running jar without desktop environment loaded
		System.setProperty("sun.java2d.uiScale", "1");
	}
	
	
	// INI preferences
	public static IniPreferences prefs; // Used to populate Config class manually as well as a backing store for every ParamControl
	public static Ini prefsIni;
	public static boolean prefsDirty = false;
	
	// Runtime fields
	static boolean uiReady = false;
	public static String applicationFolder;
	static int blinkTick = -1; // Used to blink the ON label
	
	// INI Config
	public static class Config{
		public static String[] serialPortIds = new String[LLC.ADAPTER_COUNT];
		public static int webcamIndex = -1;
		public static String webcamDeviceName;
		public static boolean webcamEnabled = false;
		public static boolean calibrationMode;
		public static boolean llcEnabled = false;
		public static boolean sitlMode = false;
		public static boolean dataLogEnabled = false;
		public static String dataLogFolder = null;
	}
	
	public static void onError(String error) {
		Main.log("Error encountered: " + error);
	}
	
	public static void main(String[] args) throws InterruptedException {
		
		if(!Config.sitlMode) {
			Runtime.getRuntime().addShutdownHook(new Thread()
			{
			    @Override
			    public void run()
			    {
			    	// Half the time closing the serial ports fails, triggering an error in dmesg
			    	// Reset USB device to clean them up after running
			    	Main.log("HC3D is closing.");
			    	DataLog.close();
			    	Main.log("Resetting USB devices...");
			    	Main.log(Shell.shellCommandGetOutput("sh /home/pi/hc3d/reset-usb.sh", new File(applicationFolder)));
			    	Main.log("USB devices reset.");
			    }
			});
		}
		
		// 0.1: version with display and recir controls/manual fan controls/HE fan
		// 0.2: version with no display but with data logging and failsafe
		Main.log("Infinus HC3D 0.2 (c) Joel Meijering");
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
		Config.serialPortIds[LLC.ADAPTER_TEMP_A] = prefs.node("main").get("serialPortTempA", "");
		Config.serialPortIds[LLC.ADAPTER_RECIR] = prefs.node("main").get("serialPortRecir", "");
		Config.serialPortIds[LLC.ADAPTER_PUMP] = prefs.node("main").get("serialPortFanHe", "");
		Config.serialPortIds[LLC.ADAPTER_RELAY] = prefs.node("main").get("serialPortRelay", "");
		Config.dataLogEnabled = prefs.node("main").getBoolean("dataLogEnabled", false);
		Config.llcEnabled = prefs.node("main").getBoolean("llcEnabled", false);
		Config.sitlMode = prefs.node("main").getBoolean("sitlMode", false);
		Config.dataLogFolder = prefs.node("main").get("dataLogFolder", prefs.node("main").get("dataLogFolder", ""));
		
		if(Config.llcEnabled) {
			LLC.init();
		}
	}
	
	public static void log(String str) {
		if (str == null)
			return;
		for(String segment: str.split("\n")){
			segment = "[" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "] " + str;
			System.out.println(segment);
		}
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
	
	public static void printStackTrace(Exception e) {
		String msg = "Exception: " + e.getLocalizedMessage() + "\n";
		for(StackTraceElement el : e.getStackTrace()){
			msg = msg + "\t" + el.getClassName()+"."+el.getMethodName() + " (" + el.getFileName() + ":" + el.getLineNumber() + ")\n";
		}
		Main.log(msg);
	}
}
