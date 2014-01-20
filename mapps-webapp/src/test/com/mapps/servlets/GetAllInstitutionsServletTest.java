package com.mapps.servlets;

import junit.framework.Assert;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mapps.model.Institution;
import com.mapps.model.User;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;
import com.mapps.servlets.stubs.GetAllInstitutionsServletStub;

import static org.mockito.Mockito.when;

/**
 *
 *
 */
public class GetAllInstitutionsServletTest {
    private GetAllInstitutionsServletStub servlet;

    @Before
    public void setUp() throws Exception{
        InstitutionService iService = Mockito.mock(InstitutionService.class);
        List<Institution> institutions = Lists.newArrayList();
        institutions.add(new Institution("CPC","", ""));
        institutions.add(new Institution("SPC","", ""));
        when(iService.allInstitutions()).thenReturn(institutions);
        UserService userService = Mockito.mock(UserService.class);
        User user = Mockito.mock(User.class);
        when(userService.getUserOfToken("token")).thenReturn(user);
        servlet = new GetAllInstitutionsServletStub();
        servlet.setInstitutionService(iService);
        servlet.setUserService(userService);
    }

    @Test
    public void testDoGet() throws Exception{
        HttpSession session = Mockito.mock(HttpSession.class);
        HttpServletResponse resp = Mockito.mock(HttpServletResponse.class);
        HttpServletRequest req = Mockito.mock(HttpServletRequest.class);
        File file = new File("src/test/resources/inst.json");
        PrintWriter writer = new PrintWriter(new FileWriter(file));
        when(resp.getWriter()).thenReturn(writer);
        when(req.getSession()).thenReturn(session);
        when(req.getParameter("token")).thenReturn("token");

        servlet.doGet(req, resp);

        BufferedReader br = new BufferedReader(new FileReader(file));
        String json = br.readLine();
        List<Institution> inst = new Gson().fromJson(json, new TypeToken<List<Institution>>() {
        }.getType());
        Assert.assertEquals(inst.size(), 2);
        Assert.assertEquals(inst.get(0).getName(), "CPC");
        Assert.assertEquals(inst.get(1).getName(), "SPC");
        br.close();
        file.delete();
    }
}
