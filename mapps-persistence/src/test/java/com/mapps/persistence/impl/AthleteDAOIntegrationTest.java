package com.mapps.persistence.impl;

import junit.framework.Assert;

import java.util.List;
import javax.ejb.embeddable.EJBContainer;
import javax.naming.NamingException;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Athlete;
import com.mapps.model.Institution;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.InstitutionDAO;

import static org.junit.Assert.assertTrue;

/**
 *
 */
public class AthleteDAOIntegrationTest {

    private static EJBContainer ejbContainer;
    private Athlete testAthlete;
    private Athlete testAthlete2;
    private Athlete testAthlete3;
    private AthleteDAO athleteDAO;

    private Institution testInstitution;
    private InstitutionDAO institutionDAO;


    @BeforeClass
    public static void startTheContainer(){

        ejbContainer=EJBContainer.createEJBContainer();
    }
    @Before
     public void lookupABean() throws NamingException {

        Object object2=ejbContainer.getContext().lookup("java:global/mapps-persistence/AthleteDAO");
        Object object3=ejbContainer.getContext().lookup("java:global/mapps-persistence/InstitutionDAO");
        assertTrue(object2 instanceof AthleteDAO);
        assertTrue(object3 instanceof InstitutionDAO);
        athleteDAO=(AthleteDAO)object2;
        institutionDAO=(InstitutionDAO)object3;
    }

    @AfterClass
    public static void stopTheContainer(){
        if(ejbContainer!=null){
             ejbContainer.close();
        }
    }

    @Test
    public void testAthlete() throws AthleteNotFoundException, AthleteAlreadyExistException, InstitutionAlreadyExistException, NullParameterException {
        testInstitution=new Institution("hola",null,"URUGUAY");
        testAthlete=new Athlete(null, null, null,null,
                null,1.5, 1.2,"44475992",testInstitution);
        testAthlete2=new Athlete(null, null, null,null,
                null,1.5, 1.2,"45",testInstitution);



        institutionDAO.addInstitution(testInstitution);


        athleteDAO.addAthlete(testAthlete);
        athleteDAO.addAthlete(testAthlete2);

        Athlete returnedAthlete = athleteDAO.getAthleteByIdDocument(testAthlete.getIdDocument());
        List<Athlete> list=athleteDAO.getAllAthletesByInstitution(testInstitution.getName());

        Assert.assertEquals(testAthlete.getIdDocument(), returnedAthlete.getIdDocument());

       // for(int i=0;i<list.size();i++){
       //     System.out.println(list.get(i).getIdDocument());
      //  }

        //TEST addAthlete
        //Assert.assertEquals(testAthlete.getIdDocument(), returnedAthlete.getIdDocument());

        //returnedAthlete.setIdDocument("44475994");
        //athleteDAO.updateAthlete(returnedAthlete);
        //Athlete returnedAthlete2 =athleteDAO.getAthleteByIdDocument(returnedAthlete);
        //TEST updateAthlete
        //Assert.assertEquals(returnedAthlete2.getIdDocument(), returnedAthlete.getIdDocument());

        //try{
         //   athleteDAO.deleteAthlete(returnedAthlete2.getId());
          //  athleteDAO.getAthleteByIdDocument(returnedAthlete2);
       // }catch (AthleteNotFoundException e){
            //TEST deleteAthlete
        //    Assert.assertTrue(true);
      //  }

    }

}
