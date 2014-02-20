package com.mapps.filter.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.ejml.simple.SimpleMatrix;

import com.mapps.filter.Filter;
import com.mapps.filter.impl.exceptions.InvalidCoordinatesException;
import com.mapps.filter.utils.Maths;
import com.mapps.filter.utils.MatrixToStringParser;
import com.mapps.model.Device;
import com.mapps.model.GPSData;
import com.mapps.model.IMUData;
import com.mapps.model.KalmanState;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;

/**
 *
 *
 */
public class KalmanFilter implements Filter {
    private Device device;
    private Training training;

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
    private boolean gpsCorrect;

    private double gpsError;

    private SimpleMatrix lastXpos;
    private KalmanState newState;
    private double initialYaw;

    private static double[] latitude0 = new double[3];        // DD-mm-ssss
    private static double[] longitude0 = new double[3];        // DD-mm-ssss

    private static final double DT = 0.1;
    private static final int ACCEL_RANGE = 8192;
    private static final int YPR_RANGE = 100;
    private static final int INITIAL_DATA_ERROR = 20;
    private static final int DATA_ERROR = 20;


    @Override
    public void initData(Training training, Device device) throws InvalidCoordinatesException {
        if (training.getLatOrigin() == 0 || training.getLongOrigin() == 0) {
            throw new InvalidCoordinatesException();
        }
        latitude0 = parseCoordinates(training.getLatOrigin());
        longitude0 = parseCoordinates(training.getLongOrigin());
        longitude0[2] /= 100;
        latitude0[2] /= 100;
        this.xPost = new ArrayList<SimpleMatrix>();
        this.device = device;
        this.training = training;
    }

    @Override
    public void setRawData(RawDataUnit rawData) {
        this.A = new SimpleMatrix(matrizA(DT));
        this.B = new SimpleMatrix(matrizB(DT));
        this.rawData = rawData;
        this.gpsCorrect = rawData.isCorrect();
    }

    @Override
    public void process() throws InvalidCoordinatesException {
        GPSData gpsData = null;
        boolean isGPSData = false;
        long time = rawData.getTimestamp();
        for (IMUData imuData : rawData.getImuData()) {
            if (gpsData == null) {
                isGPSData = true;
                gpsData = rawData.getGpsData().get(0);
                this.processedData = new ArrayList<ProcessedDataUnit>();
            }
            if (gpsData.getLatitude() == 0 || gpsData.getLatitude() == 0) {
                throw new InvalidCoordinatesException();
            }
            setVariableMatrices(isGPSData, rawData.getGpsData().get(0).getHDOP(), imuData.getYaw());
            double ax = (double) imuData.getAccelX() / ACCEL_RANGE;
            double ay = (double) imuData.getAccelY() / ACCEL_RANGE;
            SimpleMatrix matrixU = new SimpleMatrix(2, 1, false, new double[]{ax, ay});

            // Time update equations
            SimpleMatrix xPre = this.A.mult(this.lastXpos).plus(this.B.mult(this.Rgi.mult(matrixU)));
            SimpleMatrix pPre = this.A.mult(this.pPost).mult(this.A.transpose()).plus(this.Q);

            // Define Y vector
            SimpleMatrix y_aux;
            if (gpsCorrect) {
                double[] vectorY = transformCoordinateSystem(parseCoordinates(gpsData.getLatitude()),
                                                             parseCoordinates(gpsData.getLongitude()));
                y_aux = new SimpleMatrix(2, 1, false, vectorY);
                if (checkCoordenates(vectorY)) {
                    this.C = new SimpleMatrix(createMatrixC(false));
                }
            } else {
                double[] vector = new double[]{0, 0};
                y_aux = new SimpleMatrix(2, 1, false, vector);
            }
            SimpleMatrix matrixY = y_aux.minus(this.C.mult(xPre));

            // Kalman update equations
            SimpleMatrix aux = this.C.mult(pPre).mult(this.C.transpose()).plus(this.R);
            SimpleMatrix matrizK = pPre.mult(this.C.transpose()).mult(aux.invert());
            SimpleMatrix xPostMatrix = xPre.plus(matrizK.mult(matrixY));
            this.pPost = pPre.minus(matrizK.mult(this.C).mult(pPre));
            this.xPost.add(xPostMatrix);
            this.lastXpos = xPostMatrix;
            ProcessedDataUnit processedDataUnit = createProcessedDataFromXPost(xPostMatrix, imuData, time);
            time += 100;
            this.processedData.add(processedDataUnit);
            isGPSData = false;
        }
        createNewState();
    }

