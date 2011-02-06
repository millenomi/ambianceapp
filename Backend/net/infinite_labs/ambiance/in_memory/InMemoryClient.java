package net.infinite_labs.ambiance.in_memory;

import net.infinite_labs.ambiance.Client;

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
