<style>
.grindreel {
	z-index:9999;
	margin: 0 auto;
	color: white;
	position: relative;
	left: 100px;
	top: 10%;
}

.project-li:nth-child(1) .grindreel {
	top: 20%;
}

.project-li:last-child .grindreel {
	top: 30%;
}

.grindreel .tiny { font-size: 0.9em; }
.grindreel .small { font-size: 0.9em; }
.grindreel .medium { ; }
.grindreel .offwhite { color: rgb(230,230,230); }
.grindreel .banner { position: relative; top: -50px; left: 85px; }
.grindreel .top { position: relative; top: 20px; left: 5px; }
.grindreel .large { font-size: 2em; }

.grindreel p {
	position:relative; 
}

table {
	color: white;
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

ul.list,
ul.looped ,
p {
	width: 100%;
	min-width: 300px;
	max-width: 800px;
	font-size: 20px;
	line-height: 1.5em;
	margin-bottom: 20px;
}

ul.list,
ul.looped {
	margin-bottom: 40px;
}

ul.list a,
ul.looped a {
	font-weight: bold;
	letter-spacing: 1px;	
}

ul.list li,
ul.looped li,
p.left-side a {
	color: white;
	display: block;
	font-size: 1.1em;
	margin-bottom: 10px;
}

p.left-side a {
	font-size: 1.5em;
	margin-top: 10px;
}

ul.looped li {
	display: inline-block;
	padding-right: 40px;
	margin-bottom: 10px;
}

ul.looped li:hover {
	text-decoration: underline;
}

ul.looped li:nth-child(even) {
	background-color: white;
	padding-left: 5px;
	color: black;
}

ul.list li {
	display: inline-block;
	margin-bottom: 20px;
}

ul.list li a ,
ul.list li a:visited {
	text-decoration: underline;
	color: white;
}

ul.work {
	font-size: 1.1em;
}

.project-li:nth-child(1) p {
	width: 50%;	
}

.grindreel div {
	margin-bottom: 20px;
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
						<a href="##experience">Work</a>
						<a href="##tools">Tools</a>
						<a href="##contact">Contact</a>
						<a href="https://github.com/zaiah-dj">Github</a>
					</p>

				</div>
				<div class="more">
					<p style="font-size:0.7em;color:white;font-family:'EB Garamond'; top: 10px;left: 10px; position:relative;">(click to scroll)</p>
					<div class="next"></div>
				</div>
			</li>

			<li class="project-li" style="background:black;">
				<div id="experience_" class="grindreel"> 
					<h1>Experience</h1>
					<p>I have gained skill in a variety of languages, tools and frameworks across my 13 years of programming.  
					A sampling of some of the tools I use are below:</p>
					<ul class="looped">
						<li>PHP</li>
						<li>Flutter</li>
						<li>C</li>
						<li>Java</li>
						<li>Angular (7+)</li>
						<li>Dart</li>
						<li>MySQL</li>
						<li>SQL Server</li>
						<li>SQLite</li>
						<li>Lua</li>
						<li>Apache</li>
						<li>Coldfusion</li>
						<li>Lucee</li>
						<li>Git</li>
					</ul>

					<p>A few of my favorite projects are listed below, and can be seen by clicking on the respective links.</p>
					<ul class="list work">
						<li><a href="http://ncat.edu/transfer-articulation">North Carolina A&T</a> - I was contracted to build an application to help students evaluate their transfer credits.  The school are big users of PHP, so it was fun to hook something up that works with Oracle and affects such a large group of users.</li>
						<li><a href="http://gogarbanzo.com/demo">Garbanzo</a> - Garbanzo is an application I wrote to help manage finances.  It expanded to become a mobile app as well.</li>
						<li><a href="http://mystframework.com">Myst</a> - For about 4 years, I informally maintained a web framework to make ColdFusion apps a bit easier to maintain.  It arose from a need I found at one of my previous positions to be able to seperate different types of code.  The framework ended up being quite useful on a variety of projects throughout the years, and even powers this website in its current form.</li>
					</ul>
				</div>
				<div class="more">
					<div class="next"></div>
				</div>
			</li>

			<li class="project-li" style="background:black;">
				<div id="tools_" class="grindreel"> 
					<h1>Tools</h1>
					<p>I also write tools to solve problems in my spare time.  The use cases vary from simple text processing
					to a full blown http library.  A few of these are listed below:</p>
					<p>
					<ul class="list">
						<li><a href="https://github.com/zaiah-dj/zhttp">zhttp</a> - An HTTP parser and response builder written in C with virtually no dependencies.</li>
						<li><a href="https://github.com/zaiah-dj/briggs">briggs</a> - Filtering tool to convert CSV and other list style data into popular formats such as JSON, XML and C structures.</a></li>
						<li><a href="https://github.com/zaiah-dj/assault">assault</a> - A web server stress testing tool which utilizes <a href="https://curl.se">libcurl</a> to generate random requests.</a></li>
						<li><a href="http://mystframework.com">myst</a> - A (now-defunct) web framework for Lucee to streamline the development of MVC apps.</a></li>
					</ul>
					</p>
				</div>
				<div class="more">
					<div class="next"></div>
				</div>
			</li>

			<li class="project-li" style="background:black;">
				<div id="contact_" class="grindreel"> 
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
