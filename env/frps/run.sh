if [ ! -d "$WORKDIR/env" ]; then
    mv /tmp/frps/* $WORKDIR
fi

$WORKDIR/frps -c $WORKDIR/env/frps.ini