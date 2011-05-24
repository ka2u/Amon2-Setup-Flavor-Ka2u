package Amon2::Setup::Asset::Inuit;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';

sub inuit_css {
q{@charset "UTF-8";
/*------------------------------------*\
	INUIT.CSS
\*------------------------------------*/
/*
Author:             Harry Roberts
Twitter:            @inuitcss
Author URL:         csswizardry.com
Project URL:        inuitcss.com
Version:            1.4.5
Codename:           Eskimo
Date:               21 May 2011

Copyright 2011 Harry Roberts

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/





/*------------------------------------*\
	RESET
\*------------------------------------*/
html,body,div,span,applet,object,iframe,
h1,h2,h3,h4,h5,h6,p,blockquote,pre,
a,abbr,acronym,address,big,cite,code,
del,dfn,em,img,ins,kbd,q,s,samp,
small,strike,strong,sub,sup,tt,var,
b,u,i,center,
dl,dt,dd,ol,ul,li,
fieldset,form,label,legend,
table,caption,tbody,tfoot,thead,tr,th,td,
article,aside,canvas,details,figcaption,figure,
footer,header,hgroup,menu,nav,section,summary,
time,mark,audio,video{
	margin:0;
	padding:0;
}
article,aside,details,figcaption,figure,footer,
header,hgroup,menu,nav,section{
	display: block;
}

table{
	border-collapse:collapse;
	border-spacing:0;
}
fieldset,img{ 
	border:0;
}
address,caption,cite,dfn,th,var{
	font-style:normal;
	font-weight:normal;
}
caption,th{
	text-align:left;
}
h1,h2,h3,h4,h5,h6{
	font-size:100%;
	font-weight:normal;
}
q:before,q:after{
	content:'';
}
abbr,acronym{
	border:0;
}





/*------------------------------------*\
	MAIN
\*------------------------------------*/
html{
	overflow-y:scroll; /* Force scrollbars 100% of the time */
	font-size:100%; /* Use 16px as per http://www.informationarchitects.jp/en/100e2r/ and http://www.wilsonminer.com/posts/2008/oct/20/relative-readability/ */
	font-family:Calibri, "Helvetica Neue", Arial, sans-serif; /* Swap these two lines around to switch between serif and sans */
	font-family:Cambria, Georgia, "Times New Roman", serif; /* Swap these two lines around to switch between serif and sans */
	line-height:1.5;
	background:url(../img/css/baseline.gif) 0 4px #fff;
	color:#333;
}
body{
	width:940px;
	min-height:100%;
	padding:10px;
	margin:0 auto;
	background:url(../img/css/grid.png) top center repeat-y;
}





/*------------------------------------*\
	GRIDS
\*------------------------------------*/
/*
Most frameworks rely on class="end" or similar to remove the margin from the last column in a row of grids. We don’t want to do that so we use a combination of margin- and negative margin-left. It’s clever...
We also allow you to use grid items as stand alone columns or in a series of columns. To use a series just wrap them all in <div class="grids">...</div>
*/
.grids{
	margin-left:-20px;
	overflow:hidden;
	clear:both;
}
ul.grids,
.cols-12 ul.grids{
	/* So we can make grids out of lists */
	margin:0 0 0 -20px;
	list-style:none;
}
.grid{
	float:left;
	margin:0 20px 0 0;
}
.grids .grid{
	margin:0 0 0 20px;
}

/*
Grid sizes based on 960.gs by @nathansmith
For the sake of file-size and load-time please delete all CSS pertaining to the grid system you aren’t using.
The ability to use one of two different grid systems from the same file means there is a lot of code needed to alter intricate styles--look out for lists!
*/

/*
16 column grid system -- default
*/
.grid-1		{ width:40px; }
.grid-2		{ width:100px; }
.grid-3		{ width:160px; }
.grid-4		{ width:220px; }

.grid-5		{ width:280px; }
.grid-6		{ width:340px; }
.grid-7		{ width:400px; }
.grid-8		{ width:460px; }

.grid-9		{ width:520px; }
.grid-10	{ width:580px; }
.grid-11	{ width:640px; }
.grid-12	{ width:700px; }

.grid-13	{ width:760px; }
.grid-14	{ width:820px; }
.grid-15	{ width:880px; }
.grid-16	{ width:940px; margin:0; }


/*
12 column grid system -- add ‘class="cols-12"’ to the html element to invoke this system.
*/

/*
12-col version
*/
.cols-12 body{
	background:url(../img/css/12-grid.png) top center repeat-y;
}

.cols-12 .grid-1		{ width:60px; }
.cols-12 .grid-2		{ width:140px; }
.cols-12 .grid-3		{ width:220px; }
.cols-12 .grid-4		{ width:300px; }

.cols-12 .grid-5		{ width:380px; }
.cols-12 .grid-6		{ width:460px; }
.cols-12 .grid-7		{ width:540px; }
.cols-12 .grid-8		{ width:620px; }

.cols-12 .grid-9		{ width:700px; }
.cols-12 .grid-10		{ width:780px; }
.cols-12 .grid-11		{ width:860px; }

/* Take care of grids 12-16 to cater for a switch from one system to the other. */
.cols-12 .grid-12,
.cols-12 .grid-13,
.cols-12 .grid-14,
.cols-12 .grid-15,
.cols-12 .grid-16		{ width:940px; margin:0; }





/*------------------------------------*\
	LOGO
\*------------------------------------*/
/*
Your logo is an image, not a h1: http://csswizardry.com/2010/10/your-logo-is-an-image-not-a-h1/
*/
#logo,
#logo img{
	display:block;
	width:auto; /* Width of your logo in pixels (ideally a round grid-number) */
	height:auto; /* Height of your logo in pixels */
}
/* Based on the fact that we need to use an <img /> in our markup, let’s hide the actual image and use a background on the <a>--this gives us sematically sound markup and the ability to use sprites for hover effects! */
#logo{
	background:url(/path/to/logo);
}
#logo:hover{
	/* Hover states */
	background-position:0 -00px;
}
#logo img{
	position:absolute;
	left:-99999px;
}





