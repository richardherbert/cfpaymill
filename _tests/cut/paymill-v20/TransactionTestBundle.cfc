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
					var transaction = application.cfPaymill.addTransaction(amount=variables.amount
						,currency=variables.currency
						,token=variables.token
					);

					variables.transactionID = transaction.data.id;

					statusTest(transaction);
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

			describe('...getTransactions()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...returns an array of transactions.', function() {
					variables.response = application.cfPaymill.getTransactions();

					statusTest(variables.response);

					expect(variables.response.data).toBeArray();
				});
			});
		});
	}
}