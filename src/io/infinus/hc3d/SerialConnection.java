package io.infinus.hc3d;

import java.io.File;
import java.io.IOException;

import org.scream3r.jssc.SerialPort;
import org.scream3r.jssc.SerialPortException;


public class SerialConnection{
	String deviceId;
	SerialPort serialPort;
	final static int BAUD = 115200;
	boolean opened = false;
	
	public SerialConnection(String pDeviceId){
		deviceId = pDeviceId;
	}
	
	public void openConnection() throws IOException {
		System.out.println("SerialConnection: Opening device "+deviceId+" with baud rate "+BAUD);
    	serialPort = new SerialPort(deviceId);
    	try {
			boolean result = serialPort.openPort();
			if(result){
				opened = serialPort.setParams(BAUD, SerialPort.DATABITS_8,SerialPort.STOPBITS_1,SerialPort.PARITY_NONE);
			}else{
				System.out.println("SerialConnection: Unable to open serial port.");
				System.exit(0);
			}
			if(!opened){
				System.out.println("SerialConnection: Unable to initialize serial port.");
				System.exit(0);
			}
			System.out.println("SerialConnection: Device opened.");
		} catch (SerialPortException e) {
			e.printStackTrace();
		}
	}
	
	void waitForSerialConnected(){
		long start = System.currentTimeMillis();
		while(!opened){
			try {
				Thread.sleep(200);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			if((System.currentTimeMillis() - start) > 5000){
				System.out.println("SerialConnection: Error: Timing out while waiting for serial to come online.");
				System.exit(0);
			}
		}
	}
	boolean failedToSend = false;

	public Boolean sendData(byte[] buffer) {
		waitForSerialConnected();
		try {
			boolean result = serialPort.writeBytes(buffer);
			if(!result){
				if(!failedToSend){
					failedToSend = true;
					System.out.println("SerialConnection: Unable to send "+buffer.length+ " bytes.");
				}
			}else{
				if(failedToSend){
					System.out.println("SerialConnection: Device recovered.");
					failedToSend = false;
				}
			}
			return result;
		} catch (SerialPortException e) {
			//DATC.printStackTrace(e);
			e.printStackTrace();
		}
		return false;
	}
	
	public byte[] readDataBlock() throws IOException {
		waitForSerialConnected();
		try {
			return serialPort.readBytes();
		} catch (SerialPortException e) {
			e.printStackTrace();
			System.exit(0);
		}
		return null;
	}

	public void closeConnection() throws IOException {
		System.out.println("ULLC SerialConnection: Warning: closeConnection() not implemented!");
	}


	
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