/*------------------------------------*\
	NAV
\*------------------------------------*/
#nav{
	list-style:none;
	width:100%;
	overflow:hidden;
	margin:0 0 1.5em 0;
}
#nav li{
	float:left;
}
#nav a{
	display:block;
}
/*
http://csswizardry.com/2011/01/create-a-centred-horizontal-navigation/
Add a class of centred/centered to create a centred nav.
*/
#nav.centred,
#nav.centered{
	text-align:center;
}
#nav.centred li,
#nav.centered li{
	display:inline;
	float:none;
}
#nav.centred a,
#nav.centered a{
	display:inline-block;
}





/*------------------------------------*\
	TYPE
\*------------------------------------*/
/*--- HEADINGS ---*/
h1{
	font-size:2em;			/* 32px */
	margin-bottom:0.75em;	/* 24px */
	line-height:1.5;		/* 48px */
}
h2{
	font-size:1.5em;		/* 24px */
	margin-bottom:1em;		/* 24px */
	line-height:1;			/* 24px */
}
h3{
	font-size:1.25em;		/* 20px */
	margin-bottom:1.2em;	/* 24px */
	line-height:1.2;		/* 24px */
}
h4{
	font-size:1.125em;		/* 18px */
	margin-bottom:1.333em;	/* 24px */
	line-height:1.333;		/* 24px */
}
h5{
	font-weight:bold;
}
h5,
h6{
	font-size:1em;			/* 16px */
	margin-bottom:1.5em;	/* 24px */
	line-height:1.5;		/* 24px */
}

/*--- PARAGRAPHS ---*/
p{
	margin-bottom:1.5em;
}
/*
Mo’ robust paragraph indenting: http://csswizardry.com/2010/12/mo-robust-paragraph-indenting/
Uncomment to activate
p+p{
	text-indent:2em;
	margin-top:-1.5em;
}
*/

/*--- LINKS ---*/
/*
Say no to negative hovers!
A negative hover is one whose appearance is subtracted from on hover rather than added to.
*/
a{
	text-decoration:none;
}
a:visited{
	opacity:0.8; /* A bit generic, but it’s a bare minumum... */
}
a:hover{
	text-decoration:underline;
}
a:active,
a:focus{
	/* Give clicked links a depressed effect. */
	position:relative;
	top:1px;
}

