package net.infinite_labs.ambiance.in_memory;

import java.util.HashSet;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import net.infinite_labs.ambiance.Client;
import net.infinite_labs.ambiance.Service;
import net.infinite_labs.ambiance.ServicesMap;

public class InMemoryServicesMap implements ServicesMap {

	Map<String, InMemoryService> servicesMap = new ConcurrentHashMap<String, InMemoryService>();
	Map<String, InMemoryClient> clientsMap = new ConcurrentHashMap<String, InMemoryClient>();
	
	@Override
	public Service serviceNamed(String name) {
		InMemoryService s = servicesMap.get(name);
		
		if (s == null) {
			s = new InMemoryService(name);
			servicesMap.put(name, s);
		}
		
		return s;
	}

	@Override
	public synchronized Iterable<Service> services() {
		return new HashSet<Service>(servicesMap.values());
	}

	@Override
	public Client clientNamed(String name) {
		InMemoryClient s = clientsMap.get(name);
		
		if (s == null) {
			s = new InMemoryClient(name);
			clientsMap.put(name, s);
		}
		
		return s;
	}

	@Override
	public Iterable<? extends Client> client() {
		return new HashSet<Client>(clientsMap.values());
	}
	
}
