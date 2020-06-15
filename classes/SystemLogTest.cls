/*
Author: Kshitij Lawate

Permission is hereby granted, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction.

*Class Details*
Test class for SystemLog utility class
*/
@isTest
public with sharing class SystemLogTest 
{
    @isTest
    static void testLogException()
    {
        try 
        {
            insert new Account();    
        } 
        catch (Exception ex) 
        {
            SystemLog.logException(ex, 'SystemLogTest', 'testLogException', 'Inside the test class.');
        }

        system.assertEquals(1, [SELECT count() FROM System_Log__c WHERE Apex_Class__c = 'SystemLogTest' 
                                AND Custom_Message__c = 'Inside the test class.' ]);
    }

    @isTest
    static void testLogger()
    {
        SystemLog.init('001', '', '');
        
        Decimal dDivision = 54234 / 223.0;
        String s001Log = 'Here is the output for division: ' + dDivision;
        SystemLog.addToLog('001', s001Log);
        SystemLog.setAsSuccess('001');

        SystemLog.init('002', '', '');
        
        String s002Log = 'The current time is: ' + System.Now().format();
        SystemLog.addToLog('002', s002Log);
        SystemLog.setAsFailure('002');

        SystemLog.commitLogs();

        system.assertEquals(1, [SELECT count() FROM System_Log__c WHERE Status__c = 'Success']);

        SystemLog.init('003', '', '');
        
        String s003Log = 'The current logged in User is ' + UserInfo.getName();
        SystemLog.addToLog('003', s003Log);

        SystemLog.commitLogs();

        system.assertEquals(3, [SELECT count() FROM System_Log__c]);
    }   
}