/*--- LISTS ---*/
ul,
ol{
	margin:0 0 1.5em 60px;
}
ul ul,
ol ol,
ul ol,
ol ul{
	/* Let’s take care of lists in lists */
	margin:0 0 0 60px;
}
dl{
	margin-bottom:1.5em;
}
dt{
	font-weight:bold;
}
dt:after,
dt::after{
	content:":";
}
dd{
	margin-left:60px;
}
/*
I personally love this next one. Create a list of keywords by adding a single class to a <ul>:
*/
.keywords{
	list-style:none;
	margin:0 0 1.5em;
}
.keywords li{
	display:inline;
	text-transform:lowercase;
}
.keywords li:first-of-type{
	text-transform:capitalize;
}
.keywords li:after,
.keywords li::after{
	content:", ";
}
.keywords li:last-of-type:after,
.keywords li:last-of-type::after{
	content:".";
}

/*
Lists in the 12 col version
*/
.cols-12 ul,
.cols-12 ol,
.cols-12 dd{
	margin-left:80px;
}

/*--- QUOTES ---*/
blockquote{
	text-indent:-0.4em; /* Hang that punctuation */
}
blockquote b,
blockquote .source{
	/* Mark the source up with either a <b> or another element of your choice with a class of source. */
	display:block;
	text-indent:0;
}

/*--- GENERAL ---*/
q,
i,
em,
cite{
	font-style:italic;
	font-weight:inherit;
}
b,
strong{
	font-weight:bold;
	font-style:inherit;
}
mark{
	background:#ffc;
}
s,
del{
	text-decoration:line-through;
}
small{
	font-size:0.75em;
	line-height:1;
}

/*--- CODE ---*/
pre,
code{
	font-family:monospace;
	font-size:1em;
}
pre{
	overflow:auto;
	margin-bottom:1.5em;
	line-height:24px; /* Having to define explicit pixel values :( */
}
code{
	line-height:1;
}





/*------------------------------------*\
	IMAGES
\*------------------------------------*/
img{
	max-width:100%;
	height:auto;
	/* Give it some text styles to offset alt text */
	font-style:italic;
	color:#c00;
}
img.left	{ margin:0 20px 0 0; }
img.right	{ margin:0 0 0 20px; }

/*--- FLASH/VIDEO ---*/
object,
embed,
video{
	max-width:100%;
	height:auto;
}





/*------------------------------------*\
	FORMS
\*------------------------------------*/
/*
Unfortunately, and somewhat obviously, forms don’t fit the baseline all too well. Perhaps in a later version...
*/
fieldset{
	padding:10px;
	border:1px solid #ccc;
	margin-bottom:1.5em;
}
label{
	display:block;
	cursor:pointer;
}
label:after,
label::after{
	content:":";
}
input,
textarea{
	font-family:inherit;
	font-size:1em;
	line-height:1.5;
}

/*
Nice UI touch for placeholders. To get placeholders working cross-browser see @dan_bentley’s jQuery plugin: https://github.com/danbentley/placeholder
*/
[placeholder]{
	cursor:pointer;
}
[placeholder]:active,
[placeholder]:focus{
	cursor:text;
}
.check-list{
	width:100%;
	overflow:hidden;
	list-style:none;
	margin:0 0 1.5em 0;
}
.cols-12 .check-list{
	/* Change to suit 12 col version */
	margin-left:0;
}
.check-list li{
	width:25%;
	float:left;
}
.check-label{
	display:inline;
}
.check-label:after,
.check-label::after{
	content:normal;
}
.button{
	cursor:pointer;
}
fieldset > :last-child{
	/* Remove the margin from the last element in the fieldset--this makes our padding more consistent. */
	margin:0;
}





/*------------------------------------*\
	TABLES
\*------------------------------------*/
/*
Unfortunately, and somewhat obviously, tables don’t fit the baseline all too well. Perhaps in a later version...
*/
table{
	margin-bottom:1.5em;
	width:100%;
	max-width:100%;
}
thead tr:last-of-type th{
	/* Thicker border on the table-headers of the last row in the table head */
	border-bottom-width:2px;
}
tbody th{
	/* Thicker right border on table-headers in the table body */
	border-right-width:2px;
}
th:empty{
	/* Hide the borders on any empty table-headers */
	border:none;
}
th,td{
	vertical-align:top;
	padding:0.75em;
	border:1px solid #ccc;
}
th{
	font-weight:bold;
	text-align:center
}
td[colspan]{
	/* This looks lovely, trust me... */
	text-align:center;
}
td[rowspan]{
	/* ...as does this. */
	vertical-align:middle;
}
tbody tr:nth-of-type(odd){
	background:rgba(0,0,0,0.05);
}
tfoot{
	text-align:center;
}
tfoot td{
	border-top-width:2px;
}





