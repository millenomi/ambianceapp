package net.infinite_labs.here.ram;

import java.util.Date;

import org.json.JSONObject;

import net.infinite_labs.here.Client;
import net.infinite_labs.here.Code;
import net.infinite_labs.here.Service;

public class InMemoryService implements Service {

	private String name;
	private JSONObject state = new JSONObject();
	private Date stateTimestamp = new Date();
	
	private Client takingOverClient;
	private Date takeoverTimestamp = new Date();
	
	public InMemoryService(String name) {
		this.name = name;
	}

	@Override
	public String name() {
		return name;
	}

	@Override
	public synchronized JSONObject state() {
		return new JSONObject(state);
	}

	@Override
	public synchronized void setState(JSONObject state) {
		this.state = new JSONObject(state);
		this.stateTimestamp = new Date();
	}

	@Override
	public synchronized Date stateTimestamp() {
		return stateTimestamp;
	}

	@Override
	public synchronized void setTakingOverClient(Client cli) {
		takingOverClient = cli;
		takeoverTimestamp = new Date();
	}

	@Override
	public synchronized Client takingOverClient() {
		return takingOverClient;
	}

	@Override
	public synchronized Date takeoverTimestamp() {
		return takeoverTimestamp;
	}

	@Override
	public void exclusivelyRun(Code r) {
		synchronized(this) {
			try {
				r.run();
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}

}
