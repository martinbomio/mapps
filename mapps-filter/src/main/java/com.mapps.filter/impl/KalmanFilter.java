package com.mapps.filter.impl;

import java.util.ArrayList;
import java.util.List;

import org.ejml.simple.SimpleMatrix;

import com.mapps.filter.Filter;
import com.mapps.model.Device;
import com.mapps.model.GPSData;
import com.mapps.model.IMUData;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;

/**
 *
 *
 */
public class KalmanFilter implements Filter{
    private Device device;
    private RawDataUnit rawData;
    private SimpleMatrix A;
    private SimpleMatrix B;
    private SimpleMatrix C;
    private SimpleMatrix Q;
    private SimpleMatrix R;
    private SimpleMatrix Rgi;
    private List<SimpleMatrix> xPost;
    private SimpleMatrix pPost;
    private List<ProcessedDataUnit> processedData;

    private static double [] latitude0 = new double [3];		// DD-mm-ssss
    private static double [] longitude0 = new double [3];		// DD-mm-ssss

    private static final double DT = 0.1;
    private static final int ACCEL_RANGE = 8192;
    private static final int YPR_RANGE = 100;


    @Override
    public void initData(Training training, Device device) {
        latitude0 = parseCoordinates(training.getLatOrigin());
        longitude0 = parseCoordinates(training.getLongOrigin());
        this.device = device;
    }

    @Override
    public void setRawData(RawDataUnit rawData) {
        this.A = new SimpleMatrix(matrizA(DT));
        this.B = new SimpleMatrix(matrizB(DT));
        this.rawData = rawData;
    }

    @Override
    public void process(){
        GPSData gpsData = null;
        boolean isGPSData = false;
        for(IMUData imuData : rawData.getImuData()){
            if(gpsData == null){
                isGPSData = true;
                gpsData = rawData.getGpsData().get(0);
                this.processedData = new ArrayList<ProcessedDataUnit>();
            }
            setVariableMatrices(isGPSData);

            SimpleMatrix matrixU = new SimpleMatrix(2, 1, false, new double[]{ imuData.getAccelX(), imuData.getAccelY()});

            // Time update equations
            SimpleMatrix xPre = this.A.mult(this.xPost.get(this.xPost.size()-1)).plus(this.B.mult(matrixU));
            SimpleMatrix pPre = this.A.mult(this.pPost).mult(this.A.transpose()).plus(this.Q);

            // Define Y vector
            double [] vectorY = transformCoordinateSystem(parseCoordinates(gpsData.getLatitude()),
                                                           parseCoordinates(gpsData.getLongitude()));
            SimpleMatrix y_aux = new SimpleMatrix(2,1,false,vectorY);
            SimpleMatrix matrixY = y_aux.minus(this.C.mult(xPre));

            // Kalman update equations
            SimpleMatrix aux = this.C.mult(pPre).mult(this.C.transpose()).plus(this.R);
            SimpleMatrix matrizK = pPre.mult(this.C.transpose()).mult(aux.invert());
            SimpleMatrix xPostMatrix = xPre.plus(matrizK.mult(matrixY));
            this.pPost = pPre.minus(matrizK.mult(this.C).mult(pPre));
            this.xPost.add(xPostMatrix);

            ProcessedDataUnit processedDataUnit = createProcessedDataFromXPost(xPostMatrix, imuData);
            this.processedData.add(processedDataUnit);
            isGPSData = false;
        }
    }

    private ProcessedDataUnit createProcessedDataFromXPost(SimpleMatrix xPost, IMUData imuData) {
        double posX = xPost.get(0,0);
        double posY = xPost.get(1,0);
        double velX = xPost.get(2,0);
        double velY = xPost.get(3,0);
        double accelX = ((double)imuData.getAccelX()) / ACCEL_RANGE;
        double accelY = ((double)imuData.getAccelY()) / ACCEL_RANGE;

        ProcessedDataUnit pData = new ProcessedDataUnit(posX,accelY,accelX,velY,velX,posY);
        return pData;
    }