/*------------------------------------*\
	MESSAGES
\*------------------------------------*/
/*
Unfortunately feedback messages don’t fit the baseline all too well. Perhaps in a later version...
*/
.message{
	font-weight:normal;
	display:block;
	padding:10px 10px 10px 36px;
	border:1px solid #ccc;
	margin:0 0 1.5em 0;
	
	-moz-border-radius:2px;
	-webkit-border-radius:2px;
	border-radius:2px;
	-moz-box-shadow:0 1px 0 rgba(255,255,255,0.5) inset;
	-webkit-box-shadow:0 1px 0 rgba(255,255,255,0.5) inset;
	box-shadow:0 1px 0 rgba(255,255,255,0.5) inset;
}
/* With multiple errors it’s nice to group them. */
ul.message{
	list-style:decimal outside; /* It’s also handy to number them. However, they might not necessarily be in a particular order, so we spoof it by putting numbers on an unordered list */
	padding:10px 10px 10px 56px;
}
.cols-12 ul.message{
	/* Change to suit 12 col version */
	margin-left:0;
}
.error{
	border-color:#fb5766;
	background:url(../img/css/icons/error.png) 10px center no-repeat #fab;
}
.success{
	border-color:#83ba77;
	background:url(../img/css/icons/success.png) 10px center no-repeat #d1feba;
}
.info{
	border-color:#85a5be;
	background:url(../img/css/icons/info.png) 10px center no-repeat #c4dbec;
}
.warning{
	border-color:#d8d566;
	background:url(../img/css/icons/warning.png) 10px center no-repeat #fef8c4;
}





/*------------------------------------*\
	MISC
\*------------------------------------*/
.accessibility{
	/* Hide content off-screen without hiding from screen-readers. N.B. This is not suited to RTL languages */
	position:absolute;
	left:-99999px;
}
.more-link:after,	/* <= CSS2.1 syntax */
.more-link::after{ 	/* CSS3 syntax */
	/* Too many people use &raquo; in their markup to signify progression/movement, that ain’t cool. Let’s insert that using content:""; */
	content:" »";
}





/*------------------------------------*\
	CLASSES
\*------------------------------------*/
/*
Some not-too-pretty and insementic classes to do odd jobs.
*/
.left	{ float:left; }
.right	{ float:right; }
.clear	{ clear:both; float:none; }

.text-left		{ text-align:left; }
.text-right		{ text-align:right; }
.text-center,
.text-centre	{ text-align:center; }





/*------------------------------------*\
	DIAGNOSTICS
\*------------------------------------*/
/*
APPLY A CLASS OF .debug TO THE HTML ELEMENT ONLY WHEN YOUR SITE IS ON DEV

Turn the grids back on. Idea given by @VictorPimentel
*/

