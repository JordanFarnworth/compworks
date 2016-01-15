/*!CK:2820750296!*//*1425869448,*/

if (self.CavalryLogger) { CavalryLogger.start_js(["yfda3"]); }

__d("flashLog",["AsyncSignal","swfobject"],function(a,b,c,d,e,f,g,h){b.__markCompiled&&b.__markCompiled();e.exports.logPlayerVersion=function(){var i={c:'flash_version_log',m:JSON.stringify({flashVer:h.SWFObjectUtil.getPlayerVersion()})};new g('/common/scribe_endpoint.php',i).send();};},null);