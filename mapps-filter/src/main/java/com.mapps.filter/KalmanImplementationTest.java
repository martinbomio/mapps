package com.mapps.filter;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


import org.ejml.simple.SimpleMatrix;

public class KalmanImplementationTest {
	
	private static double dt;
	
	private static double [] timeStamps_vector;
	private static double [] GPSx_vector;
	private static double [] GPSy_vector;
	private static double [] HDOP_vector;
	private static double [] Ax_vector;
	private static double [] Ay_vector;
	private static double [] Az_vector;
	private static double [] roll_vector;
	private static double [] pitch_vector;
	private static double [] yaw_vector;
	private static double [] GPSx_vector_kalman;
	private static double [] GPSy_vector_kalman;
	private static double [] vectorAux;
	
	private static final int accelRange = 8192;
	private static final int yprRange = 100;
	
	private static final int maxIndex = 600;
	
	// Se definen aca como constantes ya que son los datos verdaderos
	private static int omega = 51;
	private static double [] latitude0 = new double [3];		// DD-mm-ssss
	private static double [] longitude0 = new double [3];		// DD-mm-ssss
	private static double [] coordenadasActuales = new double [2];
	private static double [][] map;
	private static boolean [] newGPSdata;
	private static final int maxDeviation = 100;
	
	private static double [] coordinatesOffsets;	// x offset (m) - y offset (m)
	

	public static void main(String[] args) {
		// Set coordinates of initial start point
		latitude0[0] = 34;
		latitude0[1] = 55;
		latitude0[2] = 17.97;
		longitude0[0] = 56;
		longitude0[1] = 9;
		longitude0[2] = 13.49;
		

		//coordinatesOffsets = setInitialError();
		//correctGPScoordinates();
		
		
		
		// Defining initial conditions
		double [] xPost_vector = setInitialConditions();
		SimpleMatrix xPost = new SimpleMatrix(6,1,false,xPost_vector);
		xPost.print(4,4);
		double [][] PPost_vector = matrizP0();
		SimpleMatrix PPost = new SimpleMatrix(PPost_vector);
		
		// Define Kalman matrixes
		double [][] A;
		double [][] B;
		double [][] C;
		double [][] R;
		double [][] Q;
			
		// Sensed variables
		double [] u_aux = new double[2];
		
		//Rgi matrix
		double [][] Rgi_vector = matrizRgi();
		SimpleMatrix Rgi = new SimpleMatrix(Rgi_vector);
		
		// Set covariance matrixes
		R = matrizR();
		SimpleMatrix matrizR = new SimpleMatrix(R);
		matrizR.print(4, 4);
		Q = matrizQ();
		SimpleMatrix matrizQ = new SimpleMatrix(Q);
		
		int largo = GPSx_vector.length;
		GPSx_vector_kalman = new double [largo];
		GPSy_vector_kalman = new double [largo];
		
		// Do the algorithm
		for(int i = 0; i < largo; i++){
			// Set dt
			dt = 0.1;
			
			// Initialize the matrixes 
			A = matrizA();
			SimpleMatrix matrizA = new SimpleMatrix(A);
			B = matrizB();
			SimpleMatrix matrizB = new SimpleMatrix(B);
			if(newGPSdata[i]){
				C = matrizC2();
			}else{
				C = matrizC1();
			}
			SimpleMatrix matrizC = new SimpleMatrix(C);
			
			
			// Set new u vector
			u_aux[0] = Ax_vector[i];
			u_aux[1] = Ay_vector[i];
			SimpleMatrix matriz_u_aux = new SimpleMatrix(2,1,false,u_aux);
							
			// Convert A from I to G
			SimpleMatrix matrizU = Rgi.mult(matriz_u_aux);
	
			// Time update equations
			SimpleMatrix xPre = matrizA.mult(xPost).plus(matrizB.mult(matrizU));
			SimpleMatrix pPre = matrizA.mult(PPost).mult(matrizA.transpose()).plus(matrizQ);
	
			// Define Y vector
			double [] y_vector = new double [2];
			y_vector[0] = GPSx_vector[i];
			y_vector[1] = GPSy_vector[i];
			SimpleMatrix y_aux = new SimpleMatrix(2,1,false,y_vector);
			SimpleMatrix matrizY = y_aux.minus(matrizC.mult(xPre));
				
			// Kalman update equations
			SimpleMatrix aux = matrizC.mult(pPre).mult(matrizC.transpose()).plus(matrizR);
			SimpleMatrix matrizK = pPre.mult(matrizC.transpose()).mult(aux.invert());
			xPost = xPre.plus(matrizK.mult(matrizY));
			PPost = pPre.minus(matrizK.mult(matrizC).mult(pPre));
			xPost.print(4,4);
			GPSx_vector_kalman [i] = xPost.get(0);
			GPSy_vector_kalman [i] = xPost.get(1);
		}
		
        

	}
	
