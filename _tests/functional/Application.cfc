component {
	this.name = "Functional Tests " & hash(getCurrentTemplatePath());

	this.sessionManagement = true;

	public boolean function onRequestStart(string targetPage) {
		return true;
	}
}