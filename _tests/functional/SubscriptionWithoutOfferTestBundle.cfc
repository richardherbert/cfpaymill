component extends='cfPaymillTests.BaseTestBundle' {
	function beforeAll() {
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	function run() {
		super.run();

		describe('Subscription...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {});

			describe('...addSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with token (#variables.token#) and Amount (#variables.amount#), Currency (#variables.currency#) and Interval (#variables.interval#).', function() {
					variables.payment = application.cfPaymill.addPayment(token=variables.token);

// debug( variables.payment, 'payment' );

					variables.paymentID = variables.payment.data.id;

					var subscription = application.cfPaymill.addSubscription(payment=variables.paymentID
						,amount=variables.amount
						,currency=variables.currency
						,interval=variables.interval
						,validity=variables.validity
					);

// debug( subscription, 'subscription' );
// debug( variables.payment, 'payment' );
// debug( subscription.data.payment, 'subscription.data.payment' );

					statusTest(subscription);

					variables.subscriptionID = subscription.data.id;

					subscriptionWithoutOfferTest(subscription.data, '^sub_*'
						,variables.payment.data
					);
					dateTest(subscription.data.created_at);
					dateTest(subscription.data.updated_at);
				});
			});

			describe('...getSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with Subscription ID.', function() {
					var subscription = application.cfPaymill.getSubscription(variables.subscriptionID);

					statusTest(subscription);
					subscriptionWithoutOfferTest(subscription.data, '^sub_*'
						,variables.payment.data
					);
					dateTest(subscription.data.created_at);
					dateTest(subscription.data.updated_at);
				});
			});

			describe('...deleteSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {
					application.cfPaymill.deletePayment(variables.paymentID);
				});

				it('...with Subscription ID.', function() {
					var subscription = application.cfPaymill.deleteSubscription(variables.subscriptionID);
					var subscriptionDeleted = application.cfPaymill.getSubscription(variables.subscriptionID);

// debug( subscription, 'subscription' );

					statusTest(subscription);

					expect(subscription.data).toBe(subscriptionDeleted.data, 'Expected Subscription not the same as the returned Subscription');
					expect(subscription.data.is_canceled).toBeTrue('Expected Subscription is_canceled to be true');
					expect(subscription.data.is_deleted).toBeTrue('Expected Subscription is_deleted to be true');
				});
			});
		});
	}
}