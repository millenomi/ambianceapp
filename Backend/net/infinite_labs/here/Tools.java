package net.infinite_labs.here;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class Tools {
	private Tools() {}
	
	private static final String RFC2822Pattern = "EEE, dd MMM yyyy HH:mm:ss Z";
	
	public static String RFC2822StringForDate(Date d) {
		if (d == null)
			return null;
		
		SimpleDateFormat formatter = new SimpleDateFormat(RFC2822Pattern, Locale.ROOT);
		return formatter.format(d);
	}
}
