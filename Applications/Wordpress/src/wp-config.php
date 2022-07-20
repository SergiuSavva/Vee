<?php

/**

 * The base configuration for WordPress

 *

 * The wp-config.php creation script uses this file during the installation.

 * You don't have to use the web site, you can copy this file to "wp-config.php"

 * and fill in the values.

 *

 * This file contains the following configurations:

 *

 * * Database settings

 * * Secret keys

 * * Database table prefix

 * * ABSPATH

 *

 * @link https://wordpress.org/support/article/editing-wp-config-php/

 *

 * @package WordPress

 */


// ** Database settings - You can get this info from your web host ** //

/** The name of the database for WordPress */

define( 'DB_NAME', 'wp' );


/** Database username */

define( 'DB_USER', 'root' );


/** Database password */

define( 'DB_PASSWORD', 'mysqlrootpass' );


/** Database hostname */

define( 'DB_HOST', 'database:3306' );


/** Database charset to use in creating database tables. */

define( 'DB_CHARSET', 'utf8' );


/** The database collate type. Don't change this if in doubt. */

define( 'DB_COLLATE', '' );


/**#@+

 * Authentication unique keys and salts.

 *

 * Change these to different unique phrases! You can generate these using

 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.

 *

 * You can change these at any point in time to invalidate all existing cookies.

 * This will force all users to have to log in again.

 *

 * @since 2.6.0

 */

define( 'AUTH_KEY',         'mP(Ds.oP#]P?{](.@`~-/NWibU(hz#9SUzL0-*>if 5m!coFx.^AiZ|Y7dsH+1l#' );

define( 'SECURE_AUTH_KEY',  '.Fr/:(Q:Tn8:B0pjKKn>=-RIU/~aM7QoDzrC4+<;Hq}DGsJnPq426-7k-g |&T+a' );

define( 'LOGGED_IN_KEY',    'UIU1>S7**cgU8Wd$I>$]u?VOIb4(mrAqq#?rW%oWJ+t<@dG;Q;_B)n&UkFZk]W;l' );

define( 'NONCE_KEY',        'BVt%IW+lPowR=Dfq]f,y,@0jhOsKnVo)t$-/ljX^o85:bE#1z?NaYLU#j|D}JtC4' );

define( 'AUTH_SALT',        '?KbwQ3D{ Zf(pQd# >=_|j=@6m@8SW2b9+:_{&_Ao)hpWyFQxZsjKf(5.Hp<yX3k' );

define( 'SECURE_AUTH_SALT', '^t@V-G>um,nGBGl=RWP7~tqY; @uH7,Fa|>:u5cHZk$5/zAt@}Cm(J7}:goB@=L;' );

define( 'LOGGED_IN_SALT',   ',pj2hTG`9&0@`U_%u]!8|?Ga_sY7qrOo~IYv%^729^v`q5U_UWve)tLvkO^5,{FS' );

define( 'NONCE_SALT',       '!8e6X=Rj/`%S=JJaFxB.+_cmjyT&F1,ZH0;3saEFt(zEDUJyUO6e_y:pl]uNa5@b' );


/**#@-*/


/**

 * WordPress database table prefix.

 *

 * You can have multiple installations in one database if you give each

 * a unique prefix. Only numbers, letters, and underscores please!

 */

$table_prefix = 'wp_';


/**

 * For developers: WordPress debugging mode.

 *

 * Change this to true to enable the display of notices during development.

 * It is strongly recommended that plugin and theme developers use WP_DEBUG

 * in their development environments.

 *

 * For information on other constants that can be used for debugging,

 * visit the documentation.

 *

 * @link https://wordpress.org/support/article/debugging-in-wordpress/

 */

define( 'WP_DEBUG', false );


/* Add any custom values between this line and the "stop editing" line. */




define( 'FS_METHOD', 'direct' );
/**
 * The WP_SITEURL and WP_HOME options are configured to access from any hostname or IP address.
 * If you want to access only from an specific domain, you can modify them. For example:
 *  define('WP_HOME','http://example.com');
 *  define('WP_SITEURL','http://example.com');
 *
 */
if ( defined( 'WP_CLI' ) ) {
	$_SERVER['HTTP_HOST'] = '127.0.0.1';
}

define( 'WP_HOME', 'http://' . $_SERVER['HTTP_HOST'] . '/' );
define( 'WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST'] . '/' );
define( 'WP_AUTO_UPDATE_CORE', false );
/* That's all, stop editing! Happy publishing. */


/** Absolute path to the WordPress directory. */

if ( ! defined( 'ABSPATH' ) ) {

	define( 'ABSPATH', __DIR__ . '/' );

}


/** Sets up WordPress vars and included files. */

require_once ABSPATH . 'wp-settings.php';

/**
 * Disable pingback.ping xmlrpc method to prevent WordPress from participating in DDoS attacks
 * More info at: https://docs.bitnami.com/general/apps/wordpress/troubleshooting/xmlrpc-and-pingback/
 */
if ( !defined( 'WP_CLI' ) ) {
	// remove x-pingback HTTP header
	add_filter("wp_headers", function($headers) {
		unset($headers["X-Pingback"]);
		return $headers;
	});
	// disable pingbacks
	add_filter( "xmlrpc_methods", function( $methods ) {
		unset( $methods["pingback.ping"] );
		return $methods;
	});
}
