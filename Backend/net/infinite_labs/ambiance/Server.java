package net.infinite_labs.ambiance;

import net.infinite_labs.ambiance.in_memory.InMemoryServicesMap;

import org.restlet.Component;
import org.restlet.Context;
import org.restlet.data.Protocol;

public class Server {
	public static void main(String[] args) throws Exception {
		Here app = new Here(new InMemoryServicesMap());
		
		Component c = new Component();
		
		c.getServers().add(Protocol.HTTP, 8008);
		
		c.setContext(new Context());
		c.getDefaultHost().attach(app);
		
		c.start();
	}
}
