package net.infinite_labs.here.ram;

import net.infinite_labs.here.Client;

public class InMemoryClient implements Client {

	private String name;
	
	public InMemoryClient(String name) {
		this.name = name;
	}

	@Override
	public String name() {
		return name;
	}

}
