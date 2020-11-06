/*login*/
DROP TABLE IF EXISTS cms_session;
CREATE TABLE cms_session (
  session_uuid varchar(64) PRIMARY KEY DEFAULT( UUID() )
, session_tracker varchar(128)
, session_started datetime
);


DROP TABLE IF EXISTS cms_settings;
CREATE TABLE cms_settings (
	setting_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, setting_uuid varchar(64) DEFAULT( UUID() )
, setting_category varchar(128)
, setting_name varchar(128)
, setting_key varchar(128) 
, setting_value varchar(128) 
, setting_type varchar(128) 
, setting_tooltip varchar(128) 
);


DROP TABLE IF EXISTS cms_login;
CREATE TABLE cms_login (
  login_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, login_uuid varchar(64) DEFAULT(UUID()) NOT NULL
, login_usr varchar(64) NOT NULL
, login_pwd varchar(256) NOT NULL
, login_role int NOT NULL /*used to match against*/
, login_date_added datetime DEFAULT( CURRENT_DATE ) NOT NULL
, login_date_modified datetime DEFAULT( CURRENT_DATE ) NOT NULL
);


/* cms_login_role [ 'A' = admin, 'C' = contributor ] */
DROP TABLE IF EXISTS cms_login_role;
CREATE TABLE cms_login_role (
  lr_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, lr_rolename varchar(64) NOT NULL /*used to match against*/
);


DROP TABLE IF EXISTS cms_login_metadata;
CREATE TABLE cms_login_metadata (
  lm_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, lm_match_id int NOT NULL 
, lm_fname varchar(128)
, lm_mname varchar(128)
, lm_lname varchar(128)
, lm_prefix varchar(32)
, lm_suffix varchar(32)
, lm_description varchar(256)
, lm_avatar varchar(2048)
) ;


DROP TABLE IF EXISTS cms_login_group;
CREATE TABLE cms_login_group (
	lgroup_id int PRIMARY KEY AUTO_INCREMENT
,	lgroup_name varchar(64)
, lgroup_date_added datetime DEFAULT( CURRENT_DATE ) NOT NULL
, lgroup_date_modified datetime DEFAULT( CURRENT_DATE ) NOT NULL
) ;


DROP TABLE IF EXISTS cms_login_log;
CREATE TABLE cms_login_log (
  logintry_id int PRIMARY KEY AUTO_INCREMENT
, logintry_usr varchar(64)
, logintry_reason varchar(128)
, logintry_date_attempted datetime
) ;


/*content mgmt*/
DROP TABLE IF EXISTS cms_content;
CREATE TABLE cms_content (
  content_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, content_long_id varchar(64) DEFAULT( UUID() ) NOT NULL 
, content_collection_match_id varchar(64) NOT NULL /*foreign key yourself*/
, content_type_i int
, content_type varchar(128) NOT NULL /*foreign key yourself*/
, content_type_class char(1) /*f[ile], t[ext], m[emory]*/
, content_order int(11) NOT NULL
, content_text TEXT /*should be a uint8 field*/
, content_date_added datetime DEFAULT( CURRENT_DATE ) NOT NULL
, content_date_modified datetime DEFAULT( CURRENT_DATE ) NOT NULL
) ;


DROP TABLE IF EXISTS cms_featured_image;
CREATE TABLE cms_featured_image (
  fi_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, fi_long_id varchar(64) DEFAULT( UUID() ) NOT NULL
, fi_collection_match_id varchar(64) NOT NULL
, fi_type_class char(1) /*f[ile], t[ext], m[emory]*/
, fi_path VARCHAR(2048) NOT NULL 
, fi_date_added DATETIME DEFAULT( CURRENT_DATE ) NOT NULL
, fi_date_modified DATETIME DEFAULT( CURRENT_DATE ) NOT NULL
) ;

DROP TABLE IF EXISTS cms_content_types;
CREATE TABLE cms_content_types (
  ctype_id int(12) PRIMARY KEY AUTO_INCREMENT,
  ctype_name varchar(512) 
) ;


DROP TABLE IF EXISTS cms_collection;
CREATE TABLE cms_collection (
  collection_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, collection_long_id varchar(64) NOT NULL DEFAULT( UUID() )
, collection_name varchar(512) NOT NULL
, collection_owner varchar(64)
, collection_type varchar(64) NOT NULL /*FOREIGN KEY CONSTRAINT*/
, collection_date_added datetime DEFAULT( CURRENT_DATE ) NOT NULL
, collection_date_modified datetime DEFAULT( CURRENT_DATE ) NOT NULL
) ;


DROP TABLE IF EXISTS cms_collection_types; /*All bits can be here*/
CREATE TABLE cms_collection_types (
  collection_type_id int(12) PRIMARY KEY AUTO_INCREMENT NOT NULL
, collection_type_long_id varchar(64) DEFAULT( UUID() ) NOT NULL
, collection_type_name varchar(64) NOT NULL
, collection_type_description varchar(256)
, collection_type_date_added datetime DEFAULT( CURRENT_DATE ) NOT NULL
, collection_type_date_modified datetime DEFAULT( CURRENT_DATE ) NOT NULL
);


DROP TABLE IF EXISTS cms_collection_metadata; /*All bits can be here*/
CREATE TABLE cms_collection_metadata (
	pmd_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, pmd_collection_match_id varchar(64) NOT NULL
, pmd_isdraft bit(1)
, pmd_showfooter bit(1)
, pmd_showpimg bit(1)
, pmd_showcomments bit(1)
);


DROP TABLE IF EXISTS cms_preview_images;
CREATE TABLE cms_preview_images (
  primg_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, primg_postmatch_id varchar(64) NOT NULL /*which post do you belong to?*/
, primg_contentmatch_id varchar(64)  /*which image is it?*/
) ;


