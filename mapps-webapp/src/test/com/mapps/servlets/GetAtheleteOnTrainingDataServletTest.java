package com.mapps.servlets;

import junit.framework.Assert;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.PulseData;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.services.report.ReportService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.servlets.stubs.GetAthleteOnTrainingDataServletStub;
import com.mapps.wrappers.AthleteStatsWrapper;

import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Test the servlet
 */
public class GetAtheleteOnTrainingDataServletTest {
    Athlete athlete;
    GetAthleteOnTrainingDataServletStub servlet;
    HttpServletRequest request;
    private List<ProcessedDataUnit> processedDataUnits;

    @Before
    public void setUp() throws Exception {
        ReportService reportService = Mockito.mock(ReportService.class);
        TrainerService tService = Mockito.mock(TrainerService.class);
        when(reportService.getAthleteStats("training", "1234", "validToken")).thenReturn(getProcessedDataUnits());
        when(tService.getAthleteByIdDocument("1234")).thenReturn(this.athlete);
        this.servlet = new GetAthleteOnTrainingDataServletStub();
        servlet.setReportService(reportService);
        servlet.setTrainerService(tService);
        this.request = Mockito.mock(HttpServletRequest.class);
        when(this.request.getParameter("t")).thenReturn("training");
        when(this.request.getParameter("id")).thenReturn("validToken");
        when(this.request.getParameter("a")).thenReturn("pepe-1234");
    }

    @Test
    public void testDoGet() throws Exception{
        HttpServletResponse response = Mockito.mock(HttpServletResponse.class);
        PrintWriter writer = new PrintWriter(new File("src/test/resources/stats.json"));
        when(response.getWriter()).thenReturn(writer);
        servlet.doGet(request, response);
        verify(response, times(1)).setContentType("application/json");
        verify(response, times(1)).getWriter();
        File file = new File("src/test/resources/stats.json");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String json = br.readLine();
        AthleteStatsWrapper wrapper = new Gson().fromJson(json, AthleteStatsWrapper.class);
        Assert.assertEquals(wrapper.toJson(), json);
        file.delete();
    }

    public List<ProcessedDataUnit> getProcessedDataUnits() {
        Institution institution = new Institution("CPC", "", "Uruguay");
        Device device = new Device("dirHigh", "dirLow", 1, institution);
        this.athlete = new Athlete("martin", "b", new Date(), Gender.MALE, "m@gmail.com", 1D, 1D, "aaa", institution);
        Map<Athlete, Device> map = new HashMap<Athlete, Device>();
        map.put(athlete, device);
        Training training = new Training("training", new Date(), 1, 0L, 0L, 1, 1, map, null, null, null, institution);
        List<PulseData> pulse = Lists.newArrayList();
        pulse.add(new PulseData(11));
        RawDataUnit rawData = new RawDataUnit(null, null, pulse, device, 1L, false, new Date(), training);
        List<ProcessedDataUnit> pDataUnits = Lists.newArrayList();
        for (int i = 0; i < 10; i++){
            ProcessedDataUnit pUnit = new ProcessedDataUnit(1D, 1D, 1D, 1D, 1D, 1D, device, rawData, new Date());
            pDataUnits.add(pUnit);
        }
        return pDataUnits;
    }
}
