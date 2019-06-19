/*login*/
DROP TABLE IF EXISTS cms_login;
CREATE TABLE cms_login (
  login_id int PRIMARY KEY AUTO_INCREMENT
, login_usr varchar(64)
, login_pwd varchar(256)
) ;


DROP TABLE IF EXISTS cms_login_group;
CREATE TABLE cms_login_group (
	lgroup_id int PRIMARY KEY AUTO_INCREMENT
,	lgroup_name varchar(64)
, lgroup_date_added datetime
, lgroup_date_modified datetime 
) ;


DROP TABLE IF EXISTS cms_login_log;
CREATE TABLE cms_login_log (
  logintry_id int PRIMARY KEY AUTO_INCREMENT
, logintry_usr varchar(64)
, logintry_reason varchar(128)
, logintry_date_attempted datetime
) ;

/*finally, session-less sites need their own credential info*/


/*content mgmt*/
DROP TABLE IF EXISTS cms_content;
CREATE TABLE cms_content (
  content_id varchar(64) PRIMARY KEY
, content_postmatch_id varchar(64)
, content_type_i int
, content_type varchar(128)
, content_type_encoding varchar(32) /*could be base64, binary, ascii, ...*/
, content_order int(11)
, content_text TEXT
, content_date_added datetime
, content_date_modified datetime 
) ;


DROP TABLE IF EXISTS cms_content_types;
CREATE TABLE cms_content_types (
  ctype_id int(12) PRIMARY KEY AUTO_INCREMENT,
  ctype_name varchar(512) 
) ;


/*post*/
DROP TABLE IF EXISTS cms_post;
CREATE TABLE cms_post (
  post_id int PRIMARY KEY AUTO_INCREMENT
, post_long_id varchar(64)
, post_name varchar(512)
, post_type int
, post_date_added datetime
, post_date_modified datetime
) ;


DROP TABLE IF EXISTS cms_post_types; /*All bits can be here*/
CREATE TABLE cms_post_types (
  posttype_id int(12) PRIMARY KEY AUTO_INCREMENT
, posttype_long_id varchar(64)
, posttype_name varchar(64)
, posttype_description varchar(64)
, posttype_date_added datetime
, posttype_date_modified datetime
);

DROP TABLE IF EXISTS cms_post_metadata; /*All bits can be here*/
CREATE TABLE cms_post_metadata (
	pmd_id int PRIMARY KEY AUTO_INCREMENT
, pmd_postmatch_id varchar(64)
, pmd_isdraft bit(1)
, pmd_showfooter bit(1)
, pmd_showpimg bit(1)
, pmd_showcomments bit(1)
);


DROP TABLE IF EXISTS cms_preview_images;
CREATE TABLE cms_preview_images (
  primg_id int PRIMARY KEY AUTO_INCREMENT
, primg_postmatch_id varchar(64)  /*which post do you belong to?*/
, primg_contentmatch_id varchar(64)  /*which image is it?*/
) ;


DROP TABLE IF EXISTS cms_keywords; 
/*subtle differences here, but keywords are usually globbed together and used
to enhance visibility of a search result*/
CREATE TABLE cms_keywords (
  keyword_id INT PRIMARY KEY AUTO_INCREMENT
, keyword_postmatch_id varchar(64)  /*the post that belongs to the post*/
, keyword_text varchar(128)
) ;


DROP TABLE IF EXISTS cms_metas;
/*metas are used to describe something a bit more, though they are also used in SEO*/
CREATE TABLE cms_metas (
  meta_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL
, meta_postmatch_id varchar(64)  /*the post that belongs to the post*/
, meta_tag varchar(64)
, meta_type varchar(64)
, meta_content varchar(128)
) ;


DROP TABLE IF EXISTS cms_comments;
CREATE TABLE IF NOT EXISTS cms_comments (
 comment_id INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL
,comment_postmatch_id VARCHAR(64) NOT NULL
,comment_owner VARCHAR(128)
,comment_owneravatar VARCHAR(2048) /*a url typically...*/
,comment_text VARCHAR( 8192 ) NOT NULL
,comment_date_added DATETIME NOT NULL
,comment_date_modified DATETIME NOT NULL
);


/*categories ought to be built in from the beginning*/
DROP TABLE IF EXISTS cms_category;
CREATE TABLE IF NOT EXISTS cms_category (
 category_id INTEGER AUTO_INCREMENT PRIMARY KEY
,category_long_id VARCHAR( 64 )
,category_name VARCHAR( 256 )
,category_date_added DATETIME NOT NULL
,category_date_modified DATETIME NOT NULL
);

DROP TABLE IF EXISTS cms_category_rel;
CREATE TABLE IF NOT EXISTS cms_category_rel (
  catrel_id int PRIMARY KEY AUTO_INCREMENT
, catrel_postmatch_id varchar(64)  /*which post do you belong to?*/
, catrel_categorymatch_id varchar(64)  /*which category is it?*/
);


INSERT INTO cms_content_types ( ctype_name ) VALUES ( "octet-stream" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "text" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "audio" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "image" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "video" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "message" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "application" ); 