    public void setUpInitialConditions(List<RawDataUnit> rawDataUnits){
        List<Double> aXList = new ArrayList<Double>();
        List<Double> aYList = new ArrayList<Double>();
        List<Double> gpsXList = new ArrayList<Double>();
        List<Double> gpsYList = new ArrayList<Double>();
        double[] cartesianCoordinates;
        double yaw = 0;
        for (RawDataUnit rawData : rawDataUnits){
            for(IMUData imuData : rawData.getImuData()){
                aXList.add(((double)imuData.getAccelX()) / ACCEL_RANGE);
                aYList.add(((double)imuData.getAccelY()) / ACCEL_RANGE);
                yaw = ((double)imuData.getYaw()) / YPR_RANGE;
            }
            GPSData gpsData = rawData.getGpsData().get(0);
            cartesianCoordinates = transformCoordinateSystem(parseCoordinates(gpsData.getLatitude()),
                                                             parseCoordinates(gpsData.getLongitude()));
            gpsXList.add(cartesianCoordinates[0]);
            gpsYList.add(cartesianCoordinates[1]);
        }
        Double[] axArray = aXList.toArray(new Double[aXList.size()]);
        Double[] ayArray = aYList.toArray(new Double[aYList.size()]);
        double[][] qMatrix = matrizQInitial(axArray, ayArray);
        this.Q = new SimpleMatrix(qMatrix);

        double[][] rMatrix = matrizRInitial(gpsXList.toArray(new Double[gpsXList.size()]), gpsYList.toArray(new Double[gpsYList.size()]));
        this.R = new SimpleMatrix(rMatrix);

        double[][] rgiMatrix = matrizRgi(yaw);
        this.Rgi = new SimpleMatrix(rgiMatrix);

        double[] xPostArray = new double[]{gpsXList.get(gpsXList.size()-1), gpsYList.get(gpsYList.size()-1) , 0,
                0, getMean(axArray), getMean(ayArray)};
        this.xPost = new ArrayList<SimpleMatrix>();
        this.xPost.add(new SimpleMatrix(xPostArray.length,1,false,xPostArray));
        this.pPost = SimpleMatrix.identity(6);
    }

    public List<ProcessedDataUnit> getResults(){
        return this.processedData;
    }

    private void setVariableMatrices(boolean isGpsData) {
        this.C = new SimpleMatrix(createMatrixC(isGpsData));
        this.R = this.R.scale(rawData.getGpsData().get(0).getHDOP());
    }

    private static double [] parseCoordinates(long origin){
        double [] coordinate = new double [3];
        String latitude = Long.toString(origin);
        coordinate[0] =  Double.parseDouble(latitude.substring(0, 2));
        coordinate[1] =  Double.parseDouble(latitude.substring(2, 4));
        coordinate[2] =  Double.parseDouble(latitude.substring(4));
        return coordinate;
    }

    private double[] transformCoordinateSystem(double[] latVector, double[] longVector){
        double[] coordenadas = new double[2];
        double deltaSecondsLatitude = ( latVector[0] - latitude0[0] ) * 3600 + ( latVector[1] - latitude0[1] ) *
                60 + latVector[2] / 100000 * 60 - latitude0[2];
        double deltaSecondsLongitude = ( longVector[0] - longitude0[0] ) * 3600 + ( longVector[1] - longitude0[1] ) *
                60 + longVector[2] / 100000 * 60 - longitude0[2] ;
        double theta = latVector[0] + latVector[1] / 60.0 + latVector[2] / 3600.0;
        double longitudeToMeters = ( 111412.88 * Math.cos(Math.toRadians(theta)) - 93.5 *
                Math.cos( 3 * Math.toRadians(theta)) + 0.12 * Math.cos(5 * Math.toRadians(theta)) ) / 3600.0;
        coordenadas[0] = - deltaSecondsLatitude * 30.9221;
        coordenadas[1] =  deltaSecondsLongitude * longitudeToMeters;
        return coordenadas;
    }

