package io.infinus.hc3d;

import java.io.File;
import java.net.URISyntaxException;
import java.security.CodeSource;


public class Util {
	public static String getApplicationFolder() {
		CodeSource codeSource = Main.class.getProtectionDomain().getCodeSource();
		File jarFile;
		try {
			jarFile = new File(codeSource.getLocation().toURI().getPath());
			String jarDir = jarFile.getParentFile().getPath();
			return jarDir;
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
		return null;
	}
}
