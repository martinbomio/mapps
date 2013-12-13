package com.mapps.receiver;

import junit.framework.Assert;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.junit.Test;

/**
 * Tests the receiver ResfulService
 */
public class TestsResfulService {

    @Test
    public void testService() throws Exception {
        URL url = new URL("http://localhost:8080/mapps/receiver/receive-data/");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "text/plain");

        String input = "40813E2B@G:345255776/560287680/8/118:100,I:-4748/194/-90/156/-70/4561:-4748/194/-90/157/-71/4559:," +
                "I:-4747/194/-90/156/-63/4542:-4747/194/-89/161/-79/4559:," +
                "I:-4746/194/-90/160/-77/4566:-4745/194/-90/153/-67/4554:," +
                "I:-4745/194/-90/162/-73/4556:-4744/194/-89/160/-72/4551:";

        OutputStream os = conn.getOutputStream();
        os.write(input.getBytes());
        os.flush();

        int a = conn.getResponseCode();
        if (conn.getResponseCode() != HttpURLConnection.HTTP_NO_CONTENT){
            Assert.fail();
        }
        Assert.assertTrue(true);
    }
}
