package test1.test1;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/jerseyws")
public class RestTest {

	@GET
	@Path("/test1")
	public String testMethod() {
		return "this is a test";
	}
}
