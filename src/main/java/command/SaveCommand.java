package command;

import command.exception.CommandException;
import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import persistence.model.Attach;
import command.util.ContactUtil;
import persistence.model.Contact;
import persistence.model.Phone;
import service.ContactService;
import service.ServiceFactory;
import util.MyFileUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

import java.util.*;


public class SaveCommand implements ActionCommand {
    private ContactService contactService = ServiceFactory.getContactService();
    private HttpServletRequest request;
    private long idContact;
    private HttpSession session;

    private Logger logger = LogManager.getLogger(SaveCommand.class);
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response)  {
        this.request = request;
        session = request.getSession();

        String mode = request.getParameter("mode");
        Contact contact = ContactUtil.makeContact(request);
        idContact = contactService.setContact(contact);
        savePhones();

        try {
            saveAttaches();
            saveAvatar();
        } catch (IOException | ServletException e) {
            throw new CommandException("Error while saving contact", e);
        }

        logger.info("Saving contact with full name:"+contact.getFullName());

        return "/controller?command=show";
    }

    private void savePhones() {
        List<Phone> phones = ContactUtil.getPhones(request, idContact);
        contactService.savePhones(idContact, phones);
    }

    private void saveAttaches() throws IOException {
        List<Attach> attaches = (List<Attach>) session.getAttribute("attaches");
        session.removeAttribute("attaches");
        contactService.saveAttaches(idContact, attaches);
    }

    private void saveAvatar() throws IOException, ServletException {
        String savePath = getSavePath(idContact);
        File fileSaveDir = new File(savePath);

        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        Part filePart = request.getPart("avatar");
        if(filePart.getSize()>0) {
            savePath += File.separator + idContact + MyFileUtil.extractFileExtension(filePart);
            filePart.write(savePath);
        } else {
            String tempPath = (String)session.getAttribute("temp_path_avatar");
            if( tempPath != null) {
                session.removeAttribute("temp_path_avatar");
                File tempAvatar = new File(tempPath);
                FileUtils.moveFileToDirectory(tempAvatar,fileSaveDir,true);
                savePath += File.separator + tempAvatar.getName();
                System.out.println("In saveCommand avaSavePath:"+savePath);
            } else {
                //Check if photo exists
                String path = contactService.getPhoto(idContact);
                if(path == null) contactService.setPhoto(idContact,null);
                return;
            }
        }
        contactService.setPhoto(idContact,savePath);

    }

    private String getSavePath(long idContact) throws IOException {
        Properties properties = new Properties();
        properties.load(AvatarCommand.class.getResourceAsStream("/avatars.properties"));
        String path = properties.getProperty("SAVE_AVATARS_PATH");
        while(idContact != 0) {
            path += File.separator + idContact % 10;
            idContact /= 10;
        }
        return  path;
    }
}
