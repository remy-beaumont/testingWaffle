#!/bin/sh

# install mono
if ! type mono > /dev/null 2>&1; then
    if test `uname` = Darwin; then
        MONO_VER="3.0.12"
        wget "http://download.mono-project.com/archive/${MONO_VER}/macos-10-x86/MonoFramework-MDK-${MONO_VER}.macos10.xamarin.x86.dmg"
        hdid "MonoFramework-MDK-${MONO_VER}.macos10.xamarin.x86.dmg"
        sudo installer -pkg "/Volumes/Mono Framework MDK ${MONO_VER}/MonoFramework-MDK-${MONO_VER}.macos10.xamarin.x86.pkg" -target /
    else

        # For centos
        sudo wget http://download.opensuse.org/repositories/home:tpokorra:mono/CentOS_CentOS-6/home:tpokorra:mono.repo -O /etc/yum.repos.d/mono.repo
        sudo yum install mono-opt-devel
        PATH=$PATH:/opt/mono/bin
    fi
fi

if test `uname` = Darwin; then
    cachedir=~/Library/Caches/KBuild
else
    if [ -z $XDG_DATA_HOME ]; then
        cachedir=$HOME/.local/share
    else
        cachedir=$XDG_DATA_HOME;
    fi
    mozroots --import --sync
fi
mkdir -p $cachedir

url=https://www.nuget.org/nuget.exe

if test ! -f $cachedir/nuget.exe; then
    wget -O $cachedir/nuget.exe $url 2>/dev/null || curl -o $cachedir/nuget.exe --location $url > /dev/null
fi

if test ! -e .nuget; then
    mkdir .nuget
    cp $cachedir/nuget.exe .nuget/nuget.exe
fi

if ! type k > /dev/null 2>&1; then
    curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh && source ~/.kre/kvm/kvm.sh || wget https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh && source ~/.kre/kvm/kvm.sh 
    kvm upgrade
fi

if test ! -d packages/KoreBuild; then
    mono .nuget/nuget.exe install KoreBuild -ExcludeVersion -o packages -nocache -pre
    mono .nuget/nuget.exe install Sake -version 0.2 -o packages -ExcludeVersion
fi


mono packages/Sake/tools/Sake.exe -I packages/KoreBuild/build -f makefile.shade "$@"