function recreate-build-dir()
{
   rm -r build
   mkdir build
   cd build
}

function remake-autogen-project()
{
    ./autogen.sh --prefix=/home/leecj2/staging --enable-debug
    make clean && make -j4 && make install
}

function remake-unity()
{
    recreate-build-dir
    cmake .. -DCMAKE_BUILD_TYPE=Debug -DCOMPIZ_PLUGIN_INSTALL_TYPE=local -DCMAKE_INSTALL_PREFIX=/home/leecj2/staging/ -DGSETTINGS_LOCALINSTALL=ON
    make -j4 && make install
}

function unity-env
{
 export PATH=~/staging/bin:$PATH
 export XDG_DATA_DIRS=~/.config/compiz-1/gsettings/schemas:~/staging/share:/usr/share:/usr/local/share
 export LD_LIBRARY_PATH=~/staging/lib:${LD_LIBRARY_PATH}
 export LD_RUN_PATH=~/staging/lib:${LD_RUN_PATH}
 export PKG_CONFIG_PATH=~/staging/lib/pkgconfig:${PKG_CONFIG_PATH}
 export PYTHONPATH=~/staging/lib/python2.7/site-packages:$PYTHONPATH
 export UNITY_ENV=1
}

function use-local-compiz
{
  export DISPLAY=:0
  export COMPIZ_CONFIG_PROFILE=ubuntu
}


alias valgrind-unity='G_SLICE=always-malloc G_DEBUG=gc-friendly valgrind --tool=memcheck --num-callers=50 --leak-check=full --track-origins=yes --log-file=unity-valgrind.`date +%Y%m%dT%H%M%S`.txt compiz --replace 2>&1 | tee /home/leecj2/unity-valgrind.`date +%Y%m%dT%H%M%S`.log'