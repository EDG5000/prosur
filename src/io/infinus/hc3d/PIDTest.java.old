package io.infinus.hc3d;

public class PIDTest {
	final static double TARGET = 50;
	final static double DT = 1; // Not relevant in this case since timing will be consistent
	static double output;
	static double actual = 20; // Initial actual temp
	
	final static double P = -.03;
	final static double I = -.03;
	final static double D = -.03;
	
	// Temperature delta simulation gain
	final static double GAIN = .05;
	
	public static void main(String[] args) {
		/*PID pid = new PID(1, 1, 1);
		pid.setOutputLimits(0, 1);
		pid.setDirection(false);
		pid.setSetpointRange(100);
		pid.setSetpoint(TARGET);*/
		
		System.err.printf("Target\tActual\tOutput\tError\n");
		
		// Position based test code
		for (int i = 0; i < 10*60*60; i++){ // 1 Hr at 1 Hz
			actual = getActual();
			
			output = getOutput(actual, TARGET);
			
			System.err.printf("%d\t%3.2f\t%3.2f\t%3.9f\t%3.2f\n", i+1, TARGET, actual, output, (TARGET-actual));
		}	
	}
	
	static double integral = 0;
	static double derrivative = 0;
	static double previousError = 0;
	static double getOutput(double pActual, double pTarget){
		
		// HC temp PID control
		// Based on Temp1
		// Currently only controlling HE_IN fan
		double error = pTarget - pActual;
		integral += error * DT;
		derrivative = (error - previousError) / DT;
		output = P * error + I * integral + D * derrivative;
		previousError = error;
		if(output < 0) output = 0;
		if(output > 1) output = 1;
		return output;
		// TODO min/max, anti windup
	}
	
	static double getActual() {
		// Mutate "actual" temp; simulate effect of cooler "output" of chamber temp
		// Delta Actual		Output
		// -1 * delta gain	1
		// 					.1
		double deltaTemp = (.5 - output) * GAIN;
		// Apply delta demp
		actual += deltaTemp;
		return actual;
	}
}
