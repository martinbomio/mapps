package com.mapps.filter.utils;

import org.ejml.simple.SimpleMatrix;

import com.mapps.model.ProcessedDataUnit;

/**
 *
 *
 */
public class MatrixToStringParser {

    public static SimpleMatrix parseStringToMatrix(String matrix){
        String[] rows = matrix.split(";");
        int numbRows = rows.length;
        int numbCols = rows[0].split(",").length;
        double[][] array = new double[numbRows][numbCols];
        for (int i = 0; i< numbRows ; i++){
            String[] elem = rows[i].split(",");
            for (int j = 0; j<numbCols;j++){
                array[i][j] = Double.parseDouble(elem[j]);
            }
        }
        return new SimpleMatrix(array);
    }

    public static String parseMatrixToString(SimpleMatrix matrix){
        StringBuilder builder = new StringBuilder();
        for (int i = 0 ; i<matrix.numRows(); i++){
            for (int j = 0; j<matrix.numCols(); j++){
                builder.append(matrix.get(i,j));
                if (j != (matrix.numCols()-1))
                    builder.append(",");
            }
            if (i != (matrix.numRows()-1))
                builder.append(";");
        }
        return builder.toString();
    }

    public static SimpleMatrix parseProcessedDataToMatrix(ProcessedDataUnit data){
        SimpleMatrix matrix = new SimpleMatrix(6,1);
        matrix.set(0,0, data.getPositionX());
        matrix.set(1,0, data.getPositionY());
        matrix.set(2,0, data.getVelocityX());
        matrix.set(3,0, data.getVelocityY());
        matrix.set(4,0, data.getAccelerationX());
        matrix.set(5,0, data.getAccelerationY());
        return matrix;
    }
}
