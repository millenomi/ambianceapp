package net.infinite_labs.ambiance;

import org.json.JSONException;
import org.json.JSONObject;
import org.restlet.representation.Representation;
import org.restlet.resource.Get;
import org.restlet.resource.Post;
import org.restlet.resource.Put;
import org.restlet.resource.ResourceException;

import net.infinite_labs.ambiance.Here;

public class ServiceStateResource extends Here.Resource {
	public static JSONObject stateOfService(final Service s) throws JSONException {
		final JSONObject o = new JSONObject();
		
		s.exclusivelyRun(new Code() {
			@Override
			public void run() throws Exception {
				o.put("stateTimestamp", Tools.RFC2822StringForDate(s.stateTimestamp()));
				o.put("state", s.state());
				o.put("takingOverClient", s.takingOverClient() != null? s.takingOverClient().name() : null);
				o.put("takeoverTimestamp", Tools.RFC2822StringForDate(s.takeoverTimestamp()));
			}
		});
		
		return o;
	}
	
	public static final String PathTemplate = "/services/{name}";
	
	public static String pathWithService(Service s) {
		return PathTemplate
			.replace("{name}", s.name()); // TODO encoding
	}

	private String name;
	
	@Override
	protected void doInit() throws ResourceException {
		super.doInit();
		this.name = (String) getRequestAttributes().get("name");
	}


	@Get("json")
	public String toJSON() throws Exception {
		return stateOfService(app().servicesMap().serviceNamed(name)).toString();
	}
	
	@Post
	@Put
	public Representation fromJSON(Representation json) throws Exception {
		if (json.getSize() == Representation.UNKNOWN_SIZE || json.getSize() > 1024 * 1024) {
			return badRequest("Resource too large or with unknown size");
		}
		
		String jsonString = json.getText();
		
		JSONObject o = new JSONObject(jsonString);
		
		Service s = app().servicesMap().serviceNamed(name);
		s.setState(o);
		
		redirectSeeOther(this.getReference());
		return null;
	}
}
