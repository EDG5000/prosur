package io.infinus.hc3d;

import java.io.IOException;
import java.util.prefs.BackingStoreException;

public class Param {
	float value;
	String name;
	public Param(String pName) {
		name = pName;
		value = Float.valueOf(Main.prefs.node("main").getFloat(name, -1));
	}
	
	public float getValue() {
		return value;
	}
	
	public String getName() {
		return name;
	}
	
	public void setValue(float pValue) {
		value = pValue;
		Main.prefs.node("main").put(name, "" + value);
		Main.prefsDirty = true;
	}
}