.debug		{ background:url(../img/css/baseline.gif) 0 4px #fff!important; }
.debug body	{ background:url(../img/css/grid.png) top center repeat-y!important; }
.cols-12.debug body	{ background:url(../img/css/12-grid.png) top center repeat-y!important; }

/*
Red border == something is wrong
Yellow border == something may be wrong, you should double check.
Green border == perfect, nice one!
*/

/* Styles */
.debug [style]{
	/* Inline styles aren’t great, can this be avoided? */
	outline:5px solid yellow;
}

/* Images */
.debug img{
	/* Images without alt attributes are bad! */
	outline:5px solid red;
}
.debug img[alt]{
	/* Images with alt attributes are good! */
	outline-color:green;
}
.debug img[alt=""]{
	/* Images with empty alt attributes are okay in the right circumstances. */
	outline-color:yellow;
}

/* Links */
.debug a{
	/* Links without titles are yellow, does your link need one? */
	outline:5px solid yellow;
}
.debug a[title]{
	/* Links with titles are green, title attributes can be very useful! */
	outline-color:green;
}
.debug a[href="#"]{
	/* Were you meant to leave that hash in there? */
	outline-color:yellow;
}
.debug a[target]/*,
.debug a[onclick],
.debug a[href*=javascript]*/{
	/* What were you thinking?! */
	outline-color:red;
}

/* Classes/IDs */
.debug [class=""],
.debug [id=""]{
	/* Is this element meant to have an empty class/ID? */
	outline:5px solid yellow;
}





/*------------------------------------*\
	NARROW
\*------------------------------------*/
/*
CSS for tablets and narrower devices
*/





@media (min-width: 721px) and (max-width: 960px){
/*------------------------------------*\
	MAIN
\*------------------------------------*/
body{
	width:700px;
	background:url(../img/css/grid-720.png) top center repeat-y;
}
/*
12-col version
*/
.cols-12 body	{ background:url(../img/css/12-grid-720.png) top center repeat-y; }

/*
Debug version
*/
.debug body	{ background:url(../img/css/grid-720.png) top center repeat-y!important; }

/*
12-col AND debug version
*/
.debug.cols-12 body	{ background:url(../img/css/12-grid-720.png) top center repeat-y!important; }





/*------------------------------------*\
	GRIDS
\*------------------------------------*/
/*
16 cols
*/
.grid-1		{ width:25px; }
.grid-2		{ width:70px; }
.grid-3		{ width:115px; }
.grid-4		{ width:160px; }

.grid-5		{ width:205px; }
.grid-6		{ width:250px; }
.grid-7		{ width:295px; }
.grid-8		{ width:340px; }

.grid-9		{ width:385px; }
.grid-10	{ width:430px; }
.grid-11	{ width:475px; }
.grid-12	{ width:520px; }

.grid-13	{ width:565px; }
.grid-14	{ width:610px; }
.grid-15	{ width:655px; }
.grid-16	{ width:700px; }

/*
12 cols
*/
.cols-12 .grid-1	{ width:40px; }
.cols-12 .grid-2	{ width:100px; }
.cols-12 .grid-3	{ width:160px; }
.cols-12 .grid-4	{ width:220px; }

.cols-12 .grid-5	{ width:280px; }
.cols-12 .grid-6	{ width:340px; }
.cols-12 .grid-7	{ width:400px; }
.cols-12 .grid-8	{ width:460px; }

.cols-12 .grid-9	{ width:520px; }
.cols-12 .grid-10	{ width:580px; }
.cols-12 .grid-11	{ width:640px; }

/* Take care of grids 12-16 to cater for a switch from one system to the other */
.cols-12 .grid-12,
.cols-12 .grid-13,
.cols-12 .grid-14,
.cols-12 .grid-15,
.cols-12 .grid-16	{ width:700px; }





/*------------------------------------*\
	TYPE
\*------------------------------------*/
/*--- LISTS ---*/
ul,
ol{
	margin:0 0 1.5em 45px;
}
ul ul,
ol ol,
ul ol,
ol ul{
	/* Let’s take care of lists in lists */
	margin:0 0 0 45px;
}
dd{
	margin-left:45px;
}

/*
Lists in the 12 col version
*/
.cols-12 ul,
.cols-12 ol,
.cols-12 dd{
	margin-left:60px;
}
}
/*--- END NARROW ---*/





/*------------------------------------*\
	MOBILE
\*------------------------------------*/
/*
CSS for mobile devices.
Linearise it!
*/





@media (max-width: 720px){
/*------------------------------------*\
	MAIN
\*------------------------------------*/
html,
body{
	background:#fff;
}
.debug,
.debug body,
.cols-12,
.cols-12 body,
.debug.cols-12,
.debug.cols-12 body{
	background:#fff!important;
}
html{
	font-size:1.125em;
}
body{
	padding:20px;
	width:auto;
	-webkit-text-size-adjust:none;
}
.grid{
	width:auto;
	float:none;
}





/*------------------------------------*\
	LOGO
\*------------------------------------*/
#logo{
	margin:0 auto 1.5em;
}





/*------------------------------------*\
	TYPE
\*------------------------------------*/
/*--- LISTS ---*/
ul,
ol{
	margin:0 0 1.5em 25px;
}
ul ul,
ol ol,
ul ol,
ol ul{
	/* Let’s take care of lists in lists */
	margin:0 0 0 25px;
}
dd{
	margin-left:25px;
}

/*
Override 12 col settings
*/
.cols-12 ul,
.cols-12 ul,
.cols-12 dd{
	margin-left:25px;
}




/*------------------------------------*\
	IMAGES
\*------------------------------------*/
img.left,
img.right	{ max-width:50%; height:auto; }
}
/*--- END MOBILE ---*/





