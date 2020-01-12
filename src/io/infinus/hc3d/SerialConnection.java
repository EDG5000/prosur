package io.infinus.hc3d;

import java.io.IOException;

import jssc.SerialPort;
import jssc.SerialPortException;


public class SerialConnection{
	String deviceId;
	SerialPort serialPort;
	final static int BAUD = 115200;
	boolean opened = false;
	//boolean closingConnection = false;
	boolean failedToSend = false;
	
	public SerialConnection(String pDeviceId){
		deviceId = pDeviceId;
	}
	
	public void openConnection() throws IOException {
		/*
		Main.log("SerialConnection: Adding shutdown hook.");
		Runtime.getRuntime().addShutdownHook(new Thread(){
		    @Override
		    public void run()
		    {
		    	closeConnection();
		    }
		});
		*/
		Main.log("SerialConnection: Opening device "+deviceId+" with baud rate "+BAUD);
    	serialPort = new jssc.SerialPort(deviceId);
    	try {
			boolean result = serialPort.openPort();
			if(result){
				opened = serialPort.setParams(BAUD, SerialPort.DATABITS_8,SerialPort.STOPBITS_1,SerialPort.PARITY_NONE);
			}else{
				Main.log("SerialConnection: Unable to open serial port.");
				System.exit(0);
			}
			if(!opened){
				Main.log("SerialConnection: Unable to initialize serial port.");
				System.exit(0);
			}
			Main.log("SerialConnection: Device opened.");
		} catch (SerialPortException e) {
			e.printStackTrace();
		}

	}
	/*
	void waitForSerialConnected(){
		long start = System.currentTimeMillis();
		Main.log("SerialConnection: Connection failed to establish, .");
		System.exit(0);
		
		while(!opened){
			try {
				Thread.sleep(200);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			if((System.currentTimeMillis() - start) > 10000){
				Main.log("SerialConnection: Error: Timing out while waiting for serial to come online.");
				System.exit(0);
			}
		}
	}
	*/
	

	public Boolean sendData(byte[] buffer) {
		//if(closingConnection) return false;
		//waitForSerialConnected();
		try {
			boolean result = serialPort.writeBytes(buffer);
			if(!result){
				if(!failedToSend){
					failedToSend = true;
					Main.log("SerialConnection: Unable to send "+buffer.length+ " bytes.");
				}
			}else{
				if(failedToSend){
					Main.log("SerialConnection: Device recovered.");
					failedToSend = false;
				}
			}
			return result;
		} catch (SerialPortException e) {
			//DATC.printStackTrace(e);
			//e.printStackTrace();
			Main.printStackTrace(e);
		}
		return false;
	}
	
	public byte[] readDataBlock() throws IOException {
		//if(closingConnection) return null;
		//waitForSerialConnected();
		try {
			return serialPort.readBytes();
		} catch (SerialPortException e) {
			//e.printStackTrace();
			Main.printStackTrace(e);
			System.exit(0);
		}
		return null;
	}

	// Called at shutdown of application
	/*
	public void closeConnection(){
		closingConnection = true;
		// TODO test
		Main.Params.P.setValue((float) Math.random());
		Main.flushPreferences();
		
		try {
			Main.log("Closing serial connection " + deviceId + "..."); 
			serialPort.closePort();
			Main.log("Serial connection " + deviceId + " closed.");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
*/

	
//	long[] byteCount = new long[60]; // Total bytes of the last 60 seconds
//	int samples = 0; // 0-60 
//	long byteCountCurrent = 0;
	// Return average reading bitrate in byte/s
//	public double getAvgReadingRate(){
//		long total = 0;
//		for(int i = 0; i < samples; i++){
//			total += byteCount[i];
//		}
//		return (total / samples) / 1024.0f;
//	}
    // Move average 1 position every second
//  new Thread(new Runnable(){
//		@Override
//		public void run() {
//			try {
//				Thread.sleep(1000);
//			} catch (InterruptedException e) {
//				e.printStackTrace();
//				System.exit(0);
//			}
//			// Copy this seconds' total byte count to the relevant moving average slot
//			if(samples < 60){
//				byteCount[samples] = byteCountCurrent;
//				samples++;
//			}else{
//				// Move every item one down, add new item at the end
//				for(int i = 1; i < 60; i++){
//					byteCount[i-1] = byteCount[i];
//				}
//				byteCount[59] = byteCountCurrent;
//			}
//		}
//  }, "Bitrate-Sampling-Thread").start();
}
