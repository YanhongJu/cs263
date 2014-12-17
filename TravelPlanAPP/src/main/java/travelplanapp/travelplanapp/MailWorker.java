package travelplanapp.travelplanapp;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

/**
 * MailWorker is a class in charge of sending email to user according to the
 * dispatched task.
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */

@Path("/mailworker")
public class MailWorker {

	/**
	 * Consumes a HttpRequest with information about userName, flight
	 * title,flight name and address. Send email to the user with the flight
	 * information.
	 *
	 * @param request
	 *            HttpResponse to be processed
	 * @return JSON String containing image imageUrl and Blobkey
	 * @since 1.0
	 */

	@POST
	@Path("/mail")
	public void sendEmail(@Context HttpServletRequest request)
			throws UnsupportedEncodingException {
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		String msgBody = "Dear Customer,\n\n We are sending you this email to remind you that you have flight."
				+ "\nThe flight is: "
				+ request.getParameter("title")
				+ "\nFlight time: "
				+ request.getParameter("notes")
				+ "\n"
				+ "\nAddress: "
				+ request.getParameter("address")
				+ "\n\n"
				+ "Thank you!";
		String userName = request.getParameter("userName");

		try {
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress("juyanhong@gmail.com",
					"TripPlan.com"));
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
					userName, "Customer"));
			msg.setSubject("Flight Reminder");
			msg.setText(msgBody);
			Transport.send(msg);

		} catch (AddressException e) {
			// ...
		} catch (MessagingException e) {
			// ...
		}

	}
}
