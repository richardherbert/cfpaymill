/*
Copyright 2013 Richard Herbert

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

component output="false" displayname="cfPaymill" hint="I am a ColdFusion component that provides an interface to the Paymill API" {
/*
* @hint I am the intitialise method that is fired upon instantiation
*/
	public cfPaymill function init(required string privateKey, string publicKey="", string apiEndpoint="https://api.paymill.com/v2/") {
		variables.privateKey = arguments.privateKey;
		variables.publicKey = arguments.publicKey;
		variables.apiEndpoint = arguments.apiEndpoint;

		variables.charset = "utf-8";

		return this;
	}

/*
* @hint I return the current version number
*/
	public string function getVersion() {
		return "0.1.1";
	}

/*
* @hint I add a new Client
*/
	public struct function addClient(string email="", string description="") {
		var packet = {};

		packet.object = "clients";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="email", value=arguments.email});
		arrayAppend(packet.params, {name="description", value=arguments.description});

		return send(packet);
	}

/*
* @hint I update a Client
*/
	public struct function updateClient(required string id, string email="", string description="") {
		var packet = {};

		packet.id = arguments.id;
		packet.object = "clients";
		packet.method = "PUT";

		packet.params = [];

		arrayAppend(packet.params, {name="email", value=arguments.email});
		arrayAppend(packet.params, {name="description", value=arguments.description});

		return send(packet);
	}

/*
* @hint I return the selected Client
*/
	public struct function getClient(required string id) {
		return getObject("clients", arguments.id);
	}

/*
* @hint I return a list of Clients
*/
	public struct function getClients() {
		return getObjects(object="clients", params=arguments);
	}

/*
* @hint I delete the selected Client
*/
	public struct function deleteClient(required string id) {
		return deleteObject(object="clients", id=arguments.id);
	}

/*
* @hint I add a new Offer
*/
	public struct function addOffer(required numeric amount, required string currency, required string interval, required string name) {
		var packet = {};

		packet.object = "offers";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="amount", value=convertAmountToBase(arguments.amount)});
		arrayAppend(packet.params, {name="currency", value=arguments.currency});
		arrayAppend(packet.params, {name="interval", value=arguments.interval});
		arrayAppend(packet.params, {name="name", value=arguments.name});

		return send(packet);
	}

/*
* @hint I return the selected Offer
*/
	public struct function getOffer(required string id) {
		return getObject("offers", arguments.id);
	}

/*
* @hint I return a list of Offers
*/
	public struct function getOffers() {
		return getObjects(object="offers", params=arguments);
	}

/*
* @hint I update a Offer
*/
	public struct function updateOffer(required string id, required string name="") {
		var packet = {};

		packet.id = arguments.id;
		packet.object = "offers";
		packet.method = "PUT";

		packet.params = [];

		arrayAppend(packet.params, {name="name", value=arguments.name});

		return send(packet);
	}

/*
* @hint I delete the selected Offer
*/
	public struct function deleteOffer(required string id) {
		return deleteObject(object="offers", id=arguments.id);
	}

/*
* @hint I add a new Payment
*/
	public struct function addPayment(required string token, string client="") {
		var packet = {};

		packet.object = "payments";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="token", value=arguments.token});
		arrayAppend(packet.params, {name="client", value=arguments.client});

		return send(packet);
	}

/*
* @hint I return the selected Payment
*/
	public struct function getPayment(required string id) {
		return getObject("payments", arguments.id);
	}

/*
* @hint I return a list of Payments
*/
	public struct function getPayments() {
		return getObjects(object="payments", params=arguments);
	}

/*
* @hint I add a new Preauthorization
*/
	public struct function addPreauthorization(required numeric amount, required string currency, string token, string payment) {
		var packet = {};
		var result = {};
		var error = {};

		packet.object = "preauthorizations";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="amount", value=convertAmountToBase(arguments.amount)});
		arrayAppend(packet.params, {name="currency", value=arguments.currency});

		if (trim(arguments.token) != "" && trim(arguments.payment) != "") {
			result["success"] = false;
			result["code"] = 0;
			result["status"] = "Argument mismatch";

			result["error"] = {};
			result.error["field"] = "token,payment";

			result.error["messages"] = {};
			result.error.messages["token"] = "Token argument must not be provided if the Payment argument is also provided";
			result.error.messages["payment"] = "Payment argument must not be provided if the Token argument is also provided";

			return result;
		} else if (trim(arguments.token) != "") {
			arrayAppend(packet.params, {name="token", value=arguments.token});
		} else if (trim(arguments.payment) != "") {
			arrayAppend(packet.params, {name="payment", value=arguments.payment});
		} else {
			result["success"] = false;
			result["code"] = 0;
			result["status"] = "Missing argument";

			result["error"] = {};
			result.error["field"] = "token,payment";

			result.error["messages"] = {};
			result.error.messages["token"] = "Either the Token argument or Payment argument must be provided";
			result.error.messages["payment"] = "Either the Payment argument or Token argument must be provided";

			return result;
		}

		return send(packet);
	}

