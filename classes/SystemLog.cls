/*
Author: Kshitij Lawate

Permission is hereby granted, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction.

*Class Details*
Class with methods to initialize, update and insert log records. 
*/
public with sharing class SystemLog 
{
    //map of System Log with user defined Unique Id as map key. 
    static Map<String, System_Log__c> mapSystemLogs = new Map<String, System_Log__c> ();

    //method to initialize the Log record with unique Id and optional apex class and method name 
    public static void init(String uniqueId, String apexClass, String methodName)
    {
        System_Log__c sLog = fetchSystemLog(uniqueId);
        sLog.Apex_Class__c = apexClass;
        sLog.Method_Name__c = methodName;
        mapSystemLogs.put(uniqueId, sLog);
    }

    //method that might be invoked multiple times to add content to log 
    public static void addToLog(String uniqueId, String details)
    {
        System_Log__c sLog = fetchSystemLog(uniqueId);
        sLog.Additional_Details__c = details;
        mapSystemLogs.put(uniqueId, sLog);
    }

    //method to set Status on log 
    public static void setAsSuccess(String uniqueId)
    {
        System_Log__c sLog = fetchSystemLog(uniqueId);
        sLog.Status__c = 'Success';
        mapSystemLogs.put(uniqueId, sLog);
    }

    //method to set Status on log 
    public static void setAsFailure(String uniqueId)
    {
        System_Log__c sLog = fetchSystemLog(uniqueId);
        sLog.Status__c = 'Failure';
        mapSystemLogs.put(uniqueId, sLog);
    }

    //perform DML operation to insert logs in system
    public static void commitLogs()
    {
        insert mapSystemLogs.values();
        mapSystemLogs.clear();
    }

    //method to fetch system log based on unique Id
    private static System_Log__c fetchSystemLog(String uniqueId)
    {
        return mapSystemLogs.containsKey(uniqueId) ? mapSystemLogs.get(uniqueId) : new System_Log__c();
    }

    //indenpendent static method to log exception records from a catch block 
    public static Id logException(Exception ex, String apexClass, String methodName, String customMessage)
    {
        System_Log__c sLog = new System_Log__c();
        sLog.Apex_Class__c = apexClass;
        sLog.Method_Name__c = methodName;
        sLog.Custom_Message__c = customMessage;
        sLog.Exception_Details__c = ExceptionHelper.populateExceptionDetailsToLog(ex);
        sLog.Status__c = 'Failure';

        insert sLog;
        return sLog.Id;
    }
}