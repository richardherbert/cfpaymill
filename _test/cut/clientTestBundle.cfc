component extends='testbox.system.BaseSpec' {
	function beforeAll() {
		application.cfPaymill = new cfpaymill.cfPaymill(privateKey='myPrivateKey'
			,publicKey='myPublicKey'
		);
	}

	function afterAll() {
		structDelete(application, 'cfPaymill');
	}

	function run() {
		describe('Client...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {
				structDelete(variables, 'response');
			});

			it('...getClients() returns a structure of status checks and an array of clients.', function() {
				variables.response = application.cfPaymill.getClients();

				expect(variables.response).toBeStruct();

				expect(variables.response.code).toBe(200);
				expect(variables.response.status).toBeWithCase('OK');
				expect(variables.response.success).toBeTrue();

				expect(variables.response.data).toBeArray();
			});

			describe('...addClient()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {
					var response = application.cfPaymill.deleteClient(variables.response.data.id);

					structDelete(variables, 'response');
				});

				it('...with no arguments.', function() {
					variables.response = application.cfPaymill.addClient();

					expect(variables.response).toBeStruct();

					expect(variables.response.code).toBe(200);
					expect(variables.response.status).toBeWithCase('OK');
					expect(variables.response.success).toBeTrue();

					expect(variables.response.data).toBeStruct();

					expect(variables.response.data.id).toMatch('^client_*', 'ID like client_* expected but returned "#variables.response.data.id#"');
					expect(variables.response.data.email).toBe('');
					expect(variables.response.data.description).toBe('');

					expect(variables.response.data.created_at).toBeDate();
					expect(variables.response.data.updated_at).toBeDate();

					expect(variables.response.data.created_at).toBeCloseTo(now(), 10, 's');
					expect(variables.response.data.updated_at).toBeCloseTo(now(), 10, 's');
				});

				it('...with email address ("jack@nicholson.com") only.', function() {
					variables.response = application.cfPaymill.addClient(email='jack@nicholson.com');

					expect(variables.response).toBeStruct();

					expect(variables.response.code).toBe(200);
					expect(variables.response.status).toBeWithCase('OK');
					expect(variables.response.success).toBeTrue();

					expect(variables.response.data).toBeStruct();

					expect(variables.response.data.id).toMatch('^client_*', 'ID like client_* expected but returned "#variables.response.data.id#"');
					expect(variables.response.data.email).toBe('jack@nicholson.com');
					expect(variables.response.data.description).toBe('');

					expect(variables.response.data.created_at).toBeDate();
					expect(variables.response.data.updated_at).toBeDate();

					expect(variables.response.data.created_at).toBeCloseTo(now(), 10, 's');
					expect(variables.response.data.updated_at).toBeCloseTo(now(), 10, 's');
				});

				it('...with description ("I am a description") only.', function() {
					variables.response = application.cfPaymill.addClient(description='I am a description');

					expect(variables.response).toBeStruct();

					expect(variables.response.code).toBe(200);
					expect(variables.response.status).toBeWithCase('OK');
					expect(variables.response.success).toBeTrue();

					expect(variables.response.data).toBeStruct();

					expect(variables.response.data.id).toMatch('^client_*', 'ID like client_* expected but returned "#variables.response.data.id#"');
					expect(variables.response.data.email).toBe('');
					expect(variables.response.data.description).toBe('I am a description');

					expect(variables.response.data.created_at).toBeDate();
					expect(variables.response.data.updated_at).toBeDate();

					expect(variables.response.data.created_at).toBeCloseTo(now(), 10, 's');
					expect(variables.response.data.updated_at).toBeCloseTo(now(), 10, 's');
				});

				it('...with email ("john@hurt.com") and description ("I am another description").', function() {
					variables.response = application.cfPaymill.addClient(email='john@hurt.com', description='I am another description');

					expect(variables.response).toBeStruct();

					expect(variables.response.code).toBe(200);
					expect(variables.response.status).toBeWithCase('OK');
					expect(variables.response.success).toBeTrue();

					expect(variables.response.data).toBeStruct();

					expect(variables.response.data.id).toMatch('^client_*', 'ID like client_* expected but returned "#variables.response.data.id#"');
					expect(variables.response.data.email).toBe('john@hurt.com');
					expect(variables.response.data.description).toBe('I am another description');

					expect(variables.response.data.created_at).toBeDate();
					expect(variables.response.data.updated_at).toBeDate();

					expect(variables.response.data.created_at).toBeCloseTo(now(), 10, 's');
					expect(variables.response.data.updated_at).toBeCloseTo(now(), 10, 's');
				});
			});
		});
	}
}