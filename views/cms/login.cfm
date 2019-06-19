<div id="login-container" class="container">
	<script type="text/javascript">administerUser( "/admin/api.authenticate.cfm" );</script>
	<cfoutput>
		<div class="login-box">
			<div class="login-box-header">
			</div>
			<form action="#cms.getPublicPath( 'authenticate.cfm' )#" method="POST">
				<div class="login-box-input">
					<label>Username</label>
					<input type="text" name="username">
				</div>
				<div class="login-box-input">
					<label>Password</label>
					<input type="password" name="password">
				</div>
				<button type="submit">Login</button>
				<!--- TODO: Add a note for new users --->
				<a href="#cms.getPublicPath( 'register.cfm' )#">Add User</a>
			</form>
		</div>
	</cfoutput>
</div>
