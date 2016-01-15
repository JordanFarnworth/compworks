/*!CK:1871221808!*//*1429498150,*/

if (self.CavalryLogger) { CavalryLogger.start_js(["F+f4r"]); }

__d("PhotoViewerInitPagelet",["ge","DOM","PhotoSnowlift","PhotoTags","PhotoTagger","PhotoTagApproval"],function(a,b,c,d,e,f,g,h,i,j,k,l){b.__markCompiled&&b.__markCompiled();function m(n){"use strict";i.attachTagger(n.tagging,n.tokenizer);var o=i.getInstance(),p=o.getRoot();new j([g('fbPhotoSnowliftAuthorName'),h.find(p,'span.fbPhotoTagList'),h.find(p,'div.fbPhotoPagesTagList')],g('fbPhotoSnowliftTagBoxes'),n.version);if(n.setupPhotoTagger){var q=new k(o);q.initSnowlift(n.tagging,n.tokenizer,n.userId);q.setQueueName(n.queueName);}new l(o);}e.exports=m;},null);
__d("XVideoEditController",["XController"],function(a,b,c,d,e,f){b.__markCompiled&&b.__markCompiled();e.exports=b("XController").create("\/video\/edit\/",{v:{type:"Int",required:true}});},null);