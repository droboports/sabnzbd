<?php 
$app = "sabnzbd";
$appname = "SABnzbd";
$appversion = "0.7.20-1";
$appsite = "http://sabnzbd.org/";
$apphelp = "http://sabnzbd.org/live-chat/";

$applogs = array("/tmp/DroboApps/".$app."/log.txt",
                 "/mnt/DroboFS/Shares/DroboApps/".$app."/data/logs/".$app.".log",
                 "/mnt/DroboFS/Shares/DroboApps/".$app."/data/logs/".$app.".error.log");

$appprotos = array("http");
$appports = array("8081");
$droboip = $_SERVER['SERVER_ADDR'];
$apppage = $appprotos[0]."://".$droboip.":".$appports[0]."/";
if ($publicip != "") {
  $publicurl = $appprotos[0]."://".$publicip.":".$appports[0]."/";
} else {
  $publicurl = $appprotos[0]."://public.ip.address.here:".$appports[0]."/";
}
$portscansite = "http://mxtoolbox.com/SuperTool.aspx?action=scan%3a".$publicip."&run=toolpage";
?>
