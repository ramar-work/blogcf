<div class="container">
	<script type="text/javascript">administerUser( "/admin/api/cms/saveuser.cfm" );</script>
	<cfoutput>
		<div class="login-box">
			<form action="#cms.getPublicPath( 'authenticate.cfm' )#" method="POST">
				<div class="login-box-input">
					<label>Username</label>
					<input type="text" name="username">
				</div>
				<div class="login-box-input">
					<label>Password</label>
					<input type="text" name="password">
				</div>
				<!--- This (theoretically) will stop unauthorized logins --->
				<div class="login-box-input">
					<label>Nonce</label>
					<input type="text" name="nonce">
				</div>
				<button type="submit">Add User</button>
			</form>
		</div>
	</cfoutput>
</div>
