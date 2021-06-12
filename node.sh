#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin
export PATH

which yum >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
    Main=apt-get
else
    Main=yum
fi

function ssr(){
    echo -e "\033[32m Docker运行状态检查 \033[0m"
    docker version > /dev/null || curl -fsSL get.docker.com | bash
    service docker restart

        read -p "Please input NodeID(Default NodeID:1)：" nodeid
        [ -z "${nodeid}" ] && nodeid=1
        echo
        echo "-----------------------------------------------------"
        echo "nodeid = ${nodeid}"
        echo "-----------------------------------------------------"
        echo
        read -p "Please input URL(Default Url:https://www.xn--9kq078cs77a.com)：" host
        [ -z "${host}" ] && host=https://www.xn--9kq078cs77a.com
        echo
        echo "-----------------------------------------------------"
        echo "host = ${host}"
        echo "-----------------------------------------------------"
        echo
        read -p "Please input KEY(Default Key:key)：" muKey
        [ -z "${muKey}" ] && muKey=key
        echo
        echo "-----------------------------------------------------"
        echo "muKey = ${muKey}"
        echo "-----------------------------------------------------"
        echo
        read -p "Please input Offsetted Port(Default Port:10086)：" port_1
        [ -z "${port_1}" ] && port_1=10086
        echo
        echo "-----------------------------------------------------"
        echo "port_1 = ${port_1}"
        echo "-----------------------------------------------------"
        echo
        read -p "Please input Origin Port(Default Port:10089)：" port_2
        [ -z "${port_2}" ] && port_2=10089
        echo
        echo "-----------------------------------------------------"
        echo "port_2 = ${port_2}"
        echo "-----------------------------------------------------"
        echo

        docker run -d --name=s${nodeid} -e NODE_ID=${nodeid} -e API_INTERFACE=modwebapi -e WEBAPI_URL=${host}  -e SPEEDTEST=0 -e WEBAPI_TOKEN=${muKey} --log-opt max-size=50m --log-opt max-file=3 -p ${port_1}:${port_2}/tcp -p ${port_1}:${port_2}/udp  --restart=always v2raysrgo/ssrgo

        echo -e "\033[32m 安装完成 \033[0m"

}

function v2ray_opt(){
echo "--------------------------------------------------------------"
echo "##############################################################"
echo "# 一键对接脚本v2.0                                           #"
echo "#                                                            #"
echo "# Author：Siemenstutorials                                   #"
echo "#                                                            #"
echo "# Youtube channel:https://www.youtube.com/c/siemenstutorials #"
echo "#                                                            #"
echo "# 适用环境 Debian/Ubuntu/Cent OS                             #"
echo "##############################################################"
echo "--------------------------------------------------------------"
    echo -e "\033[41;33m 请选择v2ra后端对接类型: \033[0m"
    echo -e "\033[32m [1] Richo版V2ray \033[0m"
    echo -e "\033[32m [2] CFTLS版V2ray \033[0m"
    read opt
    echo " "
    echo "---------------------------------------------------------------------------"

    if [ "$opt"x = "1"x ]; then
    v2richo

    elif [ "$opt"x = "2"x ]; then
    v2tls

    else
        echo -e "\033[41;33m 输入错误 \033[0m"
        bash ./node.sh
    fi
}

function v2richo(){
    if [[ -f /etc/redhat-release ]]; then
    release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    else
    echo -e "${red}未检测到系统版本，请联系脚本作者！${plain}\n" && exit 1
    fi
    if [ "$release" == "centos" ]; then
    yum -y install wget curl 
    else
    apt-get -y install wget curl 
    fi
#install_docker
    curl -sSL https://get.docker.com | bash
    service docker start
    systemctl enable docker
#install base
    SN=`cat /proc/sys/kernel/random/uuid`
    mkdir /tmp/$SN
    cd /tmp/$SN
#download_docker-compose.yml
    wget https://raw.githubusercontent.com/siemenstutorials/sspanelv2ray/master/docker-compose.yml
#Setting_Docking
    echo -e "\033[32m------------------Start to set the docking parameters------------------\033[0m"
    echo
    read -p "Please input NodeID(Default NodeID:1)：" Dockerid
    [ -z "${Dockerid}" ] && Dockerid=1
    echo
    echo "-----------------------------------------------------"
    echo "Dockerid = ${Dockerid}"
    echo "-----------------------------------------------------"
    echo
    read -p "Please input URL(Default Url:https://www.xn--9kq078cs77a.com)：" Dockerurl
    [ -z "${Dockerurl}" ] && Dockerurl=https://www.xn--9kq078cs77a.com
    echo
    echo "-----------------------------------------------------"
    echo "dockerurl = ${Dockerurl}"
    echo "-----------------------------------------------------"
    echo
    read -p "Please input KEY(Default Key:key)：" Dockerkey
    [ -z "${Dockerkey}" ] && Dockerkey=key
    echo
    echo "-----------------------------------------------------"
    echo "Dockerkey = ${Dockerkey}"
    echo "-----------------------------------------------------"
    echo
#donload_docker-compose
    curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    curl -L https://raw.githubusercontent.com/docker/compose/1.8.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
    clear
#config
    sed -i "s|SMT|v${Dockerid}|" docker-compose.yml
    sed -i "s|sspankey|${Dockerkey}|" docker-compose.yml
    sed -i "s|68|${Dockerid}|" docker-compose.yml
    sed -i "s|5109|${Dockerid}|" docker-compose.yml
    sed -i "s|https://www.freecloud.pw|${Dockerurl}|" docker-compose.yml
    docker-compose up -d
    docker ps
    echo $SN
    echo -e "\033[32m 安装完成 \033[0m"
}

function v2tls(){
    wget -q https://raw.githubusercontent.com/hikelin19871112/cdntls/master/cfv2.sh && bash cfv2.sh

}


function gost(){
    wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/siemenstutorials/onekeygost/master/install.sh && chmod +x install.sh && ./install.sh
}

function ipta(){
    wget --no-check-certificate -qO natcfg.sh https://raw.githubusercontent.com/arloor/iptablesUtils/master/natcfg.sh && bash natcfg.sh
}

function menu(){
echo "--------------------------------------------------------------"
echo "##############################################################"
echo "# 一键对接脚本v2.0                                           #"
echo "#                                                            #"
echo "# Author：Siemenstutorials                                   #"
echo "#                                                            #"
echo "# Youtube channel:https://www.youtube.com/c/siemenstutorials #"
echo "#                                                            #"
echo "# 适用环境 Debian|Ubuntu|Cent OS                             #"
echo "##############################################################"
echo "--------------------------------------------------------------"

    echo -e "\033[32m [1] \033[0m 安装 SSR 后端"
    echo -e "\033[32m [2] \033[0m 安装v2ray后端"
    echo -e "\033[32m [3] \033[0m 安装 Gost 中转"
    echo -e "\033[32m [4] \033[0m 安装Iptables中转"
    echo -e "\033[41;33m 请输入选项以继续，ctrl+C退出 \033[0m"

    opt=0
    read opt
    if [ "$opt"x = "1"x ]; then
        ssr

    elif [ "$opt"x = "2"x ]; then
        v2ray_opt

    elif [ "$opt"x = "3"x ]; then
        gost
    
    elif [ "$opt"x = "4"x ]; then
        ipta
        
    else
        echo -e "\033[41;33m 输入错误 \033[0m"
        bash ./node.sh
    fi
}

menu