    private double [][] matrizA(double dt){
        double [][] matrizA = new double[6][6];
        for(int i=0; i<6; i++){
            for(int j=0; j<6; j++){
                matrizA[i][j] = 0;
                if(i == j){
                    matrizA[i][j] = 1;
                }
            }
        }
        matrizA[0][2] = dt;
        matrizA[1][3] = dt;
        matrizA[2][4] = -dt;
        matrizA[3][5] = -dt;
        matrizA[3][5] = -dt;
        matrizA[0][4] = -Math.pow(dt,2) / 2;
        matrizA[1][5] = -Math.pow(dt,2) / 2;
        return matrizA;
    }

    private double [][] matrizB(double dt){
        double [][] matrizB = new double[6][2];
        for(int i=0; i<6; i++){
            for(int j=0; j<2; j++){
                matrizB[i][j] = 0;
            }
        }
        matrizB[2][0] = dt;
        matrizB[3][1] = dt;
        matrizB[0][0] = Math.pow(dt,2) / 2;
        matrizB[1][1] = Math.pow(dt,2) / 2;
        return matrizB;
    }

    private double[][] createMatrixC(boolean hasGPS){
        if (hasGPS){
            return matrizC1();
        }else{
            return matrizC2();
        }

    }

    private double [][] matrizC1(){
        double [][] matrizC = new double[2][6];
        for(int i=0; i<2; i++){
            for(int j=0; j<6; j++){
                matrizC[i][j] = 0;
            }
        }
        matrizC[0][0] = 1;
        matrizC[1][1] = 1;
        return matrizC;
    }

    private double [][] matrizC2(){
        double [][] matrizC = new double[2][6];
        for(int i=0; i<2; i++){
            for(int j=0; j<6; j++){
                matrizC[i][j] = 0;
            }
        }
        return matrizC;
    }

    private static double [][] matrizRInitial(Double[] gpsXVector, Double[] gpsYVector){
        double [][] matrizR = new double[2][2];
        for(int i=0; i<2; i++){
            for(int j=0; j<2; j++){
                matrizR[i][j] = 0;
            }
        }
        matrizR[0][0] = getStdDev(gpsXVector);
        matrizR[1][1] = getStdDev(gpsYVector);
        //matrizR[0][0] = 0.2;
        //matrizR[1][1] = 0.2;
        return matrizR;
    }

    private double [][] matrizQInitial(Double[] Ax_vector, Double[] Ay_vector){
        double [][] matrizQ = new double[6][6];
        for(int i=0; i<6; i++){
            for(int j=0; j<6; j++){
                matrizQ[i][j] = 0;
            }
        }
        matrizQ[2][2] = getStdDev(Ax_vector);
        matrizQ[3][3] = getStdDev(Ay_vector);
        return matrizQ;
    }

    private static double [][] matrizRgi(double omega){
        double [][] matrizRgi = new double [2][2];
        matrizRgi[0][0] = Math.cos(Math.toRadians(omega));
        matrizRgi[0][1] = Math.sin(Math.toRadians(omega));
        matrizRgi[1][0] = -Math.sin(Math.toRadians(omega));
        matrizRgi[1][1] = Math.cos(Math.toRadians(omega));
        return matrizRgi;
    }

    private static double getMean(Double [] data){
        double sum = 0.0;
        for(int i = 0 ; i < data.length ; i ++){
            sum += data[i];
        }
        return sum/data.length;
    }

    private static double getVariance(Double [] data){
        double mean = getMean(data);
        double temp = 0;
        for(int i = 0 ; i < data.length ; i ++){
            temp += (mean-data[i])*(mean-data[i]);
        }
        return temp/data.length;
    }

    private static double getStdDev(Double [] data){
        return Math.sqrt(getVariance(data));
    }


}
