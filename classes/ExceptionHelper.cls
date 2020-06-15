/*
Author: Kshitij Lawate

Permission is hereby granted, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction.

*Class Details*
Exception Helper class to extract messages and log the details to logger record. 


*/
public with sharing class ExceptionHelper 
{
	//method to return details to log in string format 
	public static String populateExceptionDetailsToLog(Exception ex)
	{
		String contentToLog = '';
		ExceptionLogWrapper elWrapper = new ExceptionLogWrapper();
		elWrapper = fetchErrorMessageAndExceptionDetailsToLog(ex, false, true); //populate only content to log in string, no separate list of error message required 
		
		if(elWrapper != null && elWrapper.contentToLog != null)
		{
			contentToLog = elWrapper.contentToLog;
		}
		return contentToLog;
	}
	//method to return list of error messages in list of string format 
	public static List<String> populateErrorMessages(Exception ex)
	{
		List<String> errorMessages = new List<String>();
		ExceptionLogWrapper elWrapper = new ExceptionLogWrapper();
		elWrapper = fetchErrorMessageAndExceptionDetailsToLog(ex, true, false); //populate only error messages, no log content required 
		
		if(elWrapper != null && elWrapper.errorMessages != null)
		{
			errorMessages = elWrapper.errorMessages;
		}
		return errorMessages;
	}
	

	/**
	 * method that accepts exception object as parameter and returns a wrapper that contains list of error messages and 
	 * all exception details based on parameter values passed
	 */
	private static ExceptionLogWrapper fetchErrorMessageAndExceptionDetailsToLog(Exception ex, Boolean listErrorMessage, Boolean logExceptionContent)
	{
		ExceptionLogWrapper elWrap = new ExceptionLogWrapper();
		if(ex != null && (listErrorMessage || logExceptionContent))
		{
			if(logExceptionContent) //if sent as TRUE, prepare the string to log all details of exception  
			{
				elWrap.contentToLog = '***Exception Details*** \r\n\r\n';
			}
			if(ex.getTypeName() == 'System.DMLException' || ex.getTypeName() == 'System.EmailException')
			{
				for(Integer temp = 0; temp < ex.getNumDml(); temp ++)
				{
					if(listErrorMessage)
					{
						elWrap.errorMessages.add(ex.getDmlMessage(temp));
					}
					
					if(logExceptionContent) //if sent as TRUE, prepare the string to log all details of exception
					{
						elWrap.contentToLog += 'DML Fields: ' + ex.getDmlFields(temp) + ' \r\nDML Id: ' + ex.getDmlId(temp) 
									 + ' \r\nDML Message: ' + ex.getDmlMessage(temp) 
									 + ' \r\nDML Status Code: ' + ex.getDmlStatusCode(temp)
									 + ' \r\nDML Type: ' + ex.getDmlType(temp) + ' \r\n';
					}  
				}				
			}
			else if(listErrorMessage) //if listing the error messages required 
			{
				elWrap.errorMessages.add(ex.GetMessage());
			}
			
			if(logExceptionContent) //if sent as TRUE, prepare the string to log all details of exception
			{
				elWrap.contentToLog += 'Message: ' + ex.getMessage() + ' \r\nLine Number: ' + ex.getLineNumber() 
							+ ' \r\nException Type: ' + ex.getTypeName() + ' \r\nStack Trace String: ' + ex.getStackTraceString();			
			}
		}
		return elWrap;
	}    
	
	public class ExceptionLogWrapper
	{
		public List<String> errorMessages; 
		public String contentToLog;
		
		public ExceptionLogWrapper()
		{
			errorMessages = new List<String> ();
			contentToLog = '';
		}
	}
}