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

				it('...with token (#variables.token#) and Offer.', function() {
					variables.offer = application.cfPaymill.addOffer(amount=variables.amount, currency=variables.currency, interval='1 day', name='1 day');
					variables.payment = application.cfPaymill.addPayment(token=variables.token);

					variables.offerID = variables.offer.data.id;
					variables.paymentID = variables.payment.data.id;

					var subscription = application.cfPaymill.addSubscription(payment=variables.paymentID, offer=variables.offerID);

debug( subscription, 'subscription' );

// recall the new Offer and Payment as they will be updated by the Subscription
					variables.offer = application.cfPaymill.getOffer(variables.offerID);
					variables.payment = application.cfPaymill.getPayment(variables.paymentID);

debug( variables.offer, 'offer' );
debug( variables.payment, 'payment' );

					statusTest(subscription);

					variables.subscriptionID = subscription.data.id;

					subscriptionTest(subscription.data, '^sub_*'
						,variables.offer.data
						,variables.payment.data
					);
					dateTest(subscription.data.created_at);
					dateTest(subscription.data.updated_at);
				});
			});

			xdescribe('...getSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...with Subscription ID.', function() {
					var subscription = application.cfPaymill.getSubscription(variables.subscriptionID);

					statusTest(subscription);
					subscriptionTest(subscription.data, '^sub_*'
						,variables.offer.data
						,variables.payment.data
					);
					dateTest(subscription.data.created_at);
					dateTest(subscription.data.updated_at);
				});
			});


			xdescribe('...updateSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...cancel Subscription.', function() {

var subscription = application.cfPaymill.getSubscription(variables.subscriptionID);

debug( subscription, 'subscription' );


					var subscription = application.cfPaymill.updateSubscription(id=variables.subscriptionID
						,cancel=true
						,payment=variables.paymentID
					);

					statusTest(subscription);
					subscriptionTest(subscription.data, '^sub_*'
						,variables.offer.data
						,variables.payment.data
						,true
					);
					dateTest(subscription.data.created_at);
					dateTest(subscription.data.updated_at);
				});
			});


			xdescribe('...deleteSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {
					application.cfPaymill.deleteOffer(variables.offerID);
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