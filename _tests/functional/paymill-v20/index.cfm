<html>
	<head>
	</head>

	<body>
		<cfoutput>
			<p>NOTE: Allow popups in browser</p>

			<h1>Functional Tests - Paymill v2.0</h1>

			<cfset data = {}>

			<cfset data.name = 'client-#timeFormat(now(), 'HHmmss')#'>
			<cfset data.emailAddress = '#data.name#@example.com'>

			<cfset data.cardNumber = '4111111111111111'>
			<cfset data.cvc = '111'>
			<cfset data.type = 'creditcard'>

			<cfset data.expiryMonth = month(now())>
			<cfset data.expiryYear = year(now()) + 1>

			<cfset data.amount = 12.99>
			<cfset data.currency = 'GBP'>

			<form id="testingForm" method="POST" target="_blank">
				<h2>Payment</h2>

				<div>Card number: #data.cardNumber#</div>
				<div>CVC: #data.cvc#</div>
				<div>Expiry month: #data.expiryMonth#</div>
				<div>Expiry year: #data.expiryYear#</div>

				<button class="submitForm" data-component="PaymentTestBundle.cfc" type="button">Minimal Payment Test</button>

				<h2>Transaction</h2>

				<div>Name: #data.name#</div>
				<div>Email address: #data.emailAddress#</div>
				<div>Card number: #data.cardNumber#</div>
				<div>CVC: #data.cvc#</div>
				<div>Expiry month: #data.expiryMonth#</div>
				<div>Expiry year: #data.expiryYear#</div>
				<div>Currency: #data.currency#</div>
				<div>Amount: #data.amount#</div>

				<button class="submitForm" data-component="TransactionTestBundle.cfc" type="button">Minimal Transaction Test</button>
				<br>
				<button class="submitForm" data-component="TransactionPaymentClientTestBundle.cfc" type="button">Transaction Test with Payment and Client</button>

<!--- ------------------------------------------------- --->

				<input id="card-holdername" type="hidden" value="#data.name#">
				<input id="email" type="hidden" value="#data.emailAddress#">

				<input id="card-number" name="abc" type="hidden" value="#data.cardNumber#">
				<input id="card-cvc" type="hidden" value="#data.cvc#">

				<input id="card-expiry-month" type="hidden" value="#data.expiryMonth#">
				<input id="card-expiry-year" type="hidden" value="#data.expiryYear#">

				<input id="card-currency" type="hidden" value="#data.currency#">
				<input id="card-amount-int" type="hidden" value="#data.amount * 100#">
			</form>
		</cfoutput>

		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.9.1.min.js"><\/script>')</script>

		<script type="text/javascript">
			var PAYMILL_PUBLIC_KEY = '39807165956a5f3404fa8225d24b887a';
		</script>

		<script type="text/javascript" src="https://bridge.paymill.com/"></script>

		<script type="text/javascript">
			$(document).ready(function(event) {
				$(".submitForm").on("click", function(event) {
					component = $(this).data('component');

					paymill.createToken({number: $('#card-number').val()
						,cvc: $('#card-cvc').val()
						,exp_month: $('#card-expiry-month').val()
						,exp_year: $('#card-expiry-year').val()
					}, getPaymillToken);
				})

				function getPaymillToken(error, result) {
					console.log(result);

					if (error) {
						$(".payment-errors").text(error.apierror);
					} else {
						<cfoutput>
							var options = {
								 name:'#data.name#'
								,emailaddress:'#data.emailAddress#'

								,type:'#data.type#'
								,cardnumber:'#data.cardNumber#'
								,cvc:'#data.cvc#'

								,expirymonth:'#data.expiryMonth#'
								,expiryyear:'#data.expiryYear#'

								,currency:'#data.currency#'
								,amount:'#data.amount#'
							};
						</cfoutput>

						options.brand = result.brand;
						options.last4 = result.last4Digits;
						options.binCountry = result.binCountry;
						options.token = result.token;

						var actionURL = '/cfPaymill/_tests/cut/paymill-v20/' + component + '?method=runRemote&options=' + JSON.stringify(options);

						$("#testingForm").attr('action', actionURL);

						$("#testingForm").submit();
					}
				};
			});
		</script>
	</body>
</html>