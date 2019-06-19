<cfoutput>
<div class="container">
	<h1>Home</h1>

	<cfif cms.getDebuggable()>
		<cfinclude template="stubs/debug.cfm">
	</cfif>

	<input id="admin-search" placeholder="search" type="search" class="admin-search"></input>
	<table class="admin" summary="A list of your most recent posts">
		<a class="admin-selection" href="#cms.getPublicPath( "new.cfm" )#">
			<br />
			<button class="admin-leader">Start a New Post</button>
		</a>
		<caption>Post List</caption>
		<thead>
			<tr>
				<th>Post Title</th>
				<th>Published?</th>
				<th>Owner</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query=#cms.qGetAllPosts()#>
			<tr class="admin-selection as-alt">
				<!--- The title and a link to the post --->
				<td class="name">
					<a class="admin-selection" href="#cms.getPublicPath("edit.cfm?post_id=#post_id#")#">#post_name#</a>
				</td>
				<!--- Tell me whether or not it's a draft? --->
				<td>#iif( pmd_isdraft, DE("No"), DE("Yes") )#</td>
				<!--- Who owns the post? --->
				<td>Somebody</td>
				<!--- Drop this post and all of it's content entirely --->
				<td>
					<a class="admin-delete" id="#post_long_id#">Delete</a>
				</td>
			</tr>
		</cfloop>
		</tbody>
		<tfoot>
			<tr>
				<td>Explore the rest of your posts here</td>
			</tr>
		</tfoot>
	</table>
</div>
</cfoutput>