	private static double [][] matrizA(){
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
	
	private static double [][] matrizB(){
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
	
	private static double [][] matrizC1(){
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
	
	private static double [][] matrizC2(){
		double [][] matrizC = new double[2][6];
		for(int i=0; i<2; i++){
			for(int j=0; j<6; j++){
				matrizC[i][j] = 0;
			}
		}
		return matrizC;
	}

	private static double [][] matrizR(){
		double [][] matrizR = new double[2][2];
		for(int i=0; i<2; i++){
			for(int j=0; j<2; j++){
				matrizR[i][j] = 0;
			}
		}
		matrizR[0][0] = getStdDev(GPSx_vector, maxIndex);
		matrizR[1][1] = getStdDev(GPSy_vector, maxIndex);
		//matrizR[0][0] = 0.2;
		//matrizR[1][1] = 0.2;
		return matrizR;
	}
	
	private static double [][] matrizQ(){
		double [][] matrizQ = new double[6][6];
		for(int i=0; i<6; i++){
			for(int j=0; j<6; j++){
				matrizQ[i][j] = 0;
			}
		}
		matrizQ[2][2] = getStdDev(Ax_vector, maxIndex);
		matrizQ[3][3] = getStdDev(Ay_vector, maxIndex);
		return matrizQ;
	}
	
	
	private static double [][] matrizP0(){
		double [][] matrizP0 = new double [6][6];
		for(int i=0; i<6; i++){
			for(int j=0; j<6; j++){
				if(i == j){
					matrizP0[i][j] = 1;					
				}else{
					matrizP0[i][j] = 0;
				}
			}
		}
		return matrizP0;
	}
	
	private static double [][] matrizRgi(){
		double [][] matrizRgi = new double [2][2];
		matrizRgi[0][0] = Math.cos(Math.toRadians(omega));
		matrizRgi[0][1] = Math.sin(Math.toRadians(omega));
		matrizRgi[1][0] = -Math.sin(Math.toRadians(omega));
		matrizRgi[1][1] = Math.cos(Math.toRadians(omega));
		return matrizRgi;
	}
	
	private static void getData() {
		Connection conexion = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conexion =  DriverManager.getConnection("jdbc:mysql://localhost/mapps_collector", "root", "");
            System.out.println("Conexion exitosa");
            
            Statement statement = conexion.createStatement();
            String sql = "SELECT COUNT(*) as 'count' FROM rawData;";
            ResultSet rsAux = statement.executeQuery(sql);
            int length = 0;
            if(rsAux.next()){
            	length = rsAux.getInt("count");
            }
            int index = 0;
            String sql2 = "SELECT * FROM rawData;";
            boolean primerDato = true;
            ResultSet rs = statement.executeQuery(sql2);

            timeStamps_vector = new double [length];
        	GPSx_vector = new double [length];
        	GPSy_vector = new double [length];
        	HDOP_vector = new double [length];
        	Ax_vector = new double [length];
        	Ay_vector = new double [length];
        	Az_vector = new double [length];
        	roll_vector = new double [length];
        	pitch_vector = new double [length];
        	yaw_vector = new double [length];
        	newGPSdata = new boolean [length];
        	vectorAux = new double [length];
        	
            while(rs.next()){
            	int gps = rs.getInt("gps");
        		boolean newGPSaux = false;
            	if(gps == 1){
            		String latitude = rs.getString("latitude");
            		String longitude = rs.getString("longitude");
            		int HDOP = rs.getInt("HDOP");
            		int deltaT = rs.getInt("deltaT");
            		//int heartRate = rs.getInt("heartRate");
            		if(primerDato){
            			coordenadasActuales = obtenerCoordenadas(latitude, longitude);
            			primerDato = false;
            		}else if(checkGPScoordinates(latitude, longitude)){
            			try{
	            			coordenadasActuales = obtenerCoordenadas(latitude, longitude);
	            			newGPSaux = true;            			
	            			// timeStamps_vector[index] = deltaT; 
	                		// HDOP_vector[index] = HDOP;
            			}catch (Exception e){
            				
            			}
            		}
            	}else{
            		int accelXRaw = rs.getInt("acelX");
            		int accelYRaw = rs.getInt("acelY");
            		int accelZRaw = rs.getInt("acelZ");
            		int yawRaw = rs.getInt("yaw");
            		int pitchRaw = rs.getInt("pitch");
            		int rollRaw = rs.getInt("roll");
            		double accelX = (double) accelXRaw / (double) accelRange;
            		double accelY = (double) accelYRaw / (double) accelRange;
            		double accelZ = (double) accelZRaw / (double) accelRange;
            		double yaw = (double) yawRaw / (double) yprRange;
            		double pitch = (double) pitchRaw / (double) yprRange;
            		double roll = (double) rollRaw / (double) yprRange;
            		Ax_vector[index] = accelX * 9.82;
            		Ay_vector[index] = accelY * 9.82;
            		Az_vector[index] = accelZ * 9.82;
            		yaw_vector[index] = Math.toRadians(yaw);
            		pitch_vector[index] = Math.toRadians(pitch);
            		roll_vector[index] = Math.toRadians(roll);
            		GPSx_vector[index] = coordenadasActuales[0];
            		GPSy_vector[index] = coordenadasActuales[1];
            		vectorAux[index] = index;
            		
            		if(newGPSaux){
            			newGPSdata[index] = true;
            			
            		}
                	index ++;
            	}
            }
            
        }catch(Exception e){
        	e.printStackTrace();
        }finally {
        	if (conexion != null) {
                try {
                    conexion.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
	}
	
	// latitude0Error y longitude0Error vienen en formato nmea dd-MM-mmmm
	private static double [] setInitialError(){
		double GPSxMean = getMean(GPSx_vector, maxIndex);
		double GPSyMean = getMean(GPSy_vector, maxIndex);
		double [] resultado = new double [2];
		resultado[0] = GPSxMean;	// convert to meters
		resultado[1] = GPSyMean; // convert to meters
		return resultado;
	}
	
	private static double [] obtenerCoordenadas(String latitude, String longitude){
		double [] coordenadas = new double [2];
		double [] latitudeVector = new double [3];
		try{
			latitudeVector[0] = (double) Integer.parseInt(latitude.substring(0, 2));
			latitudeVector[1] = (double) Integer.parseInt(latitude.substring(2, 4));
			latitudeVector[2] = (double) Integer.parseInt(latitude.substring(4));
			double [] longitudeVector = new double [3];
			longitudeVector[0] = (double) Integer.parseInt(longitude.substring(0, 2));
			longitudeVector[1] = (double) Integer.parseInt(longitude.substring(2, 4));
			longitudeVector[2] = (double) Integer.parseInt(longitude.substring(4));
			
			double deltaSecondsLatitude = ( latitudeVector[0] - latitude0[0] ) * 3600 + ( latitudeVector[1] - latitude0[1] ) * 60 + latitudeVector[2] / 100000 * 60 - latitude0[2];
			double deltaSecondsLongitude = ( longitudeVector[0] - longitude0[0] ) * 3600 + ( longitudeVector[1] - longitude0[1] ) * 60 + longitudeVector[2] / 100000 * 60 - longitude0[2] ;
			double theta = latitudeVector[0] + latitudeVector[1] / 60.0 + latitudeVector[2] / 3600.0;
			double longitudeToMeters = ( 111412.88 * Math.cos(Math.toRadians(theta)) - 93.5 * Math.cos( 3 * Math.toRadians(theta)) + 0.12 * Math.cos(5 * Math.toRadians(theta)) ) / 3600.0;
			coordenadas[0] = - deltaSecondsLatitude * 30.9221;
			coordenadas[1] =  deltaSecondsLongitude * longitudeToMeters;
		}catch (Exception e){

		}
		return coordenadas;
	}
	
	private static double [] setInitialConditions(){
		double [] x0 = new double [6];
		x0[0] = getMean(GPSx_vector, maxIndex);
		x0[1] = getMean(GPSy_vector, maxIndex);
		x0[2] = 0;
		x0[3] = 0;
		x0[4] = getMean(Ax_vector, maxIndex);
		x0[5] = getMean(Ay_vector, maxIndex);
		return x0;
	}
	
	private static boolean checkGPScoordinates(String latitude, String longitude){
		boolean result = true;
		// First check String length
		if(latitude.length() < 9 || longitude.length() < 9){
			result = false;
		}
		// Then check for distance
		double [] coordenadas = obtenerCoordenadas(latitude, longitude);
		double x = Math.abs(coordenadas[0] - coordenadasActuales[0]);
		double y = Math.abs(coordenadas[1] - coordenadasActuales[1]);
		if(Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)) > maxDeviation){
			result = false;
		}
		return result;
	}
	
	private static void correctGPScoordinates(){
		for(int i = 0 ; i < GPSx_vector.length ; i++){
			GPSx_vector[i] -= coordinatesOffsets[0];
			GPSy_vector[i] -= coordinatesOffsets[1];
		}
	}
	
	private static double getMean(double [] data,int size){
        double sum = 0.0;
        for(int i = 0 ; i < size ; i ++){
            sum += data[i];
        }
        return sum/size;
    }

    private static double getVariance(double [] data,int size){
    	double mean = getMean(data, size);
        double temp = 0;
        for(int i = 0 ; i < size ; i ++){
            temp += (mean-data[i])*(mean-data[i]);
        }
        return temp/size;
    }

    private static double getStdDev(double [] data,int size){
        return Math.sqrt(getVariance(data, size));
    }
    
    
}
