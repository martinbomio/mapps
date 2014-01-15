package com.mapps.servlets;

import junit.framework.Assert;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mapps.services.institution.InstitutionService;
import com.mapps.servlets.stubs.GetAllInstitutionsServletStub;

import static org.mockito.Mockito.when;

/**
 *
 *
 */
public class GetAllInstitutionsServletTest {
    private GetAllInstitutionsServletStub servlet;

    @Before
    public void setUp(){
        InstitutionService iService = Mockito.mock(InstitutionService.class);
        List<String> institutions = Lists.newArrayList();
        institutions.add("CPC");
        institutions.add("SPC");
        when(iService.allInstitutionsNames()).thenReturn(institutions);
        servlet = new GetAllInstitutionsServletStub();
        servlet.setInstitutionService(iService);
    }

    @Test
    public void testDoGet() throws Exception{
        HttpServletResponse resp = Mockito.mock(HttpServletResponse.class);
        HttpServletRequest req = Mockito.mock(HttpServletRequest.class);
        File file = new File("src/test/resources/inst.json");
        PrintWriter writer = new PrintWriter(new FileWriter(file));
        when(resp.getWriter()).thenReturn(writer);

        servlet.doGet(req, resp);

        BufferedReader br = new BufferedReader(new FileReader(file));
        String json = br.readLine();
        Map<String, String[]> inst = new Gson().fromJson(json, new TypeToken<Map<String, String[]>>(){}.getType());
        String[] array = inst.get("name");
        Assert.assertEquals(array.length, 2);
        Assert.assertEquals(array[0], "CPC");
        Assert.assertEquals(array[1], "SPC");
    }
}
