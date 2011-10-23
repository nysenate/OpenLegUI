package gov.nysenate.openlegislation;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TestServlet extends HttpServlet {
	public void service(HttpServletRequest request, 
		     HttpServletResponse response)
		               throws ServletException, IOException {
		          PrintWriter writer = response.getWriter();
		          writer.println("Hello, World!");
		          writer.close();
		     }
}
