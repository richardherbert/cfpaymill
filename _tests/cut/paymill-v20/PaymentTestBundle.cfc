component extends='cfPaymillTests.cut.paymill-v20.V20TestBundle' {
	function beforeAll() {
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	function run() {
		var options = deserializeJSON(options);

		variables.token = options.token;

		variables.amount = 12.99;
		variables.currency = 'GBP';
		variables.type = 'creditcard';
		variables.card_type = 'visa';
		variables.country = 'DE';
		variables.last4 = '1111';
		variables.expiryMonth = month(now());
		variables.expiryYear = year(now()) + 1;

		describe('Payment...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {
				structDelete(variables, 'response');
			});

			describe('...getPayments()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...returns an array of offers.', function() {
					variables.response = application.cfPaymill.getPayments();

					statusTest(variables.response);

					expect(variables.response.data).toBeArray();
				});
			});

			describe('...addPayment()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with token (#variables.token#).', function() {
					variables.response = application.cfPaymill.addPayment(token=variables.token);

					variables.paymentID = variables.response.data.id;
debug(variables.response);

					statusTest(variables.response);
					paymentTest(variables.response.data, '^pay_*'
						,variables.type
						,variables.card_type
						,variables.country
						,variables.last4
						,variables.expiryMonth
						,variables.expiryYear);
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});
			});

			describe('...getPayment()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with Payment ID.', function() {
					var payment = application.cfPaymill.getPayment(variables.paymentID);

					statusTest(payment);
					paymentTest(payment.data, '^pay_*'
						,variables.type
						,variables.card_type
						,variables.country
						,variables.last4
						,variables.expiryMonth
						,variables.expiryYear);
					dateTest(payment.data.created_at);
					dateTest(payment.data.updated_at);
				});
			});

			describe('...deletePayment()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with Payment ID.', function() {
					var payment = application.cfPaymill.deletePayment(variables.paymentID);

					statusTest(payment);
					expect(payment.data).toBeArray();
					expect(payment.data).toBeEmpty();
				});
			});
		});
	}
}