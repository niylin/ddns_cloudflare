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

----------------------------------------------------------------------  

## 基于[CloudflareSpeedTest](https://github.com/XIU2/CloudflareSpeedTest) 的自动优选
#### 将脚本放在和CloudflareSpeedTest同目录下即可,会将测速结果解析到指定域名,修改脚本中相关参数,将将需要优选节点中的server改为指定域名,即实现优选
#### 将脚本添加为crontab定时任务,定时运行即可.同样依赖jq和curl,CloudflareSpeedTest和此脚本均可在termux中运行,利用闲置手机来运行
### crontab任务示例,每天8点运行一次
#### 0 8 * * * ~/CloudflareST/cfst.sh
#### 每两小时运行一次
#### 0 */2 * * * ~/CloudflareST/cfst.sh
<div>
  <button class="btn" data-clipboard-target="#code"></button>
  <pre><code id="code" class="language-python">
wget https://raw.githubusercontent.com/niylin/CFmanager/main/cfst.sh
  </code></pre>
</div>
