OLDDIR=$OLDPWD
if [ ! -d bld ]; then 
    cmake -Bbld -H. 
fi 
cd bld
make install
cd $OLDDIR