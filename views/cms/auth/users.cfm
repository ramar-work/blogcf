<!--- users.cfm --->
<style>
table.users img {
	width: 40px;
}
</style>
<cfoutput>
<div class="container">
	<h1>Home</h1>

	<cfif model.base.debug>
	</cfif>

	<table class="admin users" summary="A list of users">
		<thead>
			<tr>
				<th></th>
				<th>Name</th>
				<th>Articles</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query=#model.users#>
			<tr>
				<td>
					<img src="/assets/img/cms/aeon-thumb.jpg" />
				</td>
				<td>#lm_fname# #lm_mname# #lm_lname#</td>
				<td>0</td>
				<td>
					<a href="/cms/users/#login_uuid#">Edit</a>
					<a id="#login_uuid#" href="/cms/api/users/remove/#login_uuid#">Remove</a>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>

</div>
</cfoutput>
