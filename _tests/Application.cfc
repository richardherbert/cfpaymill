/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com | www.gocontentbox.org
**************************************************************************************
*/
component{
	this.name = "A TestBox Runner " & hash(getCurrentTemplatePath());

	this.sessionManagement = true;

	this.mappings[ "/cfPaymillTests" ] = getDirectoryFromPath(getCurrentTemplatePath());

	public boolean function onRequestStart( String targetPage ){
		return true;
	}
}