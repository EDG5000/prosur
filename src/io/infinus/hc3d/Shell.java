package io.infinus.hc3d;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;

public class Shell {

    
    public static String shellCommandGetOutput(String cmd){
    	return shellCommandGetOutput(cmd, null);
    }
    
 // TODO consider suffixing "2>&1 | tee output" to merge output streams and prevent stderr to get lost
    public static boolean runShellCommand(String cmd, File dir) {
    	StringBuilder s = new StringBuilder();
    	try {
    		String line;
	    	Process p = null;
	    	BufferedReader stdInput;
	    	String[] rawcmd = {
	    			"/bin/sh",
	    			"-c",
	    			cmd
	    			};
	    	p = new ProcessBuilder(Arrays.asList(rawcmd)).redirectErrorStream(true).directory(dir).start();
			stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
			while((line = stdInput.readLine()) != null){
				Main.log(line);
			    s.append(line);
			    s.append('\n');
			}
			return p.waitFor() == 0;
    	} catch (IOException e) {
			Main.printStackTrace(e);
			return false;
		} catch (InterruptedException e) {
			Main.printStackTrace(e);
			return false;
		}
    }
    
 // TODO consider suffixing "2>&1 | tee output" to merge output streams and prevent stderr to get lost
    public static String shellCommandGetOutput(String cmd, File dir){
    	StringBuilder s = new StringBuilder();
    	try {
    		String line;
	    	Process p = null;
	    	BufferedReader stdInput;
	    	String[] rawcmd = {
	    			"/bin/sh",
	    			"-c",
	    			cmd
	    			};
	    	p = new ProcessBuilder(Arrays.asList(rawcmd)).redirectErrorStream(true).directory(dir).start();
			stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
			while((line = stdInput.readLine()) != null){
			    s.append(line);
			    s.append('\n');
			}
			if(p.waitFor() != 0){
				return null;
			}
    	} catch (IOException e) {
			Main.printStackTrace(e);
		} catch (InterruptedException e) {
			Main.printStackTrace(e);
		}
    		
    	return s.toString();
    }
}