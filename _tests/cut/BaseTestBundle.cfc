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