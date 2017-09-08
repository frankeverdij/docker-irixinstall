service shell
{
    socket_type     = stream
    wait            = no
    user            = root
    log_on_success  += USERID
    log_on_failure  += USERID
    server          = /usr/sbin/in.rshd
    disable         = no
}
