!function(n){n(document).ready(function(){var i=!1,e=function(){if(n(window).width()<1150&&!i)return i=!0,n("table.responsive").each(function(i,e){!function(i){i.wrap("<div class='table-wrapper' />");var e=i.clone();e.find("td:not(:first-child), th:not(:first-child)").css("display","none"),e.removeClass("responsive"),i.closest(".table-wrapper").append(e),e.wrap("<div class='pinned' />"),i.wrap("<div class='scrollable' />"),t=i,r=e,a=t.find("tr"),o=r.find("tr"),s=[],a.each(function(i){var e=n(this),t=e.find("th, td");t.each(function(){var e=n(this).outerHeight(!0);s[i]=s[i]||0,e>s[i]&&(s[i]=e)})}),o.each(function(i){n(this).height(s[i])});var t,r,a,o,s}(n(e))}),!0;i&&n(window).width()>1150&&(i=!1,n("table.responsive").each(function(i,e){var t;(t=n(e)).closest(".table-wrapper").find(".pinned").remove(),t.unwrap(),t.unwrap()}))};n(window).load(e),n(window).on("redraw",function(){i=!1,e()}),n(window).on("resize",e)})}(jQuery);
