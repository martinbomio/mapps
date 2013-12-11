package com.mapps.services.institution.impl;

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.persistence.InstitutionDAO;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.institution.stub.InstitutionServiceStub;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class InstServiceImplTest {
    InstitutionServiceStub institutionService;
    InstitutionDAO institutionDAO;

    @Before
    public void setUp()throws Exception{
        institutionService=new InstitutionServiceStub();
        institutionDAO=mock(InstitutionDAO.class);
        AuthenticationHandler auth = mock(AuthenticationHandler.class);

        when(auth.isUserInRole("validToken", Role.ADMINISTRATOR)).thenReturn(true);
        when(auth.isUserInRole("invalidToken", Role.ADMINISTRATOR)).thenReturn(false);
        when(auth.isUserInRole("",Role.ADMINISTRATOR)).thenThrow(new InvalidTokenException());

        institutionService.setAuthenticationHandler(auth);
        institutionService.setInstitutionDAO(institutionDAO);

    }
    @Test
    public void testCreateInstitution(){
        Institution validInstitution = mock(Institution.class);
        when(validInstitution.getName()).thenReturn("nombreInstitucion");
        when(validInstitution.getCountry()).thenReturn("paisInstitucion");

        try {
            institutionService.createInstitution(validInstitution, "validToken");
            Assert.assertTrue(true);
        } catch (AuthenticationException e) {
            Assert.fail();

        } catch (InvalidInstitutionException e) {
            Assert.fail();

        }

    }
    @Test
    public void testCreateInvalidInstitution(){
        Institution validInstitution=mock(Institution.class);
        when(validInstitution.getName()).thenReturn("nombreInstitucion");

        try {
            institutionService.createInstitution(validInstitution,"validToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (InvalidInstitutionException e) {
            Assert.assertTrue(true);
        }
    }
    @Test
    public void testCreateInstitutionWithoutPermissions(){
        Institution validInstitution=mock(Institution.class);
        when(validInstitution.getName()).thenReturn("nombreInstitucion");
        when(validInstitution.getCountry()).thenReturn("paisInstitucion");

        try {
            institutionService.createInstitution(validInstitution,"invalidToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (InvalidInstitutionException e) {
            Assert.fail();
        }
    }
    @Test
    public void testCreateNullInstitution(){
        try {
            institutionService.createInstitution(null, "validToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (InvalidInstitutionException e) {
            Assert.assertTrue(true);
        }
    }
    @Test
    public void testDeleteInstitution(){
        Institution deleteInstitution=mock(Institution.class);
        when(deleteInstitution.getName()).thenReturn("borrarInstitucion");
        when(deleteInstitution.getCountry()).thenReturn("paisInstitucion");


    }

}
