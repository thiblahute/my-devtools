if [ -z $WEBKIT_PORT ]
then
        WEBKIT_PORT="--gtk"
fi

echo "Getting into WebKit$WORKDIRNAME environment"
alias minibrowse="GDK_BACKEND=x11 HOME=\"$(mktemp -d)\" $HOME/devel/Webkit/webkit$WORKDIRNAME/Tools/Scripts/run-minibrowser $WEBKIT_PORT $BUILD_OPTIONS --enable-write-console-messages-to-stdout=1"
alias build="$HOME/devel/Webkit/webkit$WORKDIRNAME/Tools/jhbuild/jhbuild-wrapper $WEBKIT_PORT run cmake --build $HOME/devel/Webkit/webkit$WORKDIRNAME/WebKitBuild/$BUILDTYPE -- -j6 bin/WebKitTestRunner"
# alias r="minibrowse https://webrtc.github.io/samples/src/content/peerconnection/pc1/"
alias br="build && r"
alias jhbuild="$HOME/devel/Webkit/webkit$WORKDIRNAME/Tools/jhbuild/jhbuild-wrapper $WEBKIT_PORT"
export WEBKIT_EXTRA_MODULESETS=file://$HOME/devel/Webkit/gstreamer-extra.jhbuild
export PATH=$HOME/devel/Webkit/webkit$WORKDIRNAME/Tools/Scripts/:$PATH

export WEBKIT_HOME=$HOME/devel/Webkit/webkit$WORKDIRNAME
export CURRENT_GST=$HOME/devel/Webkit/webkit$WORKDIRNAME/WebKitBuild/DependenciesGTK/Source/
source ~/.gstaliases


function gdbruntest()
{
        # LIBGL_DRIVERS_PATH=/home/thiblahute/devel/Webkit/webkit/WebKitBuild/DependenciesGTK/Root/softGL/lib/dri
        # LD_LIBRARY_PATH=/home/thiblahute/devel/Webkit/webkit/WebKitBuild/DependenciesGTK/Root/softGL/lib
        # LIBGL_ALWAYS_SOFTWARE=1
        GDK_BACKEND=x11 TERM=xterm-256color TEST_RUNNER_INJECTED_BUNDLE_FILENAME=$WEBKIT_HOME/WebKitBuild/$BUILDTYPE/lib/libTestRunnerInjectedBundle.so TEST_RUNNER_TEST_PLUGIN_PATH=$WEBKIT_HOME/WebKitBuild/$BUILDTYPE/lib/plugins GSETTINGS_BACKEND=memory G_DEBUG=fatal-criticals JSC_maxPerThreadStackUsage=1572864 __XPC_JSC_maxPerThreadStackUsage=1572864 LOCAL_RESOURCE_ROOT=$WEBKIT_HOME/LayoutTests DUMPRENDERTREE_TEMP=/tmp/WebKitTestRunners-P2LsPn XDG_CACHE_HOME=/tmp/WebKitTestRunners-P2LsPn/appcache xvfb-run $WEBKIT_HOME/Tools/jhbuild/jhbuild-wrapper $WEBKIT_PORT run gdb --args /usr/bin/python2 $WEBKIT_HOME/Tools/jhbuild/jhbuild-wrapper $WEBKIT_PORT run $WEBKIT_HOME/WebKitBuild/$BUILDTYPE/bin/WebKitTestRunner $*
}

function runtest()
{
        # LIBGL_DRIVERS_PATH=/home/thiblahute/devel/Webkit/webkit/WebKitBuild/DependenciesGTK/Root/softGL/lib/dri
        # LD_LIBRARY_PATH=/home/thiblahute/devel/Webkit/webkit/WebKitBuild/DependenciesGTK/Root/softGL/lib
        # LIBGL_ALWAYS_SOFTWARE=1
        GDK_BACKEND=x11 TERM=xterm-256color TEST_RUNNER_INJECTED_BUNDLE_FILENAME=$WEBKIT_HOME/WebKitBuild/$BUILDTYPE/lib/libTestRunnerInjectedBundle.so TEST_RUNNER_TEST_PLUGIN_PATH=$WEBKIT_HOME/WebKitBuild/$BUILDTYPE/lib/plugins GSETTINGS_BACKEND=memory G_DEBUG=fatal-criticals JSC_maxPerThreadStackUsage=1572864 __XPC_JSC_maxPerThreadStackUsage=1572864 LOCAL_RESOURCE_ROOT=$WEBKIT_HOME/LayoutTests DUMPRENDERTREE_TEMP=/tmp/WebKitTestRunners-P2LsPn XDG_CACHE_HOME=/tmp/WebKitTestRunners-P2LsPn/appcache xvfb-run $WEBKIT_HOME/Tools/jhbuild/jhbuild-wrapper $WEBKIT_PORT run $WEBKIT_HOME/Tools/jhbuild/jhbuild-wrapper $WEBKIT_PORT run $WEBKIT_HOME/WebKitBuild/$BUILDTYPE/bin/WebKitTestRunner $*
}
