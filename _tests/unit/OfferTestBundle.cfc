component extends='cfPaymillTests.BaseTestBundle' {
	function beforeAll() {
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	function run() {
		describe('Offer...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {
				structDelete(variables, 'response');
			});

			describe('...getOffers()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...returns an array of offers.', function() {
					variables.response = application.cfPaymill.getOffers();

					statusTest(variables.response);

					expect(variables.response.data).toBeArray();
				});
			});

			describe('...addOffer()...', function() {
				variables.amount = 101;
				variables.currency = 'GBP';
				variables.interval = '1 day';
				variables.name = '#variables.interval# offer of #variables.amount# #variables.currency#'

				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {
					var response = application.cfPaymill.deleteOffer(variables.response.data.id);

					structDelete(variables, 'response');
				});

				it('...with amount (#variables.amount#), currency ("#variables.currency#"), interval ("#variables.interval#") and name ("#variables.name#").', function() {
					variables.response = application.cfPaymill.addOffer(amount=variables.amount, currency=variables.currency, interval=variables.interval, name=variables.name);

					statusTest(variables.response);
					offerTest(variables.response.data, '^offer_*', variables.amount, variables.currency, variables.interval, variables.name);
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});
			});

			describe('...getOffer()...', function() {
				variables.amount = 102;
				variables.currency = 'EUR';
				variables.interval = '2 week';
				variables.name = '#variables.interval# offer of #variables.amount# #variables.currency#'

				beforeEach(function(currentSpec) {
					variables.response = application.cfPaymill.addOffer(amount=variables.amount, currency=variables.currency, interval=variables.interval, name=variables.name);
				});

				afterEach(function(currentSpec) {
					var response = application.cfPaymill.deleteOffer(variables.response.data.id);


					structDelete(variables, 'response');
				});

				it('...with amount (#variables.amount#), currency ("#variables.currency#"), interval ("#variables.interval#") and name ("#variables.name#").', function() {
					var offer = application.cfPaymill.getOffer(variables.response.data.id);

					statusTest(offer);
					offerTest(offer.data, '^offer_*', variables.amount, variables.currency, variables.interval, variables.name);
					dateTest(offer.data.created_at);
					dateTest(offer.data.updated_at);
				});
			});

			describe('...deleteOffer()...', function() {
				variables.amount = 103;
				variables.currency = 'CHF';
				variables.interval = '3 month';
				variables.name = '#variables.interval# offer of #variables.amount# #variables.currency#'

				beforeEach(function(currentSpec) {
					variables.response = application.cfPaymill.addOffer(amount=variables.amount, currency=variables.currency, interval=variables.interval, name=variables.name);
				});

				afterEach(function(currentSpec) {
					structDelete(variables, 'response');
				});

				it('...with amount (#variables.amount#), currency ("#variables.currency#"), interval ("#variables.interval#") and name ("#variables.name#").', function() {
					var offer = application.cfPaymill.deleteOffer(variables.response.data.id);

					statusTest(offer);
					expect(offer.data).toBeArray();
					expect(offer.data).toBeEmpty();
				});
			});

			describe('...updateOffer()...', function() {
				variables.amount = 105;
				variables.currency = 'EUR';
				variables.interval = '3 month';
				variables.nameOriginal = '#variables.interval# offer of #variables.amount# #variables.currency#'
				variables.name = 'Offer name updated';

				beforeEach(function(currentSpec) {
					variables.response = application.cfPaymill.addOffer(amount=variables.amount, currency=variables.currency, interval=variables.interval, name=variables.nameOriginal);
				});

				afterEach(function(currentSpec) {
					var response = application.cfPaymill.deleteOffer(variables.response.data.id);

					structDelete(variables, 'response');
				});

				it('...update name to "#variables.name#"', function() {
					variables.response = application.cfPaymill.updateOffer(variables.response.data.id, variables.name);

					statusTest(variables.response);
					offerTest(variables.response.data, '^offer_*', variables.amount, variables.currency, variables.interval, variables.name);
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});
			});
		});
	}
}