
/**
* get current system os
*/
function getSystemOS() {
  //set os
  var os = {};
  //get user-agent
  var ua = navigator.userAgent.toLowerCase();
  //print ua
  //console.log( ua )
  //reg
  os.firefox = ua.match( /firefox\/([\d.]+)/ )
  os.chrome  = ua.match( /chrome\/([\d.]+)/ )
  os.ie      = ua.match( /msie\/([\d.]+)/ )
  os.opera   = ua.match( /opera\/([\d.]+)/ )
  os.safari  = ua.match( /safari\/([\d.]+)/ )
  //conditions
  if      ( os.chrome  && os.chrome.toString().split('/')[0]  == 'chrome' )  return 'chrome';  //alert('chrome')
  else if ( os.firefox && os.firefox.toString().split('/')[0] == 'firefox' ) return 'firefox'; //alert('firefox')
  else if ( os.ie      && os.ie.toString().split('/')[0]      == 'ie' )      return 'ie';      //alert('ie')
  else if ( os.opera   && os.opera.toString().split('/')[0]   == 'opera' )   return 'opera';   //alert('opera')
  else if ( os.safari  && os.safari.toString().split('/')[0]  == 'safari' )  return 'safari';  //alert('safari')
}