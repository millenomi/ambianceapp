package net.infinite_labs.here;

import org.restlet.Application;
import org.restlet.Restlet;
import org.restlet.data.MediaType;
import org.restlet.data.Status;
import org.restlet.representation.Representation;
import org.restlet.representation.StringRepresentation;
import org.restlet.resource.ServerResource;
import org.restlet.routing.Router;

public class Here extends Application {

	public static abstract class Resource extends ServerResource {
		protected Here app() {
			return (Here) getApplication();
		}

		protected Representation badRequest(String string) {
			setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
			return new StringRepresentation(string, MediaType.TEXT_PLAIN);
		}
	}
	
	private ServicesMap servicesMap;

	@Override
	public Restlet createInboundRoot() {
		Router router = new Router(getContext());
		
		router.attach("/services", ServicesListResource.class);
		router.attach(ServiceStateResource.PathTemplate, ServiceStateResource.class);
		router.attach(TakeoverStateResource.PathTemplate, TakeoverStateResource.class);
		
		return router;
	}
	
	
	public ServicesMap servicesMap() {
		return servicesMap;
	}
	
	public Here(ServicesMap sm) {
		servicesMap = sm;
	}
	
}
