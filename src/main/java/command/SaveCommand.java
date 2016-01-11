package command;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import util.ContactUtil;
import util.GeneralUtil;
import persistence.model.Contact;
import persistence.model.Phone;
import service.ContactService;
import service.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

import java.util.Collection;
import java.util.List;
import java.util.Properties;

import static org.apache.commons.io.filefilter.TrueFileFilter.TRUE;

public class SaveCommand implements ActionCommand {
    private ContactService contactService = ServiceFactory.getContactService();
    private HttpServletRequest request;
    private long idContact;
    private HttpSession session;

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        this.request = request;
        session = request.getSession();
        Contact contact = ContactUtil.makeContact(request);
        idContact = contactService.setContact(contact);
        savePhones();

        String path =  getAvatar();
        if(path != null) {
            //Проверим была ли ава у контакта и если была, то удаляем ее
            checkAvaExist();
        }
        contactService.setPhoto(idContact,path);
        return "/controller?command=show";
    }

    private void savePhones() {
        List<Phone> phones = ContactUtil.getPhones(request, idContact);
        contactService.savePhones(idContact, phones);
    }

    private void checkAvaExist() {
        String path = contactService.getPhoto(idContact);
        if ( path != null ) {
            GeneralUtil.deleteOnPath(path);
        }
    }

    private String getAvatar() throws IOException, ServletException {
        String savePath = getSavePath(idContact);
        File fileSaveDir = new File(savePath);

        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        Part filePart = request.getPart("avatar");
        System.out.println("size"+filePart.getSize());
        if(filePart.getSize()>0){
            savePath += File.separator + idContact + GeneralUtil.extractFileExtension(filePart);
            filePart.write(savePath);
        } else {
            String temp_path = (String)session.getAttribute("temp_path_avatar");
            System.out.println(temp_path);
            if( temp_path != null){
                session.removeAttribute("temp_path_avatar");
                File temp_avatar = new File(temp_path);
                // temp_avatar.renameTo(new_name);
                FileUtils.moveFileToDirectory(temp_avatar,fileSaveDir,true);
                savePath += File.separator + temp_avatar.getName();
                //GeneralUtil.renameFile(idContact,temp_avatar);
            }

            /**File dir = new  File(temp_path);
            List<File> files = (List<File>) FileUtils.listFiles(dir, TrueFileFilter.INSTANCE, TrueFileFilter.INSTANCE);
            for(File avatar: files)  {
                System.out.println("2:"+ FileUtils.getUserDirectoryPath());
                System.out.println(avatar.getName());
            } **/
        }
        return savePath;
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
