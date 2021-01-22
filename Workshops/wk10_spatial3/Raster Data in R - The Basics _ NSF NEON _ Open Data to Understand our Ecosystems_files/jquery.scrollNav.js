!function(s){var t=function(t,e,i,n){if(s(t).length>0){var a=s(t).offset().top;e=n?e:0,s("html:not(:animated),body:not(:animated)").animate({scrollTop:a-i},e)}},e={classes:{loading:"sn-loading",failed:"sn-failed",success:"sn-active"},defaults:{sections:"h2",subSections:!1,sectionElem:"section",className:"scroll-nav",clickClass:"scroll-nav-series__sub-link",showHeadline:!0,headlineText:"Scroll To",scrollNav:"scrollNav",showTopLink:!0,topLinkText:"Top",fixedMargin:40,scrollOffset:40,animated:!0,speed:500,insertLocation:"insertBefore",arrowKeys:!1,scrollToHash:!0,onInit:null,onRender:null,onDestroy:null,onResetPos:null},_set_body_class:function(t){var i=s("body");"loading"===t?i.addClass(e.classes.loading):"success"===t?i.removeClass(e.classes.loading).addClass(e.classes.success):i.removeClass(e.classes.loading).addClass(e.classes.failed)},_find_sections:function(t){var i=e.settings.sections,n=[];if(e.settings.showTopLink){var a=t.children().first();a.is(i)||n.push(a.nextUntil(i).andSelf())}t.find(i).each(function(){n.push(s(this).nextUntil(i).andSelf())}),e.sections={raw:n}},_setup_sections:function(t){var i=[];s(t).each(function(t){var n=[],a=s(this),o=e.settings.scrollNav+"-"+(t+1),l=e.settings.showTopLink&&0===t&&!a.eq(0).is(e.settings.sections)?e.settings.topLinkText:a.filter(e.settings.sections).text();if(a.wrapAll("<"+e.settings.sectionElem+' id="'+o+'" class="'+e.settings.className+'__section" />'),e.settings.subSections){var c=a.filter(e.settings.subSections);c.length>0&&c.each(function(t){var i=o+"-"+(t+1),l=s(this).text();a.filter(s(this).nextUntil(c).andSelf()).wrapAll('<div id="'+i+'" class="'+e.settings.className+'__sub-section" />'),n.push({id:i,text:l})})}i.push({id:o,text:l,sub_sections:n})}),e.sections.data=i},_tear_down_sections:function(t){s(t).each(function(){var t=this.sub_sections;s("#"+this.id).children().unwrap(),t.length>0&&s(t).each(function(){s("#"+this.id).children().unwrap()})})},_setup_nav:function(t){var i=s("<span />",{class:e.settings.className+"__heading",text:e.settings.headlineText}),n=s("<div />",{class:e.settings.className+"__wrapper"}),a=s("<nav />",{class:e.settings.className,role:"navigation"}),o=s("<ol />",{class:e.settings.className+"__list"});s.each(t,function(t){var i,n=s("<li />",0===t?{id:"list-"+this.id,class:e.settings.className+"__item active "}:{id:"list-"+this.id,class:e.settings.className+"__item"}),a=s("<a />",{href:"#"+this.id,class:e.settings.className+"__link",text:this.text});this.sub_sections.length>0&&(n.addClass("is-parent-item"),i=s("<ol />",{class:e.settings.className+"__sub-list"}),s.each(this.sub_sections,function(){var t=s("<li />",{class:e.settings.className+"__sub-item"}),n=s("<a />",{href:"#"+this.id,class:e.settings.className+"__sub-link",text:this.text});i.append(t.append(n))})),o.append(n.append(a).append(i))}),e.settings.showHeadline?a.append(n.append(i).append(o)):a.append(n.append(o)),e.nav=a},_insert_nav:function(){var s=e.settings.insertLocation,t=e.settings.insertTarget;e.nav[s](t)},_setup_pos:function(){var t=e.nav,i=s(window).height(),n=t.offset().top,a=function(t){var e=s("#"+t.id),i=e.height();t.top_offset=e.offset().top,t.bottom_offset=t.top_offset+i};s.each(e.sections.data,function(){a(this),s.each(this.sub_sections,function(){a(this)})}),e.dims||(e.dims={vp_height:i,nav_offset:n})},_check_pos:function(){var t=e.nav,i=s(window).scrollTop(),n=i+e.settings.scrollOffset,a=i+e.dims.vp_height-e.settings.scrollOffset,o=[],l=[];i>e.dims.nav_offset-e.settings.fixedMargin?t.closest(".group-scrollnav-container").length?t.closest(".group-scrollnav-container").addClass("fixed"):t.addClass("fixed"):t.closest(".group-scrollnav-container").length?t.closest(".group-scrollnav-container").removeClass("fixed"):t.removeClass("fixed");var c=function(s){return s.top_offset>=n&&s.top_offset<=a||s.bottom_offset>n&&s.bottom_offset<a||s.top_offset<n&&s.bottom_offset>a};s.each(e.sections.data,function(){c(this)&&o.push(this),s.each(this.sub_sections,function(){c(this)&&l.push(this)})}),t.find("."+e.settings.className+"__item").removeClass("active").removeClass("in-view"),t.find("."+e.settings.className+"__sub-item").removeClass("active").removeClass("in-view"),s.each(o,function(s){0===s?t.find('a[href="#'+this.id+'"]').parents("."+e.settings.className+"__item").addClass("active").addClass("in-view"):t.find('a[href="#'+this.id+'"]').parents("."+e.settings.className+"__item").addClass("in-view")}),e.sections.active=o,s.each(l,function(s){0===s?t.find('a[href="#'+this.id+'"]').parents("."+e.settings.className+"__sub-item").addClass("active").addClass("in-view"):t.find('a[href="#'+this.id+'"]').parents("."+e.settings.className+"__sub-item").addClass("in-view")})},_init_scroll_listener:function(){s(window).on("scroll.scrollNav",function(){e._check_pos()})},_rm_scroll_listeners:function(){s(window).off("scroll.scrollNav")},_init_resize_listener:function(){s(window).on("resize.scrollNav",function(){e._setup_pos(),e._check_pos()})},_rm_resize_listener:function(){s(window).off("resize.scrollNav")},_init_click_listener:function(){s("."+e.settings.className).find("a."+e.settings.clickClass).on("click.scrollNav",function(i){i.preventDefault();var n=s(this).attr("href"),a=e.settings.speed,o=e.settings.scrollOffset,l=e.settings.animated;t(n,a,o,l)})},_rm_click_listener:function(){s("."+e.settings.className).find("a").off("click.scrollNav")},_init_keyboard_listener:function(i){e.settings.arrowKeys&&s(document).on("keydown.scrollNav",function(s){if(40===s.keyCode||38===s.keyCode){var n=function(s){for(var t=0,n=i.length;t<n;t++)if(i[t].id===e.sections.active[0].id){var a=40===s?t+1:t-1;return void 0===i[a]?void 0:i[a].id}}(s.keyCode);if(void 0!==n){s.preventDefault();var a="#"+n,o=e.settings.speed,l=e.settings.scrollOffset,c=e.settings.animated;t(a,o,l,c)}}})},_rm_keyboard_listener:function(){s(document).off("keydown.scrollNav")},init:function(i){return this.each(function(){var n=s(this);e.settings=s.extend({},e.defaults,i),e.settings.insertTarget=e.settings.insertTarget?s(e.settings.insertTarget):n,n.length>0?(e.settings.onInit&&e.settings.onInit.call(this),e._set_body_class("loading"),e._find_sections(n),n.find(e.settings.sections).length>0?(e._setup_sections(e.sections.raw),e._setup_nav(e.sections.data),e.settings.insertTarget.length>0?(e._insert_nav(),e._setup_pos(),e._check_pos(),e._init_scroll_listener(),e._init_resize_listener(),e._init_click_listener(),e._init_keyboard_listener(e.sections.data),e._set_body_class("success"),e.settings.scrollToHash&&t(window.location.hash),e.settings.onRender&&e.settings.onRender.call(this)):(console.log('Build failed, scrollNav could not find "'+e.settings.insertTarget+'"'),e._set_body_class("failed"))):(console.log('Build failed, scrollNav could not find any "'+e.settings.sections+'s" inside of "'+n.selector+'"'),e._set_body_class("failed"))):(console.log('Build failed, scrollNav could not find "'+n.selector+'"'),e._set_body_class("failed"))})},destroy:function(){return this.each(function(){e._rm_scroll_listeners(),e._rm_resize_listener(),e._rm_click_listener(),e._rm_keyboard_listener(),s("body").removeClass("sn-loading sn-active sn-failed"),s("."+e.settings.className).remove(),e._tear_down_sections(e.sections.data),e.settings.onDestroy&&e.settings.onDestroy.call(this),e.settings=[],e.sections=void 0})},resetPos:function(){e._setup_pos(),e._check_pos(),e.settings.onResetPos&&e.settings.onResetPos.call(this)}};s.fn.scrollNav=function(){var t,i=arguments[0];if(e[i])i=e[i],t=Array.prototype.slice.call(arguments,1);else{if("object"!=typeof i&&i)return s.error("Method "+i+" does not exist in the scrollNav plugin"),this;i=e.init,t=arguments}return i.apply(this,t)}}(jQuery);