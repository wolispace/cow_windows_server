package Winsock;

require Exporter;
#require DynaLoader;
#require AutoLoader;

@ISA = qw(Exporter); #DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	AF_APPLETALK
	AF_CCITT
	AF_CHAOS
	AF_DATAKIT
	AF_DECnet
	AF_DLI
	AF_ECMA
	AF_HYLINK
	AF_IMPLINK
	AF_INET
	AF_IPX
	AF_ISO
	AF_LAT
	AF_MAX
	AF_NETBIOS
	AF_NS
	AF_OSI
	AF_PUP
	AF_SNA
	AF_UNIX
	AF_UNSPEC
	EADDRINUSE
	EADDRNOTAVAIL
	EAFNOSUPPORT
	EALREADY
	ECONNABORTED
	ECONNREFUSED
	ECONNRESET
	EDESTADDRREQ
	EDQUOT
	EHOSTDOWN
	EHOSTUNREACH
	EINPROGRESS
	EISCONN
	ELOOP
	EMSGSIZE
	ENAMETOOLONG
	ENETDOWN
	ENETRESET
	ENETUNREACH
	ENOBUFS
	ENOPROTOOPT
	ENOTCONN
	ENOTEMPTY
	ENOTSOCK
	EOPNOTSUPP
	EPFNOSUPPORT
	EPROCLIM
	EPROTONOSUPPORT
	EPROTOTYPE
	EREMOTE
	ESHUTDOWN
	ESOCKTNOSUPPORT
	ESTALE
	ETIMEDOUT
	ETOOMANYREFS
	EUSERS
	EWOULDBLOCK
	FD_ACCEPT
	FD_CLOSE
	FD_CONNECT
	FD_OOB
	FD_READ
	FD_SETSIZE
	FD_WRITE
	FIOASYNC
	FIONBIO
	FIONREAD
	HOST_NOT_FOUND
	IMPLINK_HIGHEXPER
	IMPLINK_IP
	IMPLINK_LOWEXPER
	INADDR_ANY
	INADDR_BROADCAST
	INADDR_LOOPBACK
	INADDR_NONE
	INVALID_SOCKET
	IN_CLASSA_HOST
	IN_CLASSA_MAX
	IN_CLASSA_NET
	IN_CLASSA_NSHIFT
	IN_CLASSB_HOST
	IN_CLASSB_MAX
	IN_CLASSB_NET
	IN_CLASSB_NSHIFT
	IN_CLASSC_HOST
	IN_CLASSC_NET
	IN_CLASSC_NSHIFT
	IOCPARM_MASK
	IOC_IN
	IOC_INOUT
	IOC_OUT
	IOC_VOID
	IPPORT_BIFFUDP
	IPPORT_CMDSERVER
	IPPORT_DAYTIME
	IPPORT_DISCARD
	IPPORT_ECHO
	IPPORT_EFSSERVER
	IPPORT_EXECSERVER
	IPPORT_FINGER
	IPPORT_FTP
	IPPORT_LOGINSERVER
	IPPORT_MTP
	IPPORT_NAMESERVER
	IPPORT_NETSTAT
	IPPORT_RESERVED
	IPPORT_RJE
	IPPORT_ROUTESERVER
	IPPORT_SMTP
	IPPORT_SUPDUP
	IPPORT_SYSTAT
	IPPORT_TELNET
	IPPORT_TFTP
	IPPORT_TIMESERVER
	IPPORT_TTYLINK
	IPPORT_WHOIS
	IPPORT_WHOSERVER
	IPPROTO_GGP
	IPPROTO_ICMP
	IPPROTO_IDP
	IPPROTO_IP
	IPPROTO_MAX
	IPPROTO_ND
	IPPROTO_PUP
	IPPROTO_RAW
	IPPROTO_TCP
	IPPROTO_UDP
	IP_ADD_MEMBERSHIP
	IP_DEFAULT_MULTICAST_LOOP
	IP_DEFAULT_MULTICAST_TTL
	IP_DROP_MEMBERSHIP
	IP_MAX_MEMBERSHIPS
	IP_MULTICAST_IF
	IP_MULTICAST_LOOP
	IP_MULTICAST_TTL
	IP_OPTIONS
	MAXGETHOSTSTRUCT
	MSG_DONTROUTE
	MSG_MAXIOVLEN
	MSG_OOB
	MSG_PARTIAL
	MSG_PEEK
	NO_ADDRESS
	NO_DATA
	NO_RECOVERY
	PF_APPLETALK
	PF_CCITT
	PF_CHAOS
	PF_DATAKIT
	PF_DECnet
	PF_DLI
	PF_ECMA
	PF_HYLINK
	PF_IMPLINK
	PF_INET
	PF_IPX
	PF_ISO
	PF_LAT
	PF_MAX
	PF_NS
	PF_OSI
	PF_PUP
	PF_SNA
	PF_UNIX
	PF_UNSPEC
	SIOCATMARK
	SIOCGHIWAT
	SIOCGLOWAT
	SIOCSHIWAT
	SIOCSLOWAT
	SOCKET_ERROR
	SOCK_DGRAM
	SOCK_RAW
	SOCK_RDM
	SOCK_SEQPACKET
	SOCK_STREAM
	SOL_SOCKET
	SOMAXCONN
	SO_ACCEPTCONN
	SO_BROADCAST
	SO_CONNDATA
	SO_CONNDATALEN
	SO_CONNOPT
	SO_CONNOPTLEN
	SO_DEBUG
	SO_DISCDATA
	SO_DISCDATALEN
	SO_DISCOPT
	SO_DISCOPTLEN
	SO_DONTLINGER
	SO_DONTROUTE
	SO_ERROR
	SO_KEEPALIVE
	SO_LINGER
	SO_MAXDG
	SO_MAXPATHDG
	SO_OOBINLINE
	SO_OPENTYPE
	SO_RCVBUF
	SO_RCVLOWAT
	SO_RCVTIMEO
	SO_REUSEADDR
	SO_SNDBUF
	SO_SNDLOWAT
	SO_SNDTIMEO
	SO_SYNCHRONOUS_ALERT
	SO_SYNCHRONOUS_NONALERT
	SO_TYPE
	SO_USELOOPBACK
	TCP_BSDURGENT
	TCP_NODELAY
	TRY_AGAIN
	WSABASEERR
	WSADESCRIPTION_LEN
	WSAEACCES
	WSAEADDRINUSE
	WSAEADDRNOTAVAIL
	WSAEAFNOSUPPORT
	WSAEALREADY
	WSAEBADF
	WSAECONNABORTED
	WSAECONNREFUSED
	WSAECONNRESET
	WSAEDESTADDRREQ
	WSAEDISCON
	WSAEDQUOT
	WSAEFAULT
	WSAEHOSTDOWN
	WSAEHOSTUNREACH
	WSAEINPROGRESS
	WSAEINTR
	WSAEINVAL
	WSAEISCONN
	WSAELOOP
	WSAEMFILE
	WSAEMSGSIZE
	WSAENAMETOOLONG
	WSAENETDOWN
	WSAENETRESET
	WSAENETUNREACH
	WSAENOBUFS
	WSAENOPROTOOPT
	WSAENOTCONN
	WSAENOTEMPTY
	WSAENOTSOCK
	WSAEOPNOTSUPP
	WSAEPFNOSUPPORT
	WSAEPROCLIM
	WSAEPROTONOSUPPORT
	WSAEPROTOTYPE
	WSAEREMOTE
	WSAESHUTDOWN
	WSAESOCKTNOSUPPORT
	WSAESTALE
	WSAETIMEDOUT
	WSAETOOMANYREFS
	WSAEUSERS
	WSAEWOULDBLOCK
	WSAHOST_NOT_FOUND
	WSANOTINITIALISED
	WSANO_ADDRESS
	WSANO_DATA
	WSANO_RECOVERY
	WSASYSNOTREADY
	WSASYS_STATUS_LEN
	WSATRY_AGAIN
	WSAVERNOTSUPPORTED
	_WINSOCKAPI_
	h_addr
	h_errno
	s_addr
	s_host
	s_imp
	s_impno
	s_lh
	s_net
);
sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    local($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://;
    $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    ($pack,$file,$line) = caller;
	    die "Your vendor has not defined Winsock macro $constname, used at $file line $line.
";
	}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

boot_Winsock;

# Preloaded methods go here.

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
