/**
 * By James from http://www.xinotes.org/notes/note/515/
 */
function randomString( length ) {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split( '' );
    
    if ( !length ) {
        length = Math.floor( Math.random() * chars.length );
    }
    
    var str = '';
    for (var i = 0; i < length; i++) {
        str += chars[ Math.floor( Math.random() * chars.length )];
    }
    return str;
}

exports.randomString = randomString;

exports.random = randomString( 9 );

