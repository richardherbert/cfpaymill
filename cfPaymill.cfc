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
	public cfPaymill function init(required string privateKey, string publicKey="", string apiEndpoint="https://api.paymill.com/v2/", string logfile="")
		hint="I am the intitialise method that is fired upon instantiation"
	{
		variables.privateKey = arguments.privateKey;
		variables.publicKey = arguments.publicKey;
		variables.apiEndpoint = arguments.apiEndpoint;

		variables.logfile = arguments.logfile;

		variables.charset = "utf-8";

		variables.epochDatesToConvert = [];

		arrayAppend(variables.epochDatesToConvert, '"created_at":(\d*)');
		arrayAppend(variables.epochDatesToConvert, '"updated_at":(\d*)');
		arrayAppend(variables.epochDatesToConvert, '"next_capture_at":(\d*)');
		arrayAppend(variables.epochDatesToConvert, '"canceled_at":(\d*)');
		arrayAppend(variables.epochDatesToConvert, '"trial_start":(\d*)');
		arrayAppend(variables.epochDatesToConvert, '"trial_end":(\d*)');

		variables.baseAmountsToConvert = [];

		arrayAppend(variables.baseAmountsToConvert, '"amount":"(\d*)"');
		arrayAppend(variables.baseAmountsToConvert, '"origin_amount":(\d*)');

// Paymill response code messages
		variables.responseMessage["10001"] = 'General undefined response';
		variables.responseMessage["10002"] = 'Still waiting on something';

		variables.responseMessage["20000"] = 'General success response';

		variables.responseMessage["40000"] = 'General problem with data';
		variables.responseMessage["40001"] = 'General problem with payment data';
		variables.responseMessage["40100"] = 'Problem with credit card data';
		variables.responseMessage["40101"] = 'Problem with cvv';
		variables.responseMessage["40102"] = 'Card expired or not yet valid';
		variables.responseMessage["40103"] = 'Limit exceeded';
		variables.responseMessage["40104"] = 'Card invalid';
		variables.responseMessage["40105"] = 'Expiry date not valid';
		variables.responseMessage["40106"] = 'Credit card brand required';
		variables.responseMessage["40200"] = 'Problem with bank account data';
		variables.responseMessage["40201"] = 'Bank account data combination mismatch';
		variables.responseMessage["40202"] = 'User authentication failed';
		variables.responseMessage["40300"] = 'Problem with 3d secure data';
		variables.responseMessage["40301"] = 'Currency / amount mismatch';
		variables.responseMessage["40400"] = 'Problem with input data';
		variables.responseMessage["40401"] = 'Amount too low or zero';
		variables.responseMessage["40402"] = 'Usage field too long';
		variables.responseMessage["40403"] = 'Currency not allowed';

		variables.responseMessage["50000"] = 'General problem with backend';
		variables.responseMessage["50001"] = 'Country blacklisted';
		variables.responseMessage["50100"] = 'Technical error with credit card';
		variables.responseMessage["50101"] = 'Error limit exceeded';
		variables.responseMessage["50102"] = 'Card declined by authorization system';
		variables.responseMessage["50103"] = 'Manipulation or stolen card';
		variables.responseMessage["50104"] = 'Card restricted';
		variables.responseMessage["50105"] = 'Invalid card configuration data';
		variables.responseMessage["50200"] = 'Technical error with bank account';
		variables.responseMessage["50201"] = 'Card blacklisted';
		variables.responseMessage["50300"] = 'Technical error with 3D secure';
		variables.responseMessage["50400"] = 'Decline because of risk issues';
		variables.responseMessage["50500"] = 'General timeout';
		variables.responseMessage["50501"] = 'Timeout on side of the acquirer';
		variables.responseMessage["50502"] = 'Risk management transaction timeout';
		variables.responseMessage["50600"] = 'Duplicate transaction';

		return this;
	}

	public string function getVersion()
		hint="I return the current version number"
	{
		return "0.3.3";
	}

	public string function getPrivateKey()
		hint="I return the Private Key"
	{
		return variables.privateKey;
	}

	public string function getPublicKey()
		hint="I return the Public Key"
	{
		return variables.publicKey;
	}

	public struct function addClient(string email="", string description="")
		hint="I add a new Client"
	{
		var packet = {};

		packet.object = "clients";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="email", value=arguments.email});
		arrayAppend(packet.params, {name="description", value=arguments.description});

		return send(packet);
	}

	public struct function updateClient(required string id, string email="", string description="")
		hint="I update a Client"
	{
		var packet = {};

		packet.id = arguments.id;
		packet.object = "clients";
		packet.method = "PUT";

		packet.params = [];

		arrayAppend(packet.params, {name="email", value=arguments.email});
		arrayAppend(packet.params, {name="description", value=arguments.description});

		return send(packet);
	}

	public struct function getClient(required string id)
		hint="I return the selected Client"
	{
		return getObject("clients", arguments.id);
	}

	public struct function getClients(numeric count=20, numeric offset=0)
		hint="I return a list of Clients"
	{
		return getObjects(object="clients", params=arguments);
	}

	public struct function deleteClient(required string id)
		hint="I delete the selected Client"
	{
		return deleteObject(object="clients", id=arguments.id);
	}

	public struct function addOffer(required numeric amount, required string currency, required string interval, required string name)
		hint="I add a new Offer"
	{
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

	public struct function getOffer(required string id)
		hint="I return the selected Offer"
	{
		return getObject("offers", arguments.id);
	}

	public struct function getOffers(numeric count=20, numeric offset=0)
		hint="I return a list of Offers"
	{
		return getObjects(object="offers", params=arguments);
	}

	public struct function updateOffer(required string id, required string name="")
		hint="I update a Offer"
	{
		var packet = {};

		packet.id = arguments.id;
		packet.object = "offers";
		packet.method = "PUT";

		packet.params = [];

		arrayAppend(packet.params, {name="name", value=arguments.name});

		return send(packet);
	}

	public struct function deleteOffer(required string id)
		hint="I delete the selected Offer"
	{
		return deleteObject(object="offers", id=arguments.id);
	}

	public struct function addPayment(required string token, string client="")
		hint="I add a new Payment"
	{
		var packet = {};

		packet.object = "payments";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="token", value=arguments.token});
		arrayAppend(packet.params, {name="client", value=arguments.client});

		return send(packet);
	}

	public struct function getPayment(required string id)
		hint="I return the selected Payment"
	{
		return getObject("payments", arguments.id);
	}

	public struct function getPayments(numeric count=20, numeric offset=0)
		hint="I return a list of Payments"
	{
		return getObjects(object="payments", params=arguments);
	}

	public struct function deletePayment(required string id)
		hint="I delete the selected Payment"
	{
		return deleteObject(object="payments", id=arguments.id);
	}

	public struct function addPreauthorization(required numeric amount, required string currency, string payment="", string token="")
		hint="I add a new Preauthorization"
	{
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

	public struct function getPreauthorization(required string id)
		hint="I return the selected Preauthorization"
	{
		return getObject("preauthorizations", arguments.id);
	}

	public struct function getPreauthorizations(numeric count=20, numeric offset=0)
		hint="I return a list of Preauthorizations"
	{
		return getObjects(object="preauthorizations", params=arguments);
	}

	public struct function deletePreauthorization(required string id)
		hint="I delete the selected Preauthorization"
	{
		return deleteObject(object="preauthorizations", id=arguments.id);
	}

	public struct function addRefund(required string transaction, required numeric amount, required string description)
		hint="I add a new Refund"
	{
		var packet = {};

		packet.object = "refunds";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="id", value=arguments.transaction});
		arrayAppend(packet.params, {name="amount", value=convertAmountToBase(arguments.amount)});
		arrayAppend(packet.params, {name="description", value=arguments.description});

		return send(packet);
	}

	public struct function getRefund(required string id)
		hint="I return the selected Refund"
	{
		return getObject("refunds", arguments.id);
	}

	public struct function getRefunds(numeric count=20, numeric offset=0)
		hint="I return a list of Refunds"
	{
		return getObjects(object="refunds", params=arguments);
	}

	public struct function addSubscription(required string offer, required string payment, string client="", date startDate=createDate(1970, 1, 1))
		hint="I add a new Subscription"
	{
		var packet = {};

		packet.object = "subscriptions";
		packet.method = "POST";

		packet.params = [];

		arrayAppend(packet.params, {name="offer", value=arguments.offer});
		arrayAppend(packet.params, {name="payment", value=arguments.payment});

		if (arguments.client != "") {
			arrayAppend(packet.params, {name="client", value=arguments.client});
		}

		if (arguments.startDate != createDate(1970, 1, 1)) {
			arrayAppend(packet.params, {name="start_at", value=getEpochTimeFromLocal(arguments.startDate)});
		}

		return send(packet);
	}

	public struct function updateSubscription(required string id, required boolean cancel, required string payment, string offer="")
		hint="I update a Subscription"
	{
		var packet = {};

		packet.id = arguments.id;
		packet.object = "subscriptions";
		packet.method = "PUT";

		packet.params = [];

		arrayAppend(packet.params, {name="cancel_at_period_end", value=arguments.cancel});
		arrayAppend(packet.params, {name="payment", value=arguments.payment});

		if (arguments.offer != "") {
			arrayAppend(packet.params, {name="offer", value=arguments.offer});
		}

		return send(packet);
	}

	public struct function getSubscription(required string id)
		hint="I return the selected Subscription"
	{
		return getObject("subscriptions", arguments.id);
	}

	public struct function getSubscriptions(numeric count=20, numeric offset=0)
		hint="I return a list of Subscriptions"
	{
		return getObjects(object="refunds", params=arguments);
	}

	public struct function deleteSubscription(required string id)
		hint="I delete the selected Subscription"
	{
		return deleteObject(object="subscriptions", id=arguments.id);
	}

	public struct function addTransaction(required numeric amount, required string currency, string token="", string payment="", string preauthorization="", string client="", string description="")
		hint="I create a new Transaction"
	{
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

	public struct function getTransaction(required string id)
		hint="I return the selected Transaction"
	{
		return getObject("transactions", arguments.id);
	}

	public struct function getTransactions(numeric count=20, numeric offset=0)
		hint="I return a list of Transactions"
	{
		return getObjects(object="transactions", params=arguments);
	}

	public struct function parseWebhook(required any httpPOST)
		hint="I parse a webhook POST packet and return the data as a structure"
	{
		var content = toString(arguments.httpPOST.content);

		if (content == "") {
			var response["event"]["event_type"] = "none.found";

			return response;
		}

// convert all the epoch date in the JSON packet values to ColdFusion datetime objects
		for (var epochDateRegEx in variables.epochDatesToConvert) {
			content = replaceWithCallback(content, epochDateRegEx, convertEpochDates, 'all', false);
		}

// convert all the in the JSON packet base amounts to currency amounts
		for (var baseAmountRegEx in variables.baseAmountsToConvert) {
			content = replaceWithCallback(content, baseAmountRegEx, convertAmountsFromBase, 'all', false);
		}

// replace all the "null" subscription values in the JSON packet with a ColdFusion empty array
		content = reReplaceNoCase(content, '"subscription":null', '"subscription":[ ]', "all");

// replace all the "null" values in the JSON packet with a ColdFusion empty string
		content = reReplaceNoCase(content, ":null", ':""', "all");

		return deserializeJSON(content);
	}

	public string function getResponseMessage(required string responseCode)
		hint="I return the response message for the given response code"
	{
		if (structKeyExists(variables.responseMessage, arguments.responseCode)) {
			return variables.responseMessage[arguments.responseCode];
		} else {
			return "";
		}
	}

	private struct function getObject(required string object, required string id)
		hint="I return the selected Object"
	{
		var packet = {};

		packet.object = arguments.object;
		packet.method = "GET";
		packet.id = arguments.id;

		return send(packet);
	}

	private struct function getObjects(required string object, struct params={})
		hint="I return a list of Objects"
	{
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

	private struct function deleteObject(required string object, required string id)
		hint="I delete the selected Object"
	{
		var packet = {};

		packet.object = arguments.object;
		packet.method = "DELETE";
		packet.id = arguments.id;

		return send(packet);
	}

	private struct function send(required struct inboundPacket)
		hint="I send the data packet to the http service"
	{
		var packet = arguments.inboundPacket;
		var param = "";
		var bodyValue = "";
		var response = "";
		var httpService = new http();
		var cfPaymillLog = {};
		var cfPaymillLogFileHandle = "";

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

		httpService.setCharset(variables.charset);
		httpService.setURL(endpointURL);
		httpService.setMethod(packet.method);

		httpService.addParam(name="wrapper", value="cfPaymill", type="header");
		httpService.addParam(name="Authorization", value="Basic #toBase64(variables.privateKey)#", type="header");

		response = httpService.send().getPrefix();

		if (variables.logfile != "") {
			cfPaymillLog["datetime"] = dateFormat(now(), 'yyyy-mm-dd ') & timeFormat(now(), 'HH:mm:ss');

			cfPaymillLog["request"] = {};

			cfPaymillLog.request["attributes"] = httpService.getAttributes();

			cfPaymillLog["response"] = deserializeJSON(response.filecontent.toString());

			lock name="cfPaymillLog" type="exclusive" timeout="30" {
				cfPaymillLogFileHandle = fileOpen(variables.logfile, "append");

				fileWriteLine(cfPaymillLogFileHandle, serializeJSON(cfPaymillLog));
				fileClose(cfPaymillLogFileHandle);
			}
		}

		return processResponse(response);
	}

	private struct function processResponse(required struct response)
		hint="I process the response data"
	{
		var result = {};
		var data = {};
		var createdDate = {};
		var updatedDate = {};
		var newValue = {};
		var createdDates = "";
		var updatedDates = "";
		var fileContentJSON = "";
		var statusCode = "";

		fileContentJSON = arguments.response.filecontent.toString();
		statusCode = arguments.response.responseHeader.status_code;
		statusText = arguments.response.responseHeader.explanation;

		if (statusCode == "200") {
			result["success"] = true;

// replace all the "null" subscription values in the JSON packet with a ColdFusion empty array
			fileContentJSON = reReplaceNoCase(fileContentJSON, '"subscription":null', '"subscription":[ ]', "all");

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

					amounts = structFindKey(data, "amount", "all");

					for (amount in amounts) {
						newValue = convertAmountFromBase(amount.value);

						structUpdate(amount.owner, "amount", newValue);
					}

					originAmounts = structFindKey(data, "origin_amount", "all");

					for (originAmount in originAmounts) {
						newValue = convertAmountFromBase(originAmount.value);

						structUpdate(originAmount.owner, "origin_amount", newValue);
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

				amounts = structFindKey(result.data, "amount", "all");

				for (amount in amounts) {
					newValue = convertAmountFromBase(amount.value);

					structUpdate(amount.owner, "amount", newValue);
				}

				originAmounts = structFindKey(result.data, "origin_amount", "all");

				for (originAmount in originAmounts) {
					newValue = convertAmountFromBase(originAmount.value);

					structUpdate(originAmount.owner, "origin_amount", newValue);
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

	private numeric function convertAmountFromBase(required numeric amount)
		hint="I convert the base unit amount to a currency amount"
	{
		return arguments.amount / 100;
	}

	private numeric function convertAmountToBase(required numeric amount)
		hint="I convert the amount to the base currency unit"
	{
		return int(arguments.amount * 100);
	}

	private date function getDate(required numeric timestamp)
		hint="I return a ColdFusion Date type when given a Unix Epoch timestamp integer"
	{
// Epoch datetime returned by Paymill is UTC. Convert to locale.

// http://rob.brooks-bilson.com/index.cfm/2007/10/11/Some-Notes-on-Using-Epoch-Time-in-ColdFusion
// http://cflib.org/udf/EpochTimeToLocalDate
// http://www.epochconverter.com/epoch/timezones.php

		return dateAdd("s", arguments.timestamp, dateConvert("utc2Local", createDate(1970, 1, 1)));
	}

	private numeric function getEpochTimeFromLocal(required date dateTime=now()) {
		return dateDiff("s", dateConvert("utc2Local", createDate(1970, 1, 1)), datetime);
	}

	private string function convertEpochDates(required string match, required struct found, required numeric offset, required string string)
		hint="I return a ColdFusion datetime object from an Epoch date"
	{
		var foundEpochDate = arguments.found.substring[2];

		if (foundEpochDate == "") {
			return arguments.match;
		} else {
			var convertedDate = getDate(foundEpochDate);

			return replaceNoCase(arguments.match, foundEpochDate, '"#convertedDate#"');
		}
	}

	private string function convertAmountsFromBase(required string match, required struct found, required numeric offset, required string string)
		hint="I return a currency amount from a base amount"
	{
		var foundAmount = arguments.found.substring[2];
		var convertedAmount = convertAmountFromBase(foundAmount);

		return replaceNoCase(arguments.match, foundAmount, convertedAmount);
	}

/**
 * This library is part of the Common Function Library Project. An open source
 * collection of UDF libraries designed for ColdFusion 5.0 and higher. For more information,
 * please see the web site at:
 *
 * http://www.cflib.org
 *
 * Warning:
 * You may not need all the functions in this library. If speed
 * is _extremely_ important, you may want to consider deleting
 * functions you do not plan on using. Normally you should not
 * have to worry about the size of the library.
 *
 * License:
 * This code may be used freely.
 * You may modify this code as you see fit, however, this header, and the header
 * for the functions must remain intact.
 *
 * This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
 *
 * Analogous to reReplace()/reReplaceNoCase(), except the replacement is the result of a callback, not a hard-coded string
 * v1.0 by Adam Cameron
 *
 * @param string 	 The string to process (Required)
 * @param regex 	 The regular expression to match (Required)
 * @param callback 	 A UDF which takes arguments match (substring matched), found (a struct of keys pos,len,substring, which is subexpression breakdown of the match), offset (where in the string the match was found), string (the string the match was found within) (Required)
 * @param scope 	 Number of replacements to make: either ONE or ALL (Optional)
 * @param caseSensitive 	 Whether the regex is handled case-sensitively (Optional)
 * @return A string with substitutions made
 * @author Adam Cameron (dac.cfml@gmail.com)
 * @version 1.0, July 18, 2013
 */
	private string function replaceWithCallback(required string string, required string regex, required any callback, string scope="ONE", boolean caseSensitive=true){
		if (!isCustomFunction(callback)) { // for CF10 we could specify a type of "function", but not in CF9
			throw(type="Application", message="Invalid callback argument value", detail="The callback argument of the replaceWithCallback() function must itself be a function reference.");
		}
		if (!isValid("regex", scope, "(?i)ONE|ALL")) {
			throw(type="Application", message="The scope argument of the replaceWithCallback() function has an invalid value #scope#.", detail="Allowed values are ONE, ALL.");
		}

		var startAt	= 1;

		while (true){	// there's multiple exit conditions in multiple places in the loop, so deal with exit conditions when appropriate rather than here
			if (caseSensitive) {
				var found = reFind(regex, string, startAt, true);
			} else {
				var found = reFindNoCase(regex, string, startAt, true);
			}

			if (!found.pos[1]) { // ie: it didn't find anything
				break;
			}

			found['substring']=[];	// as well as the usual pos and len that CF gives us, we're gonna pass the actual substrings too

			for (var i=1; i <= arrayLen(found.pos); i++) {
				found.substring[i] = mid(string, found.pos[i], found.len[i]);
			}

			var match = mid(string, found.pos[1], found.len[1]);
			var offset = found.pos[1];

			var replacement = callback(match, found, offset, string);

			string = removeChars(string, found.pos[1], found.len[1]);
			string = insert(replacement, string, found.pos[1]-1);

			if (scope=="ONE") {
				break;
			}

			startAt = found.pos[1] + len(replacement);
		}

		return string;
	}
}