export WOEKSPACE_PYTHON="/root/workspace/python"
if [ ! -d "$WOEKSPACE_PYTHON/python3" ]; then
    mkdir -p $WOEKSPACE_PYTHON
    cd $WOEKSPACE_PYTHON
    tar -zxvf /tmp/python3.tar.gz
fi
rm /tmp/python3.tar.gz