/*
* @hint I return the selected Preauthorization
*/
	public struct function getPreauthorization(required string id) {
		return getObject("preauthorizations", arguments.id);
	}

/*
* @hint I return a list of Preauthorizations
*/
	public struct function getPreauthorizations() {
		return getObjects(object="preauthorizations", params=arguments);
	}

/*
* @hint I delete the selected Preauthorization
*/
	public struct function deletePreauthorization(required string id) {
		return deleteObject(object="preauthorizations", id=arguments.id);
	}

/*
* @hint I add a new Refund
*/
	public struct function addRefund(required string transaction, required numeric amount, required string description) {
		var packet = {};

		packet.object = "refunds";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="id", value=arguments.transaction});
		arrayAppend(packet.params, {name="amount", value=convertAmountToBase(arguments.amount)});
		arrayAppend(packet.params, {name="description", value=arguments.description});

		return send(packet);
	}

/*
* @hint I return the selected Refund
*/
	public struct function getRefund(required string id) {
		return getObject("refunds", arguments.id);
	}

/*
* @hint I return a list of Refunds
*/
	public struct function getRefunds() {
		return getObjects(object="refunds", params=arguments);
	}

/*
* @hint I add a new Subscription
*/
	public struct function addSubscription(required string client, required string offer, required string payment) {
		var packet = {};

		packet.object = "subscriptions";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="client", value=arguments.client});
		arrayAppend(packet.params, {name="offer", value=arguments.offer});
		arrayAppend(packet.params, {name="payment", value=arguments.payment});

		return send(packet);
	}

/*
* @hint I update a Subscription
*/
	public struct function updateSubscription(required string id, required boolean cancel, required string offer) {
		var packet = {};

		packet.id = arguments.id;
		packet.object = "subscriptions";
		packet.method = "PUT";

		packet.params = [];

		arrayAppend(packet.params, {name="cancel_at_period_end", value=arguments.cancel});
		arrayAppend(packet.params, {name="offer", value=arguments.offer});

		return send(packet);
	}

/*
* @hint I return the selected Subscription
*/
	public struct function getSubscription(required string id) {
		return getObject("subscriptions", arguments.id);
	}

/*
* @hint I return a list of Subscriptions
*/
	public struct function getSubscriptions() {
		return getObjects(object="refunds", params=arguments);
	}

/*
* @hint I delete the selected Subscription
*/
	public struct function deleteSubscription(required string id) {
		return deleteObject(object="subscriptions", id=arguments.id);
	}

/*
* @hint I create a new Transaction
*/
	public struct function addTransaction(required numeric amount, required string currency, string token="", string payment="", string preauthorization="", string client="", string description="") {
		var packet = {};
		var result = {};

		packet.object = "transactions";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="amount", value=convertAmountToBase(arguments.amount)});
		arrayAppend(packet.params, {name="currency", value=arguments.currency});

		if (arguments.token != "") {
			arrayAppend(packet.params, {name="token", value=arguments.token});
		} else if (arguments.preauthorization != "") {
			arrayAppend(packet.params, {name="preauthorization", value=arguments.preauthorization});
		} else if (arguments.payment != "" && arguments.client != "") {
			arrayAppend(packet.params, {name="payment", value=arguments.payment});
			arrayAppend(packet.params, {name="client", value=arguments.client});
		} else if (arguments.payment != "") {
			arrayAppend(packet.params, {name="payment", value=arguments.payment});
		} else {
			result["success"] = false;
			result["code"] = 0;
			result["status"] = "Argument mismatch";

			result["error"] = {};
			result.error["field"] = "token,payment";

			result.error["messages"] = {};
			result.error.messages["token"] = "Token argument must not be provided if the Payment argument is also provided";
			result.error.messages["payment"] = "Payment argument must not be provided if the Token argument is also provided";

			return result;
		}

		arrayAppend(packet.params, {name="description", value=arguments.description});

		return send(packet);
	}

/*
* @hint I return a list of Transactions
*/
	public struct function getTransactions() {
		return getObjects(object="transactions", params=arguments);
	}

/*
* @hint I return the selected Object
*/
	private struct function getObject(required string object, required string id) {
		var packet = {};

		packet.object = arguments.object;
		packet.method = "GET";
		packet.id = arguments.id;

		return send(packet);
	}

/*
* @hint I return a list of Objects
*/
	private struct function getObjects(required string object, struct params={}) {
		var packet = {};
		var param = "";

		packet.object = arguments.object;
		packet.method = "GET";
		packet.params = [];

		for (param in arguments.params) {
			if (params[param] != "" && params[param] != 0) {
				arrayAppend(packet.params, {name=param, value=params[param]});
			}
		}

		return send(packet);
	}

