package net.infinite_labs.here;

import java.util.Date;
import org.json.JSONObject;

public interface Service {
	// all methods must be thread-safe.
	String name();
	
	// the caller must not modify a JSON object returned by, or passed to, a Service.
	JSONObject state();
	void setState(JSONObject state);
	
	Date stateTimestamp();
	
	void setTakingOverClient(Client cli);
	Client takingOverClient();
	Date takeoverTimestamp();
	
	// transaction support
	void exclusivelyRun(Code r);
}
