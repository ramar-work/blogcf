<!--- categories.cfm --->
<cfoutput>
<div class="container">
	<h1>Home</h1>

	<cfif model.base.debug>
	</cfif>

	<table class="admin" summary="A list of categories">
		<thead>
			<tr>
				<th>Title</th>
				<th>Count</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query=model.categories>
			<tr>
				<td>#category_name#</td>
				<td>0</td>
				<td>
					<a id="#category_uuid#" href="/cms/api/category/delete/#category_uuid#">Remove</a>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>

</div>
</cfoutput>
