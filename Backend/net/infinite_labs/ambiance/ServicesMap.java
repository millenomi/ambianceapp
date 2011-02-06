package net.infinite_labs.ambiance;

public interface ServicesMap {
	// all methods and all returned objects must be thread-safe
	Service serviceNamed(String name);
	Iterable<? extends Service> services();
	
	Client clientNamed(String name);
	Iterable<? extends Client> client();
}
