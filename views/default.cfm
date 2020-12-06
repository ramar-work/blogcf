<style>
.grindreel {
	z-index:9999;
	color: #eef;
	position: relative;
	top: 10%;
	/*left: 80px;*/
	margin: 0 auto;
	width: 80%;
	padding: 20px;
	background: rgba( 30, 30, 30, 0.9 );
}

.project-li:nth-child(1) .grindreel,
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
	font-size: 1.5em;
}

table td {
	padding-bottom: 10px;
	padding-top: 10px;
}

table td:nth-child(1) {
	padding-right: 10px;
}

table td a {
	color: white;	
}

.grindreel h1 {
	color: white;
	letter-spacing: -2px;
	font-size: 4.0em;
	font-weight: bold;
	font-family: 'Open Sans';
	text-shadow: 5px 5px 5px rgb(44,44,44);
	margin-bottom: 20px;
}

ul.list,
ul.looped ,
p {
	width: 100%;
	min-width: 300px;
	max-width: 800px;
	font-size: 1.0em;
	line-height: 1.2em;
	margin-bottom: 20px;
}

ul.list,
ul.looped {
	margin-bottom: 40px;
}

ul.looped a {
	color: white;
	text-decoration: none;
}

ul.list a {
	font-weight: bold;
	letter-spacing: 1px;	
}

ul.list li,
ul.looped li,
p.left-side a {
	color: white;
	display: block;
	font-size: 0.9em;
	margin-bottom: 10px;
}

p.left-side {
	text-align: right;
}

p.left-side a {
	display: inline-block;
	font-size: 1.2em;
	margin-top: 10px;
	margin-right: 30px;
	font-weight: bold;
	transition: color 0.1s;
}

p.left-side a:hover {
	color: #aaa;
}

p.left-side a:nth-child(1) {
	/*margin-top: 10%;*/
}

ul.looped {
	padding: 5px;
	background-color: #111;
	text-align: left;
}

ul.looped li {
	display: inline-block;
	vertical-align:top; 
	padding-right: 30px;
	margin-bottom: 0px;
}

ul.looped li:hover {
	text-decoration: underline;
}

ul.looped li:nth-child(even) {
	color: #ccc;
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

.grindreel div {
	margin-bottom: 20px;
}

@media screen and (max-width: 717px) {
	.grindreel h1 {
		font-size: 2.0em;
	}

	.grindreel p {
		font-size: 0.9em;
	}

	.grindreel li {
		font-size: 0.7em !important;
	}

	.grindreel {
		left: 0px;
		margin: 0 auto;
		width: 80%;
	}

	table {
		font-size: 1.0em;
	}

	ul.looped {
		line-height: 1.0em !important;
	}

	ul.list li {
		line-height: 1.4em;
		margin-bottom: 20px !important;
	}
	
	ul.work li:last-child {
		display: none;	
	}
}

img.grindreel-img {
	position: absolute;
	right: 0px;
	height: 100%;
}

/*
ul.project li.project-li:nth-child(1) img.grindreel-img {
	height: 100%;
	left: 50%;
	margin-left: -570px;	
}
*/

b {
	font-weight: bold;
}

a.wiffle:visited, 
a.wiffle {
	color: white;
	font-weight: bold;
}
</style>

<cfoutput>
	<link rel="stylesheet" href="#link( 'assets/project.css' )#">
	<div class="projects">
		<ul class="project">
			<li class="project-li" style="background:black;">
				<img class="grindreel-img" src="/assets/img/grindreel/charlotte_uptown_graham_3096x2322_bw.jpg"></img>
				<div class="grindreel"> 
					<p class="small offwhite top">Welcome to</p>
					<h1>ramar.work</h1>
					<p>The digital home of full-stack developer <b>Antonio Ramar Collins II</b>.</p>
					<p>
					I have been programming for 13 years and I am currently located in Charlotte, North Carolina.  
					I specialize in building apps for 
					<b>business</b>, 
					<b>endurance</b> and 
					<a class="wiffle" href="https://ncat.edu/transfer-articulation">higher-education</a>.  
					And I would love to build your next product...
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
					<!--- <p style="font-size:0.7em;color:white;font-family:'EB Garamond'; top: 10px;left: 10px; position:relative;">(click to scroll)</p> --->
					<div class="next"></div>
				</div>
			</li>

			<li class="project-li" style="background:black;">
				<img class="grindreel-img" src="/assets/img/grindreel/charlotte_uptown_3096x2322_bw.jpg"></img>
				<div id="experience_" class="grindreel"> 
					<h1>Experience</h1>
					<p>I have gained skill in a variety of languages, tools and frameworks across my 13 years of programming.  
					A sampling of some of the tools I use are below:</p>
					<ul class="looped">
						<li><a target="_blank" href="https://flutter.dev">Flutter</a></li>
						<li>C / C++</li>
						<li>Java</li>
						<li><a target="_blank" href="https://www.php.net">PHP</a></li>
						<li><a target="_blank" href="">Angular (7+)</a></li>
						<li><a target="_blank" href="https://dart.dev">Dart</a></li>
						<li><a target="_blank" href="https://www.lua.org">Lua</a></li>
						<li>MySQL</li>
						<li>SQL Server</a></li>
						<li>SQLite</li>
						<li>Apache</li>
						<li><a target="_blank" href="https://www.lucee.org">Coldfusion / Lucee</a></li>
						<li><a target="_blank" href="https://git-scm.com">Git</a></li>
					</ul>

					<p>A few of my favorite projects are listed below, and can be seen by clicking on the respective links.</p>
					<ul class="list work">
						<li><a href="http://ncat.edu/transfer-articulation">North Carolina A&T</a> - I was contracted to build an application to help students evaluate their transfer credits.  The school are big users of PHP, so it was fun to hook something up that works with Oracle and affects such a large group of users.</li>
						<li><a href="http://gogarbanzo.com/demo">Garbanzo</a> - Garbanzo is an application I wrote to help manage finances.  It expanded to become a mobile app as well.</li>
						<li><a href="http://mystframework.com">Myst</a> - For about 4 years, I informally maintained a web framework to make ColdFusion apps a bit easier to maintain.  It arose from a need I found at one of my previous positions to be able to seperate different types of code.</li>
					</ul>
				</div>
				<div class="more">
					<div class="next"></div>
				</div>
			</li>

			<li class="project-li" style="background:black;">
				<img class="grindreel-img" src="/assets/img/grindreel/charlotte_uptown_spectrum_3096x2322_bw.jpg"></img>
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
				<img class="grindreel-img" src="/assets/img/grindreel/charlotte_uptown_innervision_3096x2322_bw.jpg"></img>
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
