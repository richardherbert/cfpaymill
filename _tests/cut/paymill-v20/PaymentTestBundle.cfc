component extends='cfPaymillTests.cut.paymill-v20.V20TestBundle' {
	function beforeAll() {
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	function run() {
		var options = deserializeJSON(options);

		param variables.name=options.name;
		param variables.emailAddress=options.emailAddress;

		param variables.cardNumber=options.cardNumber;
		param variables.cvc=options.cvc;

		param variables.expiryMonth=options.expiryMonth;
		param variables.expiryYear=options.expiryYear;

		param variables.amount=options.amount;
		param variables.currency=options.currency;

		param variables.token=options.token;

		variables.type = 'creditcard';
		variables.card_type = 'visa';
		variables.country = 'DE';
		variables.last4 = right(variables.cardNumber, 4);

		describe('Payment...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {
				structDelete(variables, 'response');
			});

			describe('...addPayment()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with token (#variables.token#).', function() {
					var payment = application.cfPaymill.addPayment(token=variables.token);

					variables.paymentID = payment.data.id;

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

			describe('...getPayments()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...returns an array of payments.', function() {
					var payment = application.cfPaymill.getPayments();

					statusTest(payment);

					expect(payment.data).toBeArray();
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