<style>
.grindreel {
	z-index:9999;
	margin: 0 auto;
	color: white;
	position: relative;
	top: 30%;
	left: 100px;
}

.grindreel .tiny { font-size: 0.9em; }
.grindreel .small { font-size: 0.9em; }
.grindreel .medium { ; }
.grindreel .offwhite { color: rgb(230,230,230); }
.grindreel .banner { position: relative; top: -50px; left: 85px; }
.grindreel .top { position: relative; top: 20px; left: 5px; }
.grindreel .large { font-size: 2em; }

.grindreel p {
	font-family: 'EB Garamond';
	position:relative; 
}

table {
	color: white;
	font-family: 'EB Garamond';
	font-size: 1.6em;
}

table td {
	padding: 10px;
}

table td a {
	color: white;	
}

.grindreel h1 {
	letter-spacing: -2px;
	font-size: 5.0em;
	font-weight: bold;
	font-family: 'Open Sans';
	text-shadow: 5px 5px 5px rgb(44,44,44);
	margin-bottom: 20px;
}

@media screen and (max-width: 666px) {
	.grindreel {
		left: 0px;
		text-align: center;
	}

	.grindreel .top {
		top: 10px;
		width: 330px;
		margin: 0 auto;
		text-align: left;
	}

	.grindreel h1 {
		font-size: 4.0em;
		margin: 0 auto;
		margin-bottom: 60px;
		position: relative;
		display: block;
		max-width: 330px;
		text-align: center;
	}

	.grindreel .banner {
		left: 5px;
		font-size: 0.8em;
	}
	.grindreel p {
		width: 330px;
		margin: 0 auto;
		text-align: left;
		line-height: 1.0em;
	}
}

/*...*/
.grindreel .work {
	height: 200%;
	width: 50%;
	background-color: white;
	border: 2px solid white;
	position: absolute;
	top: -100px;
	left: 40%;
	z-index: 9999;
}

.grindreel .work li.project-inner {
	width: 100px;
	display: inline-block;
	position: relative;
	top: 0px;
}

p.left-side a {
	color: white;
	display: block;
	font-size: 1.5em;
	margin-bottom: 10px;
	margin-top: 10px;
}
</style>

<cfoutput>
	<link rel="stylesheet" href="#link( 'assets/project.css' )#">
	<div class="projects">
		<ul class="project">
			<li class="project-li" style="background:black;">
				<div class="grindreel"> 
					<p class="small offwhite top">Welcome to</p>
					<h1>ramar.work</h1>
					<p>The digital home of full-stack developer Antonio Ramar Collins II.</p>
					<p>
					I specialize in building apps for business, gaming and higher-education.
					</p>
					<p class="left-side">
						<a href="/resume.pdf">Resume</a>
						<a href="/blog">Blog</a> <!--- Use a nofollow here, b/c my blog is the same --->
						<a href="##contact">Contact</a>
						<a href="/work">Work</a>
					</p>

					<!--- Show the first post here --->
					<!--- Load others via a different menu --->
					<div class="work">
					<ul>
					<cfloop array=#model.projects# item=t>
						<li class="project-inner"> 
							<div class="backdrop">
								<img src=#t.images[1]#>
							</div> 
						</li>
					</cfloop>
					</ul>
					</div>
				</div>
				<div class="more">
					<p style="font-size:0.7em;color:white;font-family:'EB Garamond'; top: 10px;left: 10px; position:relative;">(click to scroll)</p>
					<div class="next"></div>
				</div>
			</li>

<!---
		<cfloop array=#model.projects# item=t>
			<li class="project-inner" style="background:#t.background#">
				<div class="backdrop">
					<img src=#t.images[1]#>
				</div> 

				<div class="description js-no-show">
					<h3>#t.title#</h3>

					<h4>Description</h4>
					#t.description#	

					<h4>Tech Stack</h4>
					#t.tech#
				</div>

				<div class="more">
				<cfif StructKeyExists(t,"adjust") && t.logo neq "">
					<img style="#t.adjust#" src="#t.logo#">
				<cfelseif t.logo neq "">
					<img src="#t.logo#">
				<cfelseif StructKeyExists(t,"name")>
					<h2>#t.name#</h2>
				</cfif>
					<ul>
					<cfif !StructKeyExists(t, "noinfo")>
						<a class="descinfo"><li>Info</li></a>
					</cfif>
					<cfif StructKeyExists(t, "github")>
						<a target="_blank" href="#t.github#"><li>Github</li></a>
					</cfif>
					<cfif StructKeyExists(t, "link")>
						<a target="_blank" href="#t.link#"><li>Link to Work</li></a>
					</cfif>
					</ul>
					<div class="next"></div>
				</div>

				<div class="images">
					<ul>
					<cfloop array=#t.images# item="file">
						<li><img src="#file#"></li>
					</cfloop>
					</ul>
				</div>
			</li>
		</cfloop>
--->
			<li class="project-li" style="background:black;">
				<div id="contact" class="grindreel"> 
					<h1>Connect with me</h1>
					<table>
						<tr>
							<td>Phone</td>
							<td>202-873-0691</td>
						</tr>
						<tr>
							<td>Email</td>
							<td>ramar.collins@gmail.com</td>
						</tr>
						<tr>
							<td>LinkedIn</td>
							<td><a target="_blank" href="https://www.linkedin.com/in/antonio-collins-8391ba19/">https://www.linkedin.com/in/antonio-collins-8391ba19/</a></td>
						</tr>
						<tr>
							<td>Github</td>
							<td><a target="_blank" href="https://www.github.com/zaiah-dj/">https://www.github.com/zaiah-dj/</a></td>
						</tr>
					</table>
				</div>
				<div class="more">
					<div class="next"></div>
				</div>
			</li>
		</ul>
	</div>
</cfoutput>
