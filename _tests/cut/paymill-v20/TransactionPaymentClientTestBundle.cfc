component extends='cfPaymillTests.cut.paymill-v20.V20TestBundle' {
	function beforeAll() {
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	function run() {
		super.run();

		describe('Transaction...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {});

			describe('...addTransaction()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with token (#variables.token#) amount (#variables.amount#) and currency (#variables.currency#).', function() {
					var customer = application.cfPaymill.addClient(email=variables.emailAddress, description=variables.name);
					var payment = application.cfPaymill.addPayment(token=variables.token, client=customer.data.id);

					var transaction = application.cfPaymill.addTransaction(amount=variables.amount
						,currency=variables.currency
						,payment=payment.data.id
						,client=customer.data.id
					);

					debug(customer, 'client');
					debug(payment, 'payment');
					debug(transaction, 'transaction');

					variables.transactionID = transaction.data.id;

					statusTest(transaction);
					clientTest(customer.data, '^client_*', variables.emailAddress, variables.name);
					paymentTest(payment.data, '^pay_*'
						,variables.type
						,variables.card_type
						,variables.country
						,variables.last4
						,variables.expiryMonth
						,variables.expiryYear);
					transactionTest(transaction.data, '^tran_*'
						,variables.amount
						,variables.currency
					);
					dateTest(transaction.data.created_at);
					dateTest(transaction.data.updated_at);
				});
			});

			describe('...getTransaction()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with Transaction ID.', function() {
					var transaction = application.cfPaymill.getTransaction(variables.transactionID);

					statusTest(transaction);
					transactionTest(transaction.data, '^tran_*'
						,variables.amount
						,variables.currency
					);
					dateTest(transaction.data.created_at);
					dateTest(transaction.data.updated_at);
				});
			});
		});
	}
}