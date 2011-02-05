package net.infinite_labs.here;

import org.json.JSONException;
import org.json.JSONObject;
import org.restlet.resource.Get;

public class ServicesListResource extends Here.Resource {
	@Get("json")
	public String JSONString() throws JSONException {
		JSONObject json = new JSONObject();
		
		for (Service s : app().servicesMap().services()) {
			json.put(s.name(), "~~");
		}
		
		return json.toString();
	}
}
