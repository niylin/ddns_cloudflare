## 通过cloud flare API 来使用ddns
------------------------------------------
##  使用方法 
####  通过 ping0.cc 来获取本机ip,如果使用vpn或代理工具,请将*.ping0.cc加入代理黑名单.以确保可以获取真实IP
####  请先安装 curl 和 jq
####  修改脚本中CF_Key和CF_Email的值为cloud flare全局密钥和邮箱
-------------------------------------------

<div>
  <button class="btn" data-clipboard-target="#code"></button>
  <pre><code id="code" class="language-python">
  ./ddns.sh domain            #ipv6 ddns
  </code></pre>
</div>
<div>
  <button class="btn" data-clipboard-target="#code"></button>
  <pre><code id="code" class="language-python">
  ./ddns.sh domain A         #ipv4 ddns
  </code></pre>
</div>
----------------------------------------------------------------------  

运行日志位于同目录下ddns.log
