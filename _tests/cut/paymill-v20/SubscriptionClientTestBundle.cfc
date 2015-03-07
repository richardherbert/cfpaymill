component extends='cfPaymillTests.cut.paymill-v20.V20TestBundle' {
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

				it('...with token (#variables.token#) and new Client.', function() {
					var offer = application.cfPaymill.addOffer(amount=variables.amount, currency=variables.currency, interval='1 day', name='1 day');
					var payment = application.cfPaymill.addPayment(token=variables.token);
					var customer = application.cfPaymill.addClient(email=variables.emailaddress, description=variables.name);

					variables.offerID = offer.data.id;
					variables.paymentID = payment.data.id;
					variables.customerID = customer.data.id;

					var subscription = application.cfPaymill.addSubscription(offer=offer.data.id, payment=payment.data.id, client=variables.customerID);

debug( payment );
debug( customer );
debug( subscription );

// recall the new Offer and Payment as they will be updated by the Subscription
					variables.offer = application.cfPaymill.getOffer(variables.offerID);
					variables.payment = application.cfPaymill.getPayment(variables.paymentID);

					variables.subscriptionID = subscription.data.id;

					statusTest(subscription);
					subscriptionTest(subscription.data, '^sub_*'
						,variables.offer.data
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
					subscriptionTest(subscription.data, '^sub_*'
						,variables.offer.data
						,variables.payment.data
					);
					dateTest(subscription.data.created_at);
					dateTest(subscription.data.updated_at);
				});
			});

			describe('...getSubscriptions()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...returns an array of subscriptions.', function() {
					var subscription = application.cfPaymill.getSubscriptions();

					statusTest(subscription);

					expect(subscription.data).toBeArray();
				});
			});

			describe('...updateSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...cancel Subscription.', function() {
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

			describe('...deleteSubscription()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {
					application.cfPaymill.deleteOffer(variables.offerID);
					application.cfPaymill.deletePayment(variables.paymentID);
					application.cfPaymill.deleteClient(variables.customerID);
				});

				it('...with Subscription ID.', function() {
					var subscription = application.cfPaymill.deleteSubscription(variables.subscriptionID);
					var subscriptionDeleted = application.cfPaymill.getSubscription(variables.subscriptionID);

					statusTest(subscription);

					expect(subscription.data).toBe(subscriptionDeleted.data, 'Expected Subscription not the same as the returned Subscription');
				});
			});
		});
	}
}