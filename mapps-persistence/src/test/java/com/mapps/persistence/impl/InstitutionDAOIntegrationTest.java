package com.mapps.persistence.impl;

import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.InstitutionNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Institution;
import com.mapps.persistence.InstitutionDAO;
import org.junit.*;

import javax.ejb.embeddable.EJBContainer;
import javax.naming.NamingException;
import java.util.List;

import static org.junit.Assert.assertTrue;

/**
 *
 */
public class InstitutionDAOIntegrationTest {

    private static EJBContainer ejbContainer;


    private Institution testInstitution;
    private Institution testInstitution2;
    private InstitutionDAO institutionDAO;


    @BeforeClass
    public static void startTheContainer(){

        ejbContainer=EJBContainer.createEJBContainer();
    }
    @Before
    public void lookupABean() throws NamingException {

        Object object3=ejbContainer.getContext().lookup("java:global/mapps-persistence/InstitutionDAO");

        assertTrue(object3 instanceof InstitutionDAO);

        institutionDAO=(InstitutionDAO)object3;
    }

    @AfterClass
    public static void stopTheContainer(){
        if(ejbContainer!=null){
            ejbContainer.close();
        }
    }

    @Test
    public void testInstitution() throws InstitutionAlreadyExistException, InstitutionNotFoundException, NullParameterException {
        testInstitution=new Institution("hola","desc","URUGUAY");
        testInstitution2=new Institution("hola2","desc","URUGUAY");
        institutionDAO.addInstitution(testInstitution);
        institutionDAO.addInstitution(testInstitution2);

        if(testInstitution.equals(testInstitution2)){
            System.out.print("IGUALES");
        }else{
            System.out.print("NO SON IGUALES");
        }
        Institution returnedInstitution = institutionDAO.getInstitutionByName(testInstitution.getName());
        Institution returnedInstitution2 = institutionDAO.getInstitutionByName(testInstitution2.getName());

        //Assert.assertEquals(testInstitution.getName(), returnedInstitution.getName());
        //Assert.assertEquals(testInstitution2.getName(), returnedInstitution2.getName());


        List<Institution> list= institutionDAO.getAllInstitutions();

        for(int i=0;i<list.size();i++){

             System.out.println(list.get(i).getName());
          }
    }

}