    private boolean checkCoordenates(double[] vectorY) {
        return (Math.abs(lastXpos.get(0, 0) - vectorY[0]) > DATA_ERROR ||
                Math.abs(lastXpos.get(1, 0) - vectorY[1]) > DATA_ERROR);
    }

    private void createNewState() {
        String pPost = MatrixToStringParser.parseMatrixToString(this.pPost);
        String qMatrix = MatrixToStringParser.parseMatrixToString(this.Q);
        String rgiMatrix = MatrixToStringParser.parseMatrixToString(this.Rgi);
        double axBias = lastXpos.get(4, 0);
        double ayBias = lastXpos.get(5, 0);
        this.newState = new KalmanState(pPost, qMatrix, rgiMatrix, this.gpsError, axBias, ayBias, this.initialYaw, new Date(), training, device);
    }

    private ProcessedDataUnit createProcessedDataFromXPost(SimpleMatrix xPost, IMUData imuData, long time) {
        double posX = xPost.get(0, 0);
        double posY = xPost.get(1, 0);
        double velX = xPost.get(2, 0);
        double velY = xPost.get(3, 0);
        double accelX = ((double) imuData.getAccelX()) / ACCEL_RANGE;
        double accelY = ((double) imuData.getAccelY()) / ACCEL_RANGE;
        ProcessedDataUnit pData = new ProcessedDataUnit(posX, accelY, accelX, velY, velX, posY, this.device, this.rawData, time);
        return pData;
    }

    public void setUp(List<RawDataUnit> rawDataUnits, boolean isFirstIteration, KalmanState state,
                      ProcessedDataUnit lastXPos) {
        if (isFirstIteration) {
            setUpInitialConditions(rawDataUnits);
        } else {
            setUpIteration(state, lastXPos);
        }
    }

    public void setUpIteration(KalmanState state, ProcessedDataUnit lastXpos) {
        this.pPost = MatrixToStringParser.parseStringToMatrix(state.getPreviousState());
        this.Q = MatrixToStringParser.parseStringToMatrix(state.getqMatrix());
        this.Rgi = MatrixToStringParser.parseStringToMatrix(state.getRgi());
        this.lastXpos = MatrixToStringParser.parseProcessedDataToMatrix(lastXpos);
        this.lastXpos.set(4, 0, state.getaXBias());
        this.lastXpos.set(5, 0, state.getAyBias());
        this.gpsError = state.getGpsError();
        this.initialYaw = state.getInitialYaw();
    }

