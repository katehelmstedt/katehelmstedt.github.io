!function(t,i,n,e){var s=function(n,e){this.elem=n,this.$elem=t(n),this.options=e,this.metadata=this.$elem.data("stickem-options"),this.$win=t(i)};s.defaults=(s.prototype={defaults:{item:".stickem",container:".stickem-container",stickClass:"stickit",endStickClass:"stickit-end",offset:0,start:0,onStick:null,onUnstick:null},init:function(){var i=this;return i.config=t.extend({},i.defaults,i.options,i.metadata),i.setWindowHeight(),i.getItems(),i.bindEvents(),i},bindEvents:function(){var i=this;i.$win.on("scroll.stickem",t.proxy(i.handleScroll,i)),i.$win.on("resize.stickem",t.proxy(i.handleResize,i))},destroy:function(){this.$win.off("scroll.stickem"),this.$win.off("resize.stickem")},getItem:function(i,n){var e=this,s=t(n),o={$elem:s,elemHeight:s.height(),$container:s.parents(e.config.container),isStuck:!1};e.windowHeight>o.elemHeight?(o.containerHeight=o.$container.outerHeight(),o.containerInner={border:{bottom:parseInt(o.$container.css("border-bottom"),10)||0,top:parseInt(o.$container.css("border-top"),10)||0},padding:{bottom:parseInt(o.$container.css("padding-bottom"),10)||0,top:parseInt(o.$container.css("padding-top"),10)||0}},o.containerInnerHeight=o.$container.height(),o.containerStart=o.$container.offset().top-e.config.offset+e.config.start+o.containerInner.padding.top+o.containerInner.border.top,o.scrollFinish=o.containerStart-e.config.start+(o.containerInnerHeight-o.elemHeight),o.containerInnerHeight>o.elemHeight&&e.items.push(o)):o.$elem.removeClass(e.config.stickClass+" "+e.config.endStickClass)},getItems:function(){var i=this;i.items=[],i.$elem.find(i.config.item).each(t.proxy(i.getItem,i))},handleResize:function(){this.getItems(),this.setWindowHeight()},handleScroll:function(){var t=this;if(t.items.length>0)for(var i=t.$win.scrollTop(),n=0,e=t.items.length;n<e;n++){var s=t.items[n];s.isStuck&&(i<s.containerStart||i>s.scrollFinish)||i>s.scrollFinish?(s.$elem.removeClass(t.config.stickClass),i>s.scrollFinish&&s.$elem.addClass(t.config.endStickClass),s.isStuck=!1,t.config.onUnstick&&t.config.onUnstick(s)):!1===s.isStuck&&i>s.containerStart&&i<s.scrollFinish&&(s.$elem.removeClass(t.config.endStickClass).addClass(t.config.stickClass),s.isStuck=!0,t.config.onStick&&t.config.onStick(s))}},setWindowHeight:function(){var t=this;t.windowHeight=t.$win.height()-t.config.offset}}).defaults,t.fn.stickem=function(t){return this.destroy=function(){this.each(function(){new s(this,t).destroy()})},this.each(function(){new s(this,t).init()})}}(jQuery,window,document);
