package com.mapps.services.kalman.stub;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.mapps.exceptions.NullParameterException;
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

    private void save(List<ProcessedDataUnit> processedDataUnits, boolean append) {
        try{
            PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("src/test/resources/testdata/output.csv",append)));
            for (ProcessedDataUnit processed : processedDataUnits){
                String line = processed.getAccelerationX() + "\t" + processed.getAccelerationY() + "\t" +
                        processed.getVelocityX() + "\t" + processed.getVelocityY() + "\t" + processed.getAccelerationX()
                        + "\t" + processed.getAccelerationY();
                out.println(line);
            }
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
