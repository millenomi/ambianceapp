package net.infinite_labs.here.ram;

import java.util.Date;
import java.util.Iterator;

import javax.management.RuntimeErrorException;

import org.json.JSONException;
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
		return cloneJSONObject(state);
	}

	@SuppressWarnings("unchecked")
	private JSONObject cloneJSONObject(JSONObject x) {
		JSONObject o = new JSONObject();
		Iterator<String> i = (Iterator<String>) x.keys();
		while (i.hasNext()) {
			String key = i.next();
			try {
				o.put(key, x.get(key));
			} catch (JSONException e) {
				throw new RuntimeException(e); // should never have happened.
			}
		}
		
		return o;
	}

	@Override
	public synchronized void setState(JSONObject state) {
		this.state = cloneJSONObject(state);
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
