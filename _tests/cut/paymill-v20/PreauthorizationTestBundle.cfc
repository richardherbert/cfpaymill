component extends='cfPaymillTests.cut.paymill-v20.V20TestBundle' {
	function beforeAll() {
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	function run() {
		super.run();

		describe('Preauthorization...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {});

			describe('...addPreauthorization()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with token (#variables.token#) amount (#variables.amount#) and currency (#variables.currency#).', function() {
					var preauthorization = application.cfPaymill.addPreauthorization(amount=variables.amount
						,currency=variables.currency
						,token=variables.token
					);

					debug(preauthorization, 'add preauthorization');

					variables.transactionID = preauthorization.data.id;
					variables.preauthorizationID = preauthorization.data.preauthorization.id;

					statusTest(preauthorization);
					preauthorizationTest(preauthorization.data
						,'^tran_*'
						,variables.amount
						,variables.currency
					);
					dateTest(preauthorization.data.created_at);
					dateTest(preauthorization.data.updated_at);
				});
			});

			describe('...getPreauthorization()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with Preauthorization ID.', function() {
					var preauthorization = application.cfPaymill.getPreauthorization(variables.preauthorizationID);

					debug(variables.transactionID, 'preauthorization ID');
					debug(preauthorization, 'get preauthorization');

					statusTest(preauthorization);
					preauthorizationTest(preauthorization.data
						,'^preauth_*'
						,variables.amount
						,variables.currency
					);
					dateTest(preauthorization.data.created_at);
					dateTest(preauthorization.data.updated_at);
				});
			});

			describe('...getPreauthorizations()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...returns an array of preauthorizations.', function() {
					variables.response = application.cfPaymill.getPreauthorizations();

					statusTest(variables.response);

					expect(variables.response.data).toBeArray();
				});
			});

			describe('...deletePreauthorization()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with Preauthorization ID.', function() {
					var preauthorization = application.cfPaymill.deletePreauthorization(variables.preauthorizationID);

					statusTest(preauthorization);
					expect(preauthorization.data).toBeArray();
					expect(preauthorization.data).toBeEmpty();
				});
			});
		});
	}
}