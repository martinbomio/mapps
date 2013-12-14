package com.mapps.receiver;

import com.mapps.receiver.exceptions.CouldNotInvokeServiceException;
import org.apache.log4j.Logger;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Properties;

/**
 * Invokes the resful receiver service on the server.
 */
public class ResfulServiceInvoker implements ServiceInvoker{
    Logger logger = Logger.getLogger(ResfulServiceInvoker.class);

    @Override
    public void invokeService(String packet) throws CouldNotInvokeServiceException{
        try{
            URL url = new URL(getServiceURL());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "text/plain");

            OutputStream os = conn.getOutputStream();
            os.write(packet.getBytes());
            os.flush();

            int a = conn.getResponseCode();
            if (conn.getResponseCode() != HttpURLConnection.HTTP_NO_CONTENT){
                logger.error("Could not invoke service.");
               throw  new CouldNotInvokeServiceException();
            }
        } catch (MalformedURLException e) {
            logger.error(e);
            throw  new CouldNotInvokeServiceException();
        } catch (IOException e) {
            logger.error(e);
            throw  new CouldNotInvokeServiceException();
        }
    }

    private String getServiceURL(){
        String url = null;
        try{
            Properties defaultProps = new Properties();
            defaultProps.load(getClass().getClassLoader().getResourceAsStream("config.properties"));
            url = defaultProps.getProperty("service.url");
        } catch (FileNotFoundException e) {
            logger.error(e);
        } catch (IOException e) {
            logger.error(e);
        }
        return url;
    }
}
