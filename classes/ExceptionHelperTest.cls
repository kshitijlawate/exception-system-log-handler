/*
Author: Kshitij Lawate

Permission is hereby granted, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction.

*Class Details*
Test class for ExceptionHelper utility class
*/
@isTest
public with sharing class ExceptionHelperTest 
{
    @isTest
    static void testExceptionHelperMethods1()
    {
        String exceptionDetails;
        List<String> errorMessages = new List<String> ();
        try 
        {
            insert new Account();    
        } 
        catch (Exception ex) 
        {
            exceptionDetails = ExceptionHelper.populateExceptionDetailsToLog(ex);
            errorMessages = ExceptionHelper.populateErrorMessages(ex);
        }

        system.assert(exceptionDetails.contains('REQUIRED_FIELD_MISSING'));
        system.assertEquals(1, errorMessages.size());
    }

    @isTest
    static void testExceptionHelperMethods2()
    {
        String exceptionDetails;
        List<String> errorMessages = new List<String> ();
        try 
        {
            Decimal notPossible = 1/0; 
        } 
        catch (Exception ex) 
        {
            exceptionDetails = ExceptionHelper.populateExceptionDetailsToLog(ex);
            errorMessages = ExceptionHelper.populateErrorMessages(ex);
        }

        system.assert(exceptionDetails.contains('MathException'));
        system.assertEquals(1, errorMessages.size());
    }
}