    public void setUpInitialConditions(List<RawDataUnit> rawDataUnits) {
        List<Double> aXList = new ArrayList<Double>();
        List<Double> aYList = new ArrayList<Double>();
        List<Double> gpsXList = new ArrayList<Double>();
        List<Double> gpsYList = new ArrayList<Double>();
        double[] cartesianCoordinates;
        double yaw = 0;
        double hdop = 0;
        double prevX = 0;
        double prevY = 0;
        for (RawDataUnit rawData : rawDataUnits) {
            for (IMUData imuData : rawData.getImuData()) {
                aXList.add(((double) imuData.getAccelX()) / ACCEL_RANGE);
                aYList.add(((double) imuData.getAccelY()) / ACCEL_RANGE);
                this.initialYaw = ((double) imuData.getYaw()) / YPR_RANGE;
            }
            GPSData gpsData = rawData.getGpsData().get(0);
            cartesianCoordinates = transformCoordinateSystem(parseCoordinates(gpsData.getLatitude()),
                                                             parseCoordinates(gpsData.getLongitude()));
            if (Math.abs(prevX - cartesianCoordinates[0]) > INITIAL_DATA_ERROR ||
                    Math.abs(prevY - cartesianCoordinates[1]) > INITIAL_DATA_ERROR)
                continue;
            gpsXList.add(cartesianCoordinates[0]);
            gpsYList.add(cartesianCoordinates[1]);
            hdop += rawData.getGpsData().get(0).getHDOP();
        }
        hdop /= (gpsXList.size() * 100);
        Double[] axArray = aXList.toArray(new Double[aXList.size()]);
        Double[] ayArray = aYList.toArray(new Double[aYList.size()]);
        double[][] qMatrix = matrizQInitial(axArray, ayArray);
        this.Q = new SimpleMatrix(qMatrix);

        double[][] rMatrix = matrizRInitial(gpsXList.toArray(new Double[gpsXList.size()]), gpsYList.toArray(new Double[gpsYList.size()]), hdop);
        this.R = new SimpleMatrix(rMatrix);

        double[][] rgiMatrix = matrizRgi(yaw);
        this.Rgi = new SimpleMatrix(rgiMatrix);

        Double[] gpsXArray = gpsXList.toArray(new Double[gpsXList.size()]);
        Double[] gpsYArray = gpsYList.toArray(new Double[gpsYList.size()]);

        double[] xPostArray = new double[]{Maths.getPonderateMean(gpsXArray), Maths.getPonderateMean(gpsYArray), 0,
                0, Maths.getMean(axArray), Maths.getMean(ayArray)};
        this.xPost.add(new SimpleMatrix(xPostArray.length, 1, false, xPostArray));
        this.pPost = SimpleMatrix.identity(6);
        this.lastXpos = this.xPost.get(0);
    }

    public List<ProcessedDataUnit> getResults() {
        return this.processedData;
    }

    private void setVariableMatrices(boolean isGpsData, double hdop, double yaw) {
        if (this.gpsCorrect) {
            this.C = new SimpleMatrix(createMatrixC(isGpsData));
        } else {
            this.C = new SimpleMatrix(createMatrixC(false));
        }

        this.R = new SimpleMatrix(matrizR(hdop));

    }

    private static double[] parseCoordinates(long origin) {
        double[] coordinate = new double[3];
        String latitude = Long.toString(origin);
        coordinate[0] = Double.parseDouble(latitude.substring(0, 2));
        coordinate[1] = Double.parseDouble(latitude.substring(2, 4));
        coordinate[2] = Double.parseDouble(latitude.substring(4));
        return coordinate;
    }

    private double[] transformCoordinateSystem(double[] latVector, double[] longVector) {
        double[] coordenadas = new double[2];
        double deltaSecondsLatitude = latVector[2] / 100000 * 60 - latitude0[2];
        double deltaSecondsLongitude = longVector[2] / 100000 * 60 - longitude0[2];
        double theta = latVector[0] + latVector[1] / 60.0 + latVector[2] / 3600.0;
        double longitudeToMeters = (111412.88 * Math.cos(Math.toRadians(theta)) - 93.5 *
                Math.cos(3 * Math.toRadians(theta)) + 0.12 * Math.cos(5 * Math.toRadians(theta))) / 3600.0;
        coordenadas[0] = -deltaSecondsLatitude * 30.9221;
        coordenadas[1] = deltaSecondsLongitude * longitudeToMeters;
        return coordenadas;
    }

