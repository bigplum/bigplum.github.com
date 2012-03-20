--- 
wordpress_id: 941
layout: post
title: !binary |
  5Li6bmdpbnjnvJblhpnmlrBmaWx0ZXLmqKHlnZc=

date: 2010-12-14 17:35:32 +08:00
wordpress_url: http://pipa.tk/?p=941
---
filter模块与其他模块的配置不同，需注意第二行为HTTP_AUX_FILTER_MODULES，否则将不能正常运行。这是由于ngx_http_write_filter_module模块的特殊性导致的，必须保证filter模块后于ngx_http_write_filter_module加载，如果这个参数配置错误，模块的加载顺序就乱了。

<strong>"config" for filter modules:</strong>

ngx_addon_name=ngx_http_<your module>_module
HTTP_AUX_FILTER_MODULES="$HTTP_AUX_FILTER_MODULES ngx_http_<your module>_module"
NGX_ADDON_SRCS="$NGX_ADDON_SRCS $ngx_addon_dir/ngx_http_<your module>_module.c"

<strong>"config" for other modules:</strong>

ngx_addon_name=ngx_http_<your module>_module
HTTP_MODULES="$HTTP_MODULES ngx_http_<your module>_module"
NGX_ADDON_SRCS="$NGX_ADDON_SRCS $ngx_addon_dir/ngx_http_<your module>_module.c"

参考：<a href="http://www.evanmiller.org/nginx-modules-guide.html#compiling">http://www.evanmiller.org/nginx-modules-guide.html#compiling</a>
