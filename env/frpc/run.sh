if [ ! -d "$WORKDIR/env" ]; then
    mv /tmp/frpc/* $WORKDIR
fi

$WORKDIR/frpc -c $WORKDIR/env/frpc.ini