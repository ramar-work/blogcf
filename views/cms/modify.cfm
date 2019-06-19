<!---
- tooltips need to be added everywhere
- add some kind of debug flag so I can see all the ... 
--->
<cfoutput>
<div class="container">
	<h1>Content</h1>
	<!--- Debug --->
	<!---	
	<div>Database: #cms.getDataSource()#</div>
	--->

	<cfif cms.getDebuggable()>
		<cfinclude template="stubs/debug.cfm">
	</cfif>


	<ul class="container-navigation">
		<li><a href="##metadata">metadata</a></li>
		<li><a href="##technical">technical</a></li>
		<li><a href="##seo">SEO</a></li>
		<li><a href="##content">content</a></li>
	</ul>

	<!--- what is this? --->
	<input id="parent_id" class="input-member" type="hidden" name="parent_id" value="#model.parent_id#">

	<!--- what is this? x2 --->
	<input type="hidden" name="post-comb" value="true">

	<div>
		<div class="hider-section">
			<h2 id="metadata">Metadata</h2>
			<div class="container-section--collapse">
				<div class="container-section--icon"></div>
			</div>
		</div>
		<div class="container-section">
			<div class="input-group">
				<!--- All title --->	
				<label class="input-member">Title</label> 
				<input value="#model.postContent.post_name#" class="input-member title" id=tit name="title" type="text"></input>	
			</div>

			<div class="input-group">
				<!--- All title --->	
				<label class="input-member">Author</label> 
				<select class="input-member " name="cauthor" type="text">
					<option>Select One</option>
				</select>	
			</div>

			<div class="input-group">
				<!--- All meta tags for the post --->	
				<label class="input-member" >Category</label> 
				<div>
					<input value="" class="input-member category" name="category" type="text"></input>	
				</div>
			</div>

			<div class="input-group">
				<!--- All meta tags for the post --->	
				<label class="input-member" >Featured Image</label> 
				<div>
					<input class="check" name="previewimg" type="checkbox"></input>	
					<input class="input-member" name="previewimg_file" type="file"></input>	
				</div>
			</div>

	<!---
			<div class="input-group">
				<label class="input-member">Post Type</label> 
				<select id=typ class="input-member dropp" name="ctype" type="text">
					<option>Select One</option>
				<cfloop query=#cms.qGetCategories()#>
					<option value="#ctype_id#">#ctype_name#</option>
				</cfloop>
				</select>	
			</div>
	--->

			<div class="input-group">
				<label class="check" >Draft?</label> 
				<input class="check" name="drf" type="checkbox" 
					#iif(model.postContent.pmd_isdraft,DE("checked"),DE(""))#></input>	
			</div> <!--- input-group --->

			<div class="input-group">
				<label class="check" >Show Footer</label> 
				<input class="check" name="footer" type="checkbox"></input>	
			</div> <!--- input-group --->

			<div class="input-group">
				<label class="check" >Show Comments</label> 
				<input class="check" name="comments" type="checkbox"></input>	
			</div> <!--- input-group --->
		</div>
	</div>

	<div>
		<div class="hider-section">
			<h2 id="technical">Technical</h2>
			<div class="container-section--collapse">
				<div class="container-section--icon"></div>
			</div>
		</div>
		<div class="container-section">
			<div class="input-group">
				<label class="input-member">Date Published</label> 
				<div>11/02/2016</div>
			</div>

			<div class="input-group">
				<label class="input-member" >Date Modified</label> 
				<div>11/02/2016</div>
			</div>
		</div>
	</div>

	<div>
		<div class="hider-section">
			<h2 id="seo">SEO</h2>
			<div class="container-section--collapse">
				<div class="container-section--icon"></div>
			</div>
		</div>
		<div class="container-section">
			<div class="input-group">
				<label class="input-member" >Keywords</label> 
				<div>
					<input value="" class="input-member metas" id=met name="keywords" type="text"></input>	
					<!--- The tag clouds can go here for each one --->
					<div>
						<ul>
						<cfloop query=#model.metas#>
							<li>#tagname#</li>
						</cfloop>
							<li>Boo boo</li>
							<li>Cardi</li>
							<li>Another Meta</li>
							<li>Rider</li>
							<li>Javascript</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="input-group">
				<!--- All meta tags for the post --->	
				<label class="input-member" >Metas</label> 
				<div>
					<input value="" class="input-member metas" id=met name="metas" type="text"></input>	
				</div>
			</div>
		</div>
	</div>


	<div>
		<div class="hider-section">
			<h2 id="content">Content Drop</h2>
			<div class="container-section--collapse">
				<div class="container-section--icon"></div>
			</div>
		</div>
		<div class="container-section">
		<cfif model.edit>
			<div class="content-group">
				<div class="content-draft">
				<cfloop query=model.postContent>
					<div id="#content_id#" class="content-regular">
						<div class="content-regular-header"></div>
					<cfif #content_type_i# eq #cms.getConstText()#>
						<p>#content_text#</p>
					<cfelseif #content_type_i# eq cms.getConstAudio()>
						<audio src="#cms.getPrivatePath( content_text )#">
							Your browser does not support HTML5 audio.
						</audio>
					<cfelseif #content_type_i# eq cms.getConstImage()>
						<img src="#cms.getPrivatePath( content_text )#">
					<cfelseif #content_type_i# eq cms.getConstVideo()>
						<video controls src="#cms.getPrivatePath( content_text )#">
							Your browser does not support HTML5 video.
						</video>
					<cfelse>
						<a href="#cms.getPrivatePath( content_text )#">#content_text#</a>
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
				<h3 class="input-break">#model.contentMessage#</h3>
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
				<button class="input-member">Reset</button>
				<button class="input-member" id="post-submit">Submit</button>
			</div>
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
