package command;

import command.exception.CommandException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import service.ContactService;
import service.ServiceFactory;
import util.EmailUtil;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailCommand implements ActionCommand{
    private Logger logger = LogManager.getLogger(EmailCommand.class);

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String address = request.getParameter("address");
        String subject = request.getParameter("subject");
        String text = request.getParameter("text");

        Properties properties = new Properties();
        try {
            properties.load(EmailCommand.class.getResourceAsStream("/email.properties"));
            String sender = properties.getProperty("mail.user.name");

            Session session = Session.getDefaultInstance(properties,
                    new javax.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(sender, properties.getProperty("mail.user.password"));
                        }
                    });

            EmailUtil.sendEmail(address, subject, text, properties, sender, session);
        } catch (IOException e) {
            throw new CommandException("Error while sending email", e);
        }
        request.setAttribute("message","Message is successfully sent");
        logger.info("Sending email:"+address);
        return "/controller?command=show";
    }


}
