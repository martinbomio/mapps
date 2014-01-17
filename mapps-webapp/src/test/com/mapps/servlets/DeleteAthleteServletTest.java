package com.mapps.servlets;

import junit.framework.Assert;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.mapps.model.Athlete;
import com.mapps.services.trainer.TrainerService;
import com.mapps.servlets.stubs.DeleteAthleteServletStub;

import static org.mockito.Mockito.when;

/**
 *
 *
 */
public class DeleteAthleteServletTest {
    private DeleteAthleteServletStub servlet;
    private HttpServletRequest req;

    @Before
    public void setUp() throws Exception {
        TrainerService trainerService = Mockito.mock(TrainerService.class);
        Athlete athlete = Mockito.mock(Athlete.class);
        when(trainerService.getAthleteByIdDocument("4.447.599-3")).thenReturn(athlete);
        req = Mockito.mock(HttpServletRequest.class);
        HttpSession session = Mockito.mock(HttpSession.class);
        when(session.getAttribute("token")).thenReturn("validToken");
        when(req.getSession()).thenReturn(session);
        servlet = new DeleteAthleteServletStub();
        servlet.setTrainerService(trainerService);
    }

    @Test
    public void testDoPost() throws Exception {
        HttpServletResponse resp = Mockito.mock(HttpServletResponse.class);
        File file = new File("src/test/resources/resp");
        PrintWriter writer = new PrintWriter(new FileWriter(file));
        when(resp.getWriter()).thenReturn(writer);
        when(req.getParameter("json")).thenReturn(getJson());
        servlet.doPost(req, resp);
        writer.close();
        BufferedReader br = new BufferedReader(new FileReader(file));
        Assert.assertTrue(br.readLine() == null);
        br.close();
        file.delete();
    }

    public String getJson() throws Exception{
        File file = new File("src/test/resources/json/ath.json");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line = br.readLine();
        br.close();
        return line;
    }
}