    private double[][] matrizA(double dt) {
        double[][] matrizA = new double[6][6];
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 6; j++) {
                matrizA[i][j] = 0;
                if (i == j) {
                    matrizA[i][j] = 1;
                }
            }
        }
        matrizA[0][2] = dt;
        matrizA[1][3] = dt;
        matrizA[2][4] = -dt;
        matrizA[3][5] = -dt;
        matrizA[3][5] = -dt;
        matrizA[0][4] = -Math.pow(dt, 2) / 2;
        matrizA[1][5] = -Math.pow(dt, 2) / 2;
        return matrizA;
    }

    private double[][] matrizB(double dt) {
        double[][] matrizB = new double[6][2];
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 2; j++) {
                matrizB[i][j] = 0;
            }
        }
        matrizB[2][0] = dt;
        matrizB[3][1] = dt;
        matrizB[0][0] = Math.pow(dt, 2) / 2;
        matrizB[1][1] = Math.pow(dt, 2) / 2;
        return matrizB;
    }

    private double[][] createMatrixC(boolean hasGPS) {
        if (hasGPS) {
            return matrizC1();
        } else {
            return matrizC2();
        }

    }

    private double[][] matrizC1() {
        double[][] matrizC = new double[2][6];
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 6; j++) {
                matrizC[i][j] = 0;
            }
        }
        matrizC[0][0] = 1;
        matrizC[1][1] = 1;
        return matrizC;
    }

    private double[][] matrizC2() {
        double[][] matrizC = new double[2][6];
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 6; j++) {
                matrizC[i][j] = 0;
            }
        }
        return matrizC;
    }

    private double[][] matrizRInitial(Double[] gpsXVector, Double[] gpsYVector, double hdop) {
        double[][] matrizR = new double[2][2];
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                matrizR[i][j] = 0;
            }
        }
        matrizR[0][0] = Math.pow(Maths.getStdDev(gpsXVector), 2);
        matrizR[1][1] = Math.pow(Maths.getStdDev(gpsYVector), 2);
        this.gpsError = (Math.sqrt(matrizR[0][0] + matrizR[1][1])) / hdop;
        return matrizR;
    }

    private double[][] matrizR(double hdop) {
        double[][] matrizR = new double[2][2];
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                matrizR[i][j] = 0;
            }
        }
        matrizR[0][0] = Math.pow(this.gpsError * (hdop / YPR_RANGE) * Math.cos(Math.toRadians(this.initialYaw)), 2);
        matrizR[1][1] = Math.pow(this.gpsError * (hdop / YPR_RANGE) * Math.sin(Math.toRadians(this.initialYaw)), 2) ;
        return matrizR;
    }

    private double[][] matrizQInitial(Double[] Ax_vector, Double[] Ay_vector) {
        double[][] matrizQ = new double[6][6];
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 6; j++) {
                matrizQ[i][j] = 0;
            }
        }
        matrizQ[2][2] = Math.pow(Maths.getStdDev(Ax_vector), 2);
        matrizQ[3][3] = Math.pow(Maths.getStdDev(Ay_vector), 2);
        return matrizQ;
    }

    private static double[][] matrizRgi(double omega) {
        double[][] matrizRgi = new double[2][2];
        matrizRgi[0][0] = Math.cos(Math.toRadians(omega));
        matrizRgi[0][1] = Math.sin(Math.toRadians(omega));
        matrizRgi[1][0] = -Math.sin(Math.toRadians(omega));
        matrizRgi[1][1] = Math.cos(Math.toRadians(omega));
        return matrizRgi;
    }

    public void setLastXpos(SimpleMatrix lastXpos) {
        this.lastXpos = lastXpos;
    }

    public KalmanState getNewState() {
        return this.newState;
    }

    public static class Builder {
        private Training training;
        private Device device;
        private RawDataUnit rawDataUnit;
        private List<RawDataUnit> initalConditions;
        private KalmanState state;
        private boolean isFirstIteration;
        private ProcessedDataUnit lastXPos;

        public Builder(Training training, Device device, RawDataUnit rawDataUnit) {
            this.training = training;
            this.device = device;
            this.rawDataUnit = rawDataUnit;
        }

        public Builder initialConditions(List<RawDataUnit> initial) {
            this.initalConditions = initial;
            return this;
        }

        public Builder setState(KalmanState state) {
            this.state = state;
            return this;
        }

        public Builder setIsFirstIteration(boolean isFirst) {
            this.isFirstIteration = isFirst;
            return this;
        }

        public Builder setLastXPos(ProcessedDataUnit lastXpos) {
            this.lastXPos = lastXpos;
            return this;
        }

        public KalmanFilter build() throws InvalidCoordinatesException {
            KalmanFilter kalmanFilter = new KalmanFilter();
            kalmanFilter.initData(this.training, this.device);
            kalmanFilter.setRawData(this.rawDataUnit);
            kalmanFilter.setUp(this.initalConditions, this.isFirstIteration, this.state, this.lastXPos);
            return kalmanFilter;
        }
    }


}
