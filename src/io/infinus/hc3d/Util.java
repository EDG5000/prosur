package io.infinus.hc3d;

import java.time.LocalDateTime;

public class Util {
	public static String getDateString() {
		LocalDateTime dateTime = LocalDateTime.now();
		String readableString = dateTime.toString();
		return readableString;
		//System.out.println(readableString);
		//LocalDateTime parsedBack = LocalDateTime.parse(readableString);
		//System.out.println(parsedBack);
	}
}
