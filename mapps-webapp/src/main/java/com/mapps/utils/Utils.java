package com.mapps.utils;

import java.io.File;
import java.net.URI;
import java.net.URISyntaxException;
import javax.servlet.http.Part;

/**
 *
 *
 */
public class Utils {
    /**
     * Utility method to get file name from HTTP header content-disposition
     */
    public static String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        System.out.println("content-disposition header= " + contentDisp);
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    public static URI getFileURI(String identifier, String dir, String extension) {
        try {
            return new URI(File.separator + "mapps" + File.separator + dir + File.separator + identifier + "." + extension);
        } catch (URISyntaxException e) {
            throw new IllegalStateException();
        }
    }
}
