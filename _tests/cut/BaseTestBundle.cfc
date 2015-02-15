component extends='testbox.system.BaseSpec' {
	function beforeAll() {
		var privateTestKey = 'myPrivateKey';
		var publicTestKey = 'myPublicKey';

		return local;
	}

	function afterAll() {
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