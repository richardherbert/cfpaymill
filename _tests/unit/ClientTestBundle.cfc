component extends='cfPaymillTests.BaseTestBundle' {
	function beforeAll() {
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	function run() {
		describe('Client...', function() {
			beforeEach(function(currentSpec) {});

			afterEach(function(currentSpec) {});

			describe('...getClients()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {});

				it('...returns an array of clients.', function() {
					variables.response = application.cfPaymill.getClients();

					statusTest(variables.response);

					expect(variables.response.data).toBeArray();
				});
			});

			describe('...addClient()...', function() {
				beforeEach(function(currentSpec) {});

				afterEach(function(currentSpec) {
					var response = application.cfPaymill.deleteClient(variables.response.data.id);

					structDelete(variables, 'response');
				});

				it('...with no arguments.', function() {
					variables.response = application.cfPaymill.addClient();

					statusTest(variables.response);
					clientTest(variables.response.data, '^client_*', '', '');
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});

				it('...with email address ("jack@nicholson.com") only.', function() {
					variables.response = application.cfPaymill.addClient(email='jack@nicholson.com');

					statusTest(variables.response);
					clientTest(variables.response.data, '^client_*', 'jack@nicholson.com', '');
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});

				it('...with description ("I am a description") only.', function() {
					variables.response = application.cfPaymill.addClient(description='I am a description');

					statusTest(variables.response);
					clientTest(variables.response.data, '^client_*', '', 'I am a description');
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});

				it('...with email ("john@hurt.com") and description ("I am another description").', function() {
					variables.response = application.cfPaymill.addClient(email='john@hurt.com', description='I am another description');

					statusTest(variables.response);
					clientTest(variables.response.data, '^client_*', 'john@hurt.com', 'I am another description');
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});
			});

			describe('...getClient()...', function() {
				beforeEach(function(currentSpec) {
					variables.response = application.cfPaymill.addClient(email='jennifer@lawrence.com', description='My name is Jennifer Lawrence');
				});

				afterEach(function(currentSpec) {
					var response = application.cfPaymill.deleteClient(variables.response.data.id);

					structDelete(variables, 'response');
				});

				it('...with email ("jennifer@lawrence.com") and description ("My name is Jennifer Lawrence").', function() {
					var customer = application.cfPaymill.getClient(variables.response.data.id);

					statusTest(customer);
					clientTest(customer.data, '^client_*', 'jennifer@lawrence.com', 'My name is Jennifer Lawrence');
					dateTest(customer.data.created_at);
					dateTest(customer.data.updated_at);
				});
			});

			describe('...deleteClient()...', function() {
				beforeEach(function(currentSpec) {
					variables.response = application.cfPaymill.addClient(email='rosamund@pike.com', description='My name is Rosamund Pike');
				});

				afterEach(function(currentSpec) {
					structDelete(variables, 'response');
				});

				it('...with email ("rosamund@pike.com") and description ("My name is Rosamund Pike").', function() {
					var customer = application.cfPaymill.deleteClient(variables.response.data.id);

					statusTest(customer);
					expect(customer.data).toBeArray();
					// expect(customer.data).toBeEmpty();
				});
			});

			describe('...updateClient()...', function() {
				beforeEach(function(currentSpec) {
					variables.response = application.cfPaymill.addClient();
				});

				afterEach(function(currentSpec) {
					var response = application.cfPaymill.deleteClient(variables.response.data.id);

					structDelete(variables, 'response');
				});

				it('...update email only to "benedict@cumberbatch.com"', function() {
					variables.response = application.cfPaymill.updateClient(variables.response.data.id, 'benedict@cumberbatch.com');

					statusTest(variables.response);
					clientTest(variables.response.data, '^client_*', 'benedict@cumberbatch.com', '');
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});

				it('...update description only to "My name is Benedict Cumberbatch"', function() {
					variables.response = application.cfPaymill.updateClient(id=variables.response.data.id, description='My name is Benedict Cumberbatch');

					statusTest(variables.response);
					clientTest(variables.response.data, '^client_*', '', 'My name is Benedict Cumberbatch');
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});

				it('...update email to "ralph@fiennes.com" and description to "My name is Ralph Fiennes"', function() {
					variables.response = application.cfPaymill.updateClient(variables.response.data.id, 'ralph@fiennes.com', 'My name is Ralph Fiennes');

					statusTest(variables.response);
					clientTest(variables.response.data, '^client_*', 'ralph@fiennes.com', 'My name is Ralph Fiennes');
					dateTest(variables.response.data.created_at);
					dateTest(variables.response.data.updated_at);
				});
			});
		});
	}
}