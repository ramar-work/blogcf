<html>
<head>
<cfoutput>
<cfloop array=#model.base.jsfilelist# item="i">
	<script src="#i#"></script>
</cfloop>
<cfloop array=#model.base.cssfilelist# item="i">
	<link rel="stylesheet" href="#i#">
</cfloop>
</cfoutput>
</head>

<body>
<div id="login-container" class="container">
	<cfoutput>
		<div class="login-box">
			<div class="login-box-header">
				<img src="#model.base.logo#">
			</div>
			<form action="#model.base.href.authenticate#" method="POST">
				<div class="login-box-input">
					<label>Username</label>
					<input type="text" name="username">
				</div>
				<div class="login-box-input">
					<label>Password</label>
					<input type="password" name="password">
				</div>
				<button type="submit">Login</button>
			</form>
		</div>
	</cfoutput>
</div>
</body>
</html>
