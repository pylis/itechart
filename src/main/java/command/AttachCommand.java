package command;


import command.exception.CommandException;
import command.util.ContactUtil;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Properties;

public class AttachCommand implements ActionCommand {
    private Logger logger = LogManager.getLogger(AttachCommand.class);
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        Properties properties = new Properties();
        try {
            properties.load(AvatarCommand.class.getResourceAsStream("/attach.properties"));
        } catch (IOException e) {
            throw  new CommandException("Error while getting attachment",e);
        }

        //Getting ID of contact
        String temp = request.getParameter("idContact");
        String[] chosen = request.getParameterValues("marked");
        Long idContact = ContactUtil.findOutIdContact(temp,chosen);

        String fileName = request.getParameter("name");
        if(idContact == null || fileName == null) {
            return null;
        }

        String savePath = properties.getProperty("SAVE_ATTACH_PATH");
        savePath += File.separator + idContact + File.separator + fileName;
        File file = new File(savePath);
        if(! file.exists()) {
            return null;
        }
        int buffSize = Integer.parseInt(properties.getProperty("BUFFER_SIZE"));

        response.reset();
        response.setBufferSize(buffSize);
        response.setContentType(properties.getProperty("CONTENT_TYPE"));
        response.setHeader("Content-Length", String.valueOf(file.length()));
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

        try (OutputStream out = response.getOutputStream();
             FileInputStream in = new FileInputStream(file)) {
            byte[] buffer = new byte[buffSize];
            int length;
            while ((length = in.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
        } catch (IOException e) {
            throw  new CommandException("Error while getting attachment",e);
        }

        logger.info("Downloading attachment");
        //The response is already made. It includes attachment. Therefore we returned null
        return null;
    }
}
