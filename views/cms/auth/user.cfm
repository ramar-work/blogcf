<cfoutput query=#model.user#>
<div class="container">
	<form>
		<div class="input-field">
			<label>Salutation</label>
			<select name="lm_prefix">
				<option value="xx">Mr.</option>
				<option value="xx">Ms.</option>
				<option value="xx">Mrs.</option>
				<option value="xx">Dr.</option>
			</select>
		</div>

		<div class="input-field">
			<label>First Name</label>
			<input name="lm_fname" value="#lm_fname#">
		</div>

		<div class="input-field">
			<label>Middle Name</label>
			<input name="lm_mname" value="#lm_mname#">
		</div>

		<div class="input-field">
			<label>Last Name</label>
			<input name="lm_lname" value="#lm_lname#">
		</div>

		<div class="input-field">
			<label>Description</label>
			<input name="lm_description" value="#lm_description#">
		</div>

		<div class="input-field">
			<label>Change Password</label>
			<input type="password" name="lm_fname" value="************">
		</div>

		<div class="input-field">
			<label>First Name</label>
			<input name="lm_fname" value="#lm_fname#">
		</div>
	</form>
</div>
</cfoutput>
