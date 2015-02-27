<html>
	<head>
	</head>

	<body>
		<cfoutput>
			<h1>Functional Tests - Paymill v2.0</h1>

			<h2>Payment</h2>

			<cfset suffix = timeFormat(now(), 'HHmmss')>

			<cfset data = {}>
			<!--- <cfset data.name = 'client-#suffix#'> --->
			<!--- <cfset data.emailAddress = '#data.name#@example.com'> --->
			<cfset data.cardNumber = '4111111111111111'>
			<cfset data.cvc = '111'>
			<cfset data.expiryMonth = month(now())>
			<cfset data.expiryYear = year(now()) + 1>
			<!--- <cfset data.currency = 'GBP'> --->
			<!--- <cfset data.amount = 12.99> --->

			<!--- <div>Name: #data.name#</div> --->
			<!--- <div>Email address: #data.emailAddress#</div> --->
			<div>Card number: #data.cardNumber#</div>
			<div>CVC: #data.cvc#</div>
			<div>Expiry month: #data.expiryMonth#</div>
			<div>Expiry year: #data.expiryYear#</div>
			<!--- <div>Currency: #data.currency#</div> --->
			<!--- <div>Amount: #data.amount#</div> --->

			<form id="payment-form">
				<!--- <input id="card-holdername" type="hidden" value="#data.name#"> --->
				<!--- <input id="email" type="hidden" value="#data.emailAddress#"> --->
				<input id="card-number" type="hidden" value="#data.cardNumber#">
				<input id="card-cvc" type="hidden" value="#data.cvc#">
				<input id="card-expiry-month" type="hidden" value="#data.expiryMonth#">
				<input id="card-expiry-year" type="hidden" value="#data.expiryYear#">
				<!--- <input id="card-currency" type="hidden" value="#data.currency#"> --->
				<!--- <input id="card-amount-int" type="hidden" value="#data.amount * 100#"> --->

				<button id="submitButton" type="button">Submit</button>
			</form>
		</cfoutput>

		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.9.1.min.js"><\/script>')</script>

		<script type="text/javascript">
			var PAYMILL_PUBLIC_KEY = '39807165956a5f3404fa8225d24b887a';
		</script>

		<script type="text/javascript" src="https://bridge.paymill.com/"></script>

		<script type="text/javascript">
			$(document).ready(function() {
				$("#submitButton").on("click", function(event) {
					paymill.createToken({cardholder: $('#card-holdername').val()
						,number: $('#card-number').val()
						,cvc: $('#card-cvc').val()
						,exp_month: $('#card-expiry-month').val()
						,exp_year: $('#card-expiry-year').val()
						,currency: $('#card-currency').val()
						,amount_int: $('#card-amount-int').val()
					}, PaymillResponseHandler);
				})

				function PaymillResponseHandler(error, result) {
					console.log(result);

					if (error) {
		// Displays the error above the form
						$(".payment-errors").text(error.apierror);
					} else {
						var options = 'options={"token":"' + result.token + '"}';

						window.open('/cfPaymill/_tests/cut/paymill-v20/PaymentTestBundle.cfc?method=runRemote&options=' + options, '_blank');
					}
				};
			});
		</script>
	</body>
</html>