/*
* @hint I delete the selected Object
*/
	private struct function deleteObject(required string object, required string id) {
		var packet = {};

		packet.object = arguments.object;
		packet.method = "DELETE";
		packet.id = arguments.id;

		return send(packet);
	}

	private struct function send(required struct inboundPacket) {
		var packet = arguments.inboundPacket;
		var param = "";
		var bodyValue = "";
		var response = "";
		var httpService = new http();

		param name="packet.id" default="";
		param name="packet.method" default="GET";
		param name="packet.params" default=[];

		var endpointURL = variables.apiEndpoint & packet.object & "/";

		switch(packet.method){
			case "POST":
			case "PUT":
				if (packet.id != "") {
					endpointURL &= packet.id;
				}

				httpService.addParam(name="Content-Type", type="header", value="application/x-www-form-urlencoded; charset=UTF-8");

				for (param in packet.params) {
					bodyValue = listAppend(bodyValue, "#param.name#=#urlEncodedFormat(param.value)#", "&");
				}

				httpService.addParam(type="body", value=bodyValue);
			break;

			case "GET":
				if (packet.id == "") {
// append filters and sort params to the URL
					for (param in packet.params) {
						endpointURL = listAppend(endpointURL, "#param.name#=#urlEncodedFormat(param.value)#", "&");
					}

// replace the first & with ? so the URL is compliant
					endpointURL = replaceNoCase(endpointURL, "&", "?", "one");
				} else {
					endpointURL &= packet.id;
				}
			break;

			case "DELETE":
				endpointURL &= packet.id;
			break;
		}

		httpService.setUsername(variables.privateKey);
		httpService.setPassword(variables.privateKey);
		httpService.setCharset(variables.charset);
		httpService.setURL(endpointURL);
		httpService.setMethod(packet.method);

		response = httpService.send().getPrefix();

		return processResponse(response);
	}

	private struct function processResponse(required struct response) {
		var result = {};
		var data = {};
		var createdDate = {};
		var updatedDate = {};
		var newValue = {};
		var createdDates = "";
		var updatedDates = "";
		var fileContentJSON = "";
		var statusCode = "";

		if (server.coldfusion.productName == "ColdFusion Server") {
			fileContentJSON = response.filecontent.toString();
			statusCode = response.responseHeader.status_code;
			statusText = response.responseHeader.explanation;
		} else {
			fileContentJSON = response.filecontent;
			statusCode = response.status_code;
			statusText = response.status_text;
		}

		if (statusCode == "200") {
			result["success"] = true;

// replace all the "null" values in the JSON packet with a ColdFusion empty string
			fileContentJSON = reReplaceNoCase(fileContentJSON, ':null', ':""', "all");

			result["data"] = deserializeJSON(fileContentJSON).data;

			if (isArray(result.data)) {
				for (data in result.data) {
					createdDates = structFindKey(data, "created_at", "all");

					for (createdDate in createdDates) {
						newValue = getDate(createdDate.value);

						structUpdate(createdDate.owner, "created_at", newValue);
					}

					updatedDates = structFindKey(data, "updated_at", "all");

					for (updatedDate in updatedDates) {
						newValue = getDate(updatedDate.value);

						structUpdate(updatedDate.owner, "updated_at", newValue);
					}
				}
			} else {
				createdDates = structFindKey(result.data, "created_at", "all");

				for (createdDate in createdDates) {
					newValue = getDate(createdDate.value);

					structUpdate(createdDate.owner, "created_at", newValue);
				}

				updatedDates = structFindKey(result.data, "updated_at", "all");

				for (updatedDate in updatedDates) {
					newValue = getDate(updatedDate.value);

					structUpdate(updatedDate.owner, "updated_at", newValue);
				}
			}

		} else {
			result["success"] = false;

			result["error"] = deserializeJSON(fileContentJSON).error;
		}

		result["code"] = statusCode;
		result["status"] = statusText;

		return result;
	}

/*
* @hint I convert the base unit amount to a currency amount
*/
	private numeric function convertAmountFromBase(required numeric amount) {
		return arguments.amount / 100;
	}

/*
* @hint I convert the amount to the base currency unit
*/
	private numeric function convertAmountToBase(required numeric amount) {
		return int(arguments.amount * 100);
	}

/*
* @hint I return a ColdFusion Date type when given a Unix Epoch timestamp integer
*/
	private date function getDate(required numeric timestamp) {
// Epoch datetime returned by Paymill is UTC. Convert to locale.

// http://rob.brooks-bilson.com/index.cfm/2007/10/11/Some-Notes-on-Using-Epoch-Time-in-ColdFusion
// http://cflib.org/udf/EpochTimeToLocalDate
// http://www.epochconverter.com/epoch/timezones.php

		return dateAdd("s", arguments.timestamp, dateConvert("utc2Local", createDate(1970, 1, 1)));
	}
}