component {
	this.name = "Functional Tests " & hash(getCurrentTemplatePath());

	this.sessionManagement = true;
	this.mappings[ "/cfPaymillTests" ] = getDirectoryFromPath(getCurrentTemplatePath())& '../';

	public boolean function onRequestStart(string targetPage) {
		return true;
	}
}