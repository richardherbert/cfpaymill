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

				it('...with Preauthorization, amount (#variables.amount#) and currency (#variables.currency#).', function() {
					var preauthorization = application.cfPaymill.addPreauthorization(amount=variables.amount
						,currency=variables.currency
						,token=variables.token
					);

					var transaction = application.cfPaymill.addTransaction(amount=variables.amount
						,currency=variables.currency
						,preauthorization=preauthorization.data.preauthorization.id
					);

					debug(preauthorization, 'preauthorization');
					debug(transaction, 'transaction');

					variables.transactionID = transaction.data.id;

					statusTest(transaction);
					preauthorizationTest(preauthorization.data
						,'^tran_*'
						,variables.amount
						,variables.currency
					);
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