/*------------------------------------*\
	PRINT
\*------------------------------------*/
/*
Good ol’ fashioned paper...
*/





@media print{
/*------------------------------------*\
	MAIN
\*------------------------------------*/
/*
Give everything some decent contrast.
*/
*{
	background:#fff;
	color:#000;
	text-shadow:none!important;
}
/*
Set a nice measure and take the font down to print-acceptable sizes.
*/
body{
	width:75%;
	margin:0 auto;
	font-size:0.75em; /* 12px (if base font-size was 16px) */
}
/*
A list of things you don’t want printing. Add to/subtract from as necessary. 
*/
#nav,
#footer{
	display:none;
}
#logo img{
	position:static;
}
/*
Linearise
*/
.grid{
	width:auto;
	float:none;
	clear:both;
}
/*
Don’t let images break anything.
*/
img{
	max-width:100%;
	height:auto;
}
/*
Messages look odd with just borders.
*/
.message{
	border:none;
	font-weight:bold;
}
/*
Try to avoid tables spanning multiple pages. Not failsafe, but a good start.
*/
table{
	page-break-before:always;
}
/*
Show the accessibility class.
*/
.accessibility{
	position:static;
}
/*
Display the href of any links.
*/
a:link:after,a:visited:after,
a:link::after,a:visited::after{
	content:" (" attr(href) ")";
	font-size:smaller;
}
/*
Any links that are root relative to your site need prepending with your URL.
*/
a[href^="/"]:after,
a[href^="/"]::after{
	content:" (http://yoururlhere.com" attr(href) ")";
	font-size:smaller;
}
/*
Any Flash/video content can’t be printed so leave a message.
*/
object:after,
object::after{
	content:"Flash/video content. Head to http://yoururlhere.com/ to view this content.";
	display:block;
	font-weight:bold;
	margin-bottom:1.5em;
}
}
/*--- END PRINT ---*/};
}

sub style_css {
q{/*------------------------------------*\
	MAIN
\*------------------------------------*/
html{
	font-family:"Helvetica Neue", Arial, sans-serif;
    color: #3d3d3d;
/*	color:#e4eef6;
	background:#4a8ec2;
	background:-moz-linear-gradient(-90deg,#5998c7,#4a8ec2) fixed;
	background:-webkit-gradient(linear,left top,left bottom,from(#5998c7),to(#4a8ec2)) fixed;
*/
}
body{
	background:none;
	padding-top:50px;
	text-shadow:0 -1px 0 rgba(0,0,0,0.5), 0 1px 0 rgba(255,255,255,0.25);
}
#page{
	margin:0 auto;
	float:none;
	text-align:center;
}
header {
}
footer {
}




/*------------------------------------*\
	TYPE
\*------------------------------------*/
h1{
	font-weight:bold;
	font-size:3em;
	line-height:1;
}
a{
	color:inherit;
}





/*------------------------------------*\
	IMAGES
\*------------------------------------*/
#logo{
	margin-bottom:1.5em;
}





/*------------------------------------*\
	NARROW
\*------------------------------------*/
/*
CSS for tablets and narrower devices
*/





@media (min-width: 721px) and (max-width: 960px){}
/*--- END NARROW ---*/





/*------------------------------------*\
	MOBILE
\*------------------------------------*/
/*
CSS for mobile devices.
Linearise it!
*/





@media (max-width: 720px){
body{
	font-size:0.75em;
}
}
/*--- END MOBILE ---*/};
}



1;
__END__

=encoding utf8

=head1 NAME

Amon2::Setup::Asset::Inuit -

=head1 SYNOPSIS

  use Amon2::Setup::Asset::Inuit;

=head1 DESCRIPTION

Amon2::Setup::Asset::Inuit is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kazuhiro Shibuya

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
