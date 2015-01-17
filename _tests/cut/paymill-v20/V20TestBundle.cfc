component extends='cfPaymillTests.cut.BaseTestBundle' {
	function beforeAll() {
		var response = super.beforeAll();

		application.cfPaymill =  new cfpaymill.cfPaymill(privateKey=response.privateTestKey
			,publicKey=response.publicTestKey
			,logfile=expandPath('../') & 'cfPaymill.log'
			,apiEndpoint='https://api.paymill.com/v2/');
	}

	function afterAll() {
		super.afterAll();
	}
}