DROP TABLE IF EXISTS cms_keyword; 
/*subtle differences here, but keywords are usually globbed together and used
to enhance visibility of a search result*/
CREATE TABLE cms_keyword (
  keyword_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL
, keyword_uuid varchar(64) DEFAULT( UUID() ) NOT NULL
, keyword_postmatch_id varchar(64) NOT NULL /*the post that belongs to the post*/
, keyword_text varchar(128)
) ;


DROP TABLE IF EXISTS cms_metas;
/*metas are used to describe something a bit more, though they are also used in SEO*/
CREATE TABLE cms_metas (
  meta_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL
, meta_long_id varchar(64) default(uuid()) NOT NULL
, meta_postmatch_id varchar(64) NOT NULL
, meta_tag varchar(64) NOT NULL
, meta_type varchar(64)
, meta_content varchar(128)
) ;


DROP TABLE IF EXISTS cms_comments;
CREATE TABLE IF NOT EXISTS cms_comments (
 comment_id INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL
,comment_long_id varchar(64) DEFAULT(UUID()) NOT NULL
,comment_postmatch_id VARCHAR(64) NOT NULL
,comment_owner VARCHAR(128)
,comment_owneravatar VARCHAR(2048) /*a url typically...*/
,comment_text VARCHAR( 8192 ) NOT NULL
,comment_date_added DATETIME DEFAULT( CURRENT_DATE ) NOT NULL
,comment_date_modified DATETIME DEFAULT( CURRENT_DATE ) NOT NULL
);


/*categories ought to be built in from the beginning*/
DROP TABLE IF EXISTS cms_category;
CREATE TABLE IF NOT EXISTS cms_category (
  category_id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL
, category_uuid VARCHAR( 64 ) DEFAULT( UUID() ) NOT NULL
, category_name VARCHAR( 256 ) NOT NULL
, category_description VARCHAR( 1024 )
, category_date_added DATETIME DEFAULT( CURRENT_DATE ) NOT NULL
, category_date_modified DATETIME DEFAULT( CURRENT_DATE ) NOT NULL
);


DROP TABLE IF EXISTS cms_category_rel;
CREATE TABLE IF NOT EXISTS cms_category_rel (
  catrel_id int PRIMARY KEY AUTO_INCREMENT NOT NULL
, catrel_postmatch_id varchar(64) NOT NULL /*which post do you belong to?*/
, catrel_categorymatch_id varchar(64) NOT NULL  /*which category is it?*/
);


INSERT INTO cms_content_types ( ctype_name ) VALUES ( "octet-stream" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "text" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "audio" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "image" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "video" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "message" ); 
INSERT INTO cms_content_types ( ctype_name ) VALUES ( "application" ); 

/*the login should be hashed or done first*/
/*login, login*/
INSERT INTO cms_login ( login_usr, login_pwd, login_role ) VALUES ( 'login', 'd8c12a418edf9690461958def9e126bc53822eb7eb7a0d998a0609b51d07a8a53f7d323e816b21ab5fb2c79f5f1433d4', 0 );
INSERT INTO cms_login_metadata ( lm_match_id, lm_fname, lm_lname ) VALUES ( 1, 'Login', 'User' );

/*self, selfish*/
INSERT INTO cms_login ( login_usr, login_pwd, login_role ) VALUES ( 'self', 'ff4f94838b396fdba3a974285284050a8d3817f12ec72363607f424cc00eb914cfaa6166b06339fb8d2dce1bef9502bc', 1 );
INSERT INTO cms_login_metadata ( lm_match_id, lm_fname, lm_mname, lm_lname ) VALUES ( 2, 'Self', 'A', 'Self' );

/*lisa, lisa*/
INSERT INTO cms_login ( login_usr, login_pwd, login_role ) VALUES ( 'lisa', '091426ac2576e68f8894c40f7da51a6c13bb930ba24c80ccf71fa40eb90a403bacb9879a683c8ecc2132ca7f86ad4d33', 1 );
INSERT INTO cms_login_metadata ( lm_match_id, lm_fname, lm_lname ) VALUES ( 3, 'Lisa', 'Grimacher' );


INSERT INTO cms_login_role ( lr_rolename ) VALUES ( "Admin" ); 
INSERT INTO cms_login_role ( lr_rolename ) VALUES ( "Contributor" ); 

INSERT INTO cms_category ( category_name ) VALUES ( "Programming" );
INSERT INTO cms_category ( category_name ) VALUES ( "Music" );
INSERT INTO cms_category ( category_name ) VALUES ( "Instruments" );
INSERT INTO cms_category ( category_name ) VALUES ( "Scripts" );


/*Presets*/
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "bgcolor", "Background Color", "#ffffff", "hexmap", "Specify a background color" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "fgcolor", "Foreground Color", "#ffffff", "hexmap", "Specify a foreground color" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "favicon", "Favicon", "", "file", "Specify a default favicon" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "postorder", "Post Order", "ASC", "radio", "Are posts ordered in descending or ascending order?" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "postnumber", "Number of Posts to Display", "13", "number", "Change the number of posts" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "postfimage", "Show Featured Images", "false", "checkbox", "Enable featured images" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "ed_dandd", "Enable Drag and Drop?", "true", "checkbox", "Enable drag and drop for nodes" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "logo", "Default Logo", "", "file", "Specify a default logo" );
INSERT INTO cms_settings ( setting_category, setting_name, setting_key, setting_value, setting_type, setting_tooltip ) VALUES ( "APP", "primaryauthorid", "Default Author", "1", "text", "Specify a default author for all posts" );
