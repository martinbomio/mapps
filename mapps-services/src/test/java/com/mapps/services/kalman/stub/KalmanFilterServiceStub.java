package com.mapps.services.kalman.stub;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.mapps.exceptions.NullParameterException;
import com.mapps.model.KalmanState;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.persistence.KalmanStateDAO;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.services.kalman.impl.KalmanFilterService;

/**
 *
 *
 */
public class KalmanFilterServiceStub extends KalmanFilterService{
    public boolean multiple = false;
    public String output_URL = "src/test/resources/testdata/output.csv";

    public void setRawDataUnitDAO(RawDataUnitDAO rdao){
        this.rawDataUnitDAO = rdao;
    }

    public void setProcessedDataUnitDAO(ProcessedDataUnitDAO pdao){
        this.processedDataUnitDAO = pdao;
    }

    public void setKalmanStateDAO(KalmanStateDAO sDao){
        this.kalmanStateDAO = sDao;
    }

    @Override
    public void saveProcessedData(List<ProcessedDataUnit> processedDataUnits) throws NullParameterException {
        save(processedDataUnits, multiple);
    }

    @Override
    public void saveKalmanState(KalmanState state) throws NullParameterException {
        try {
            PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("src/test/resources/testdata/state.csv", true)));
            String row = createRow(state);
            out.println(row);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void save(List<ProcessedDataUnit> processedDataUnits, boolean append) {
        try{
            PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(output_URL,append)));
            for (ProcessedDataUnit processed : processedDataUnits){
                String line = processed.getAccelerationX() + "\t" + processed.getAccelerationY() + "\t" +
                        processed.getVelocityX() + "\t" + processed.getVelocityY() + "\t" + processed.getPositionX()
                        + "\t" + processed.getPositionY() + "\t" + processed.getElapsedTime();
                out.println(line);
            }
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String createRow(KalmanState state) {
        StringBuilder sb = new StringBuilder();
        sb.append(state.getaXBias());
        sb.append("\t");
        sb.append(state.getAyBias());
        sb.append("\t");
        sb.append(state.getGpsError());
        sb.append("\t");
        sb.append(state.getPreviousState());
        sb.append("\t");
        sb.append(state.getqMatrix());
        sb.append("\t");
        sb.append(state.getRgi());
        sb.append("\t");
        sb.append(state.getDate().getTime());
        sb.append("\t");
        sb.append(state.getInitialYaw());
        return sb.toString();
    }
}
