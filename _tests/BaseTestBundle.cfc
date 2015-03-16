component extends='testbox.system.BaseSpec' {
	function beforeAll() {
		var privateTestKey = 'myPrivateKey';
		var publicTestKey = 'myPublicKey';

		application.cfPaymill =  new cfpaymill.cfPaymill(privateKey=privateTestKey
			,publicKey=publicTestKey
			,logfile=expandPath('../') & 'cfPaymill.log'
			,apiEndpoint='https://api.paymill.com/v2/');
	}

	function afterAll() {
	}

	function run() {
		var options = deserializeJSON(url.options);

		variables.name = options.name;
		variables.emailAddress = options.emailAddress;

		variables.type = options.type;
		variables.cardNumber = options.cardNumber;
		variables.cvc = options.cvc;

		variables.expiryMonth = options.expiryMonth;
		variables.expiryYear = options.expiryYear;

		variables.amount = options.amount;
		variables.currency = options.currency;
		variables.interval = options.interval;
		variables.validity = options.validity;

		variables.card_type = options.brand;
		variables.last4 = options.last4;
		variables.country = options.binCountry;

		variables.token = options.token;
	}

	private void function clientTest(required struct data, required string id, required string email, required string description) {
		expect(arguments.data).toBeStruct();

		expect(arguments.data.id).toMatch(arguments.id, 'ID expected to be like "#arguments.id#" but returned "#arguments.data.id#"');
		expect(arguments.data.email).toBe(arguments.email, 'Email expected to be "#arguments.email#" but returned "#arguments.data.email#"');
		expect(arguments.data.description).toBe(arguments.description, 'Description expected to be "#arguments.description#" but returned "#arguments.data.description#"');
	}

	private void function offerTest(required struct data, required string id, required numeric amount, required string currency, required string interval, required string name) {
		expect(arguments.data).toBeStruct();

		expect(arguments.data.id).toMatch(arguments.id, 'ID expected to be like "#arguments.id#" but returned "#arguments.data.id#"');
		expect(arguments.data.amount).toBe(arguments.amount, 'Amount expected to be "#arguments.amount#" but returned "#arguments.data.amount#"');
		expect(arguments.data.currency).toBe(arguments.currency, 'Currency expected to be "#arguments.currency#" but returned "#arguments.data.currency#"');
		expect(arguments.data.interval).toBe(arguments.interval, 'Interval expected to be "#arguments.interval#" but returned "#arguments.data.interval#"');
		expect(arguments.data.name).toBe(arguments.name, 'Name expected to be "#arguments.name#" but returned "#arguments.data.name#"');

		expect(arguments.data.trial_period_days).toBe(0, 'Trial Period Days expected to be "0" but returned "#arguments.data.trial_period_days#"');
		expect(arguments.data.subscription_count).toBeStruct();
		expect(arguments.data.subscription_count.active).toBe(0, 'Active Subscription Count expected to be "0" but returned "#arguments.data.subscription_count.active#"');
		expect(arguments.data.subscription_count.inactive).toBe(0, 'Inactive Subscription Count expected to be "0" but returned "#arguments.data.subscription_count.active#"');
	}

	private void function paymentTest(required struct data, required string id, required string type, required string card_type, required string country, required string last4, required string expire_month, required string expire_year) {
		expect(arguments.data).toBeStruct();

		expect(arguments.data.id).toMatch(arguments.id, 'ID expected to be like "#arguments.id#" but returned "#arguments.data.id#"');
		expect(arguments.data.type).toBe(arguments.type, 'Type expected to be "#arguments.type#" but returned "#arguments.data.type#"');
		expect(arguments.data.card_type).toBe(arguments.card_type, 'Card Type expected to be "#arguments.card_type#" but returned "#arguments.data.card_type#"');
		expect(arguments.data.country).toBe(arguments.country, 'Country expected to be "#arguments.country#" but returned "#arguments.data.country#"');
		expect(arguments.data.last4).toBe(arguments.last4, 'Last 4 expected to be "#arguments.last4#" but returned "#arguments.data.last4#"');
		expect(arguments.data.expire_month).toBe(arguments.expire_month, 'Expiry Month expected to be "#arguments.expire_month#" but returned "#arguments.data.expire_month#"');
		expect(arguments.data.expire_year).toBe(arguments.expire_year, 'Expiry Year expected to be "#arguments.expire_year#" but returned "#arguments.data.expire_year#"');
	}

	private void function preauthorizationTest(required struct data, required string id, required string amount, required string currency) {
		expect(arguments.data).toBeStruct();

		expect(arguments.data.id).toMatch(arguments.id, 'ID expected to be like "#arguments.id#" but returned "#arguments.data.id#"');
		expect(arguments.data.amount).toBe(arguments.amount, 'Amount expected to be "#arguments.amount#" but returned "#arguments.data.amount#"');
		expect(arguments.data.currency).toBe(arguments.currency, 'Currency expected to be "#arguments.currency#" but returned "#arguments.data.currency#"');
	}

	private void function transactionTest(required struct data, required string id, required string amount, required string currency) {
		expect(arguments.data).toBeStruct();

		expect(arguments.data.id).toMatch(arguments.id, 'ID expected to be like "#arguments.id#" but returned "#arguments.data.id#"');
		expect(arguments.data.amount).toBe(arguments.amount, 'Amount expected to be "#arguments.amount#" but returned "#arguments.data.amount#"');
		expect(arguments.data.currency).toBe(arguments.currency, 'Currency expected to be "#arguments.currency#" but returned "#arguments.data.currency#"');
	}

	private void function subscriptionTest(required struct data, required string id, required struct offer, required struct payment, boolean cancelled=false, any startDate='') {
		expect(arguments.data).toBeStruct();

		expect(arguments.data.id).toMatch(arguments.id, 'ID expected to be like "#arguments.id#" but returned "#arguments.data.id#"');
		expect(arguments.offer).toBeStruct();
		expect(arguments.offer).toBe(arguments.data.offer, 'Expected Offer not the same as the returned Offer');
		// expect(arguments.payment).toBe(arguments.data.payment, 'Expected Payment not the same as the returned Payment');

// removed in v2.1
		// expect(arguments.cancelled).toBe(arguments.data.cancel_at_period_end, 'Expected Cancel At Period End not the same as the returned');

		if (isDate(arguments.startDate)) {
			expect(arguments.startDate).toBeCloseTo(arguments.data.next_capture_at, 5, 's', 'Expected Next Capture At not the same as the returned');
		}
	}

	private void function subscriptionWithoutOfferTest(required struct data, required string id, required struct payment, boolean cancelled=false, any startDate='') {
		expect(arguments.data).toBeStruct();

		expect(arguments.data.id).toMatch(arguments.id, 'ID expected to be like "#arguments.id#" but returned "#arguments.data.id#"');
		expect(arguments.payment).toBeStruct();

// for some reason a Payment doesn't have the Client that is automatically added by a Subscription?????
		// expect(arguments.payment).toBe(arguments.data.payment, 'Expected Payment not the same as the returned Payment');

// removed in v2.1
		// expect(arguments.cancelled).toBe(arguments.data.cancel_at_period_end, 'Expected Cancel At Period End not the same as the returned');

		if (isDate(arguments.startDate)) {
			expect(arguments.startDate).toBeCloseTo(arguments.data.next_capture_at, 5, 's', 'Expected Next Capture At not the same as the returned');
		}
	}


	private void function statusTest(required any response) {
		expect(arguments.response).toBeStruct();

		expect(arguments.response.code).toBe(200);
		expect(arguments.response.status).toBeWithCase('OK');
		expect(arguments.response.success).toBeTrue();
	}

	private void function dateTest(required any dateToTest) {
		expect(arguments.dateToTest).toBeDate();
		expect(arguments.dateToTest).toBeCloseTo(now(), 10, 's');
	}
}