<style>
.w1-2 {
	position: relative;
	display: inline-block;
	width: 40%;
	border: 1px solid black;	
}
</style>

<cfoutput>
<div class="container">
	<h1>Content</h1>
	<!--- Debug --->
	<!---	
	<cfif model.base.debug>
		<div>Database: #cms.getDataSource()#</div>
		<cfinclude template="stubs/debug.cfm">
	</cfif>
	--->

	<!---	
	<ul class="container-navigation">
	<cfloop array=#model.collection.navigation# item="i">
		<li><a href="#i.href#">#i.name#</a></li>
	</cfloop>
	</ul>
	--->

	<div class="container-section">
		<div class="input-group">
			<input value="#model.collection.post.title#" class="input-member title" id="tit" name="title" type="text" placeholder="Title"></input>	
		</div>

		<div class="input-group">
			<label class="input-member">Author</label> 
			<select class="input-member w1-2" name="author" type="text">
				<option>Choose an Author</option>
			<cfloop query=#model.collection.users#>
				<cfif login_uuid eq model.collection.owner.login_uuid>
				<option value="#login_uuid#" selected>#lm_fname# #lm_lname#</option>
				<cfelse>
				<option value="#login_uuid#">#lm_fname# #lm_lname#</option>
				</cfif>
			</cfloop>
			</select>	
		</div>

		<div class="input-group">
			<label class="input-member">Category</label> 
			<div>
				<input class="input-member full" name="category" type="text"></input>	
				<div class="bg">
					<ul>
					<cfloop query=#model.collection.categories#>
						<li id="#category_uuid#">#category_name#</li>
					</cfloop>
					</ul>
				</div>
			</div>
		</div>

		<div class="input-group">
			<label class="input-member">Keywords</label> 
			<div>
				<input class="input-member full" name="keyword" type="text"></input>	
				<div class="bg">
					<ul>
					<cfloop query=#model.collection.keywords#>
						<li id="#keyword_uuid#">#keyword_text#</li>
					</cfloop>
					</ul>
				</div>
			</div>
		</div>

<!---
		<div class="input-group">
			<label class="input-member">Category</label> 
			<select class="input-member w1-2" name="category" type="text">
				<option>Choose a Category</option>
			<cfloop query=#model.collection.categories#>
				<option value="#category_long_id#">#category_name#</option>
			</cfloop>
			</select>	
		</div>

		<div class="input-group">
			<label class="input-member">Keywords</label> 
			<select class="input-member w1-2" name="category" type="text">
				<option>Choose a Keyword</option>
			<cfloop query=#model.collection.categories#>
				<option value="#category_long_id#">#category_name#</option>
			</cfloop>
			</select>	
		</div>
--->
		<div class="input-group">
			<label class="input-member">Featured Image</label> 
			<input class="input-member" name="previewimg_file" type="file"></input>	
		</div>

		<div class="input-group">
			<label class="check" >Draft?</label> 
			<input class="check" name="draft" type="checkbox" 
				#iif(model.collection.post.draft neq "",DE("checked"),DE(""))#></input>	
		</div>

		<div class="input-group">
			<label class="check">Show Footer</label> 
			<input class="check" name="footer" type="checkbox"></input>	
		</div>

		<div class="input-group">
			<label class="check" >Show Comments</label> 
			<input class="check" name="comments" type="checkbox"></input>	
		</div>

	Body
	<cfif model.collection.edit>
		<div class="content-group">
			<div class="content-draft">
			<cfloop query=model.collection.post>
				<div id="#cid#" class="content-regular">
					<div class="content-regular-header"></div>
				<cfif #ctypei# eq model.collection.types.text>
					<p>#ctext#</p>
				<cfelseif #ctypei# eq model.collection.types.audio>
					<audio controls src="#ctext#">
						Your browser does not support HTML5 audio.
					</audio>
				<cfelseif #ctypei# eq model.collection.types.image>
					<img src="#ctext#">
				<cfelseif #ctypei# eq model.collection.types.video>
					<video controls src="#ctext#">
						Your browser does not support HTML5 video.
					</video>
				<cfelse>
					<a href="#ctext#">#ctext#</a>
				</cfif>
					<div class="icons">
						<div class="content-icon edit">
						</div>
						<div class="content-icon delete">
						</div>
					</div>
				</div>
			</cfloop>
			</div>
		</div>
	</cfif>
		<!--- All content shows here --->
		<div class="content-group">
			<h3 class="input-break">#model.collection.message#</h3>
			<div id=list>
			</div>
		</div>

		<!--- All content goes here --->
		<div class="content-group">
			<div id=drop class="drop-area">
			</div>
		</div>

		<!--- Submit and reset --->
		<div class="content-group">
			<button class="input-member" id="reset">Reset</button>
			<button class="input-member" id="post-submit">Submit</button>
		</div>
	</div>

	<!--- ... --->
	<div class="js-log">
		<!--- This is updated as the user drops new content --->
		<div class="content-group">
			<div id="status">Drag Files to Selected Area</div>
		</div>
	</div>

</div>
</cfoutput>
