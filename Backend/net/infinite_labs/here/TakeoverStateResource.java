package net.infinite_labs.here;

import org.json.JSONObject;
import org.restlet.data.Form;
import org.restlet.representation.Representation;
import org.restlet.resource.Get;
import org.restlet.resource.Post;
import org.restlet.resource.ResourceException;

public class TakeoverStateResource extends Here.Resource {
	public static final String PathTemplate = "/services/{name}/takeover";
	
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
		Service s = app().servicesMap().serviceNamed(name);
		
		JSONObject o = new JSONObject();
		o.put("takingOverClient", s.takingOverClient() != null? s.takingOverClient().name() : null);
		o.put("takeoverTimestamp", Tools.RFC2822StringForDate(s.takeoverTimestamp()));
		
		return o.toString();
	}
	
	@Post
	public Representation takeover(Representation entity) throws Exception {
		Form f = getReference().getQueryAsForm();
		
		final String clientName = f.getFirstValue("clientName");
		if (clientName == null)
			return badRequest("clientName not specified");
		
		final Service s = app().servicesMap().serviceNamed(name);
		s.exclusivelyRun(new Code() {
			@Override
			public void run() throws Exception {
				s.setTakingOverClient(app().servicesMap().clientNamed(clientName));
			}
		});
		
		redirectSeeOther(ServiceStateResource.pathWithService(s));
		return null;
	}
}
