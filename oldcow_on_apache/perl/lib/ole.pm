package OLE::Variant;

sub new {
    my( $self );
    shift;
    $self->{'Type'} = shift;
    $self->{'Value'} = shift;
    bless $self;
    return $self;
}


package OLE;

# helper routines. see ntole.cpp for all the gory stuff.

sub AUTOLOAD {
    my( $fReturn );
    my( $self ) = shift;
    $AUTOLOAD =~ s/.*:://o;
    if ( main::Win32::OLEDispatch( $self, $AUTOLOAD, $fReturn, @_ ) ) {
        return $fReturn;
    } else {
        return undef;
    }
}


# Automation data types.

eval "sub VT_EMPTY {0;}";
eval "sub VT_NULL {1;}";
eval "sub VT_I2 {2;}";
eval "sub VT_I4 {3;}";
eval "sub VT_R4 {4;}";
eval "sub VT_R8 {5;}";
eval "sub VT_CY {6;}";
eval "sub VT_DATE {7;}";
eval "sub VT_BSTR {8;}";
eval "sub VT_DISPATCH {9;}";
eval "sub VT_ERROR {10;}";
eval "sub VT_BOOL {11;}";
eval "sub VT_VARIANT {12;}";
eval "sub VT_UNKNOWN {13;}";
eval "sub VT_I1 {16;}";
eval "sub VT_UI1 {17;}";
eval "sub VT_UI2 {18;}";
eval "sub VT_UI4 {19;}";
eval "sub VT_I8 {20;}";
eval "sub VT_UI8 {21;}";
eval "sub VT_INT {22;}";
eval "sub VT_UINT {23;}";
eval "sub VT_VOID {24;}";
eval "sub VT_HRESULT {25;}";
eval "sub VT_PTR {26;}";
eval "sub VT_SAFEARRAY {27;}";
eval "sub VT_CARRAY {28;}";
eval "sub VT_USERDEFINED {29;}";
eval "sub VT_LPSTR {30;}";
eval "sub VT_LPWSTR {31;}";
eval "sub VT_FILETIME {64;}";
eval "sub VT_BLOB {65;}";
eval "sub VT_STREAM {66;}";
eval "sub VT_STORAGE {67;}";
eval "sub VT_STREAMED_OBJECT {68;}";
eval "sub VT_STORED_OBJECT {69;}";
eval "sub VT_BLOB_OBJECT {70;}";
eval "sub VT_CF {71;}";
eval "sub VT_CLSID {72;}";


# Current support types are
#   VT_UI1,
#   VT_I2,
#   VT_I4,
#   VT_R4,
#   VT_R8,
#   VT_DATE,
#   VT_BSTR,
#   VT_CY,
#   VT_BOOL,



# Typelib

eval "sub TKIND_ENUM {0;}";
eval "sub TKIND_RECORD {1;}";
eval "sub TKIND_MODULE {2;}";
eval "sub TKIND_INTERFACE {3;}";
eval "sub TKIND_DISPATCH {4;}";
eval "sub TKIND_COCLASS {5;}";
eval "sub TKIND_ALIAS {6;}";
eval "sub TKIND_UNION {7;}";
eval "sub TKIND_MAX {8;}";

sub new {
    my( $object );
    my( $class ) = shift;
    if($class eq 'OLE')
    {
        $class = shift;
    }
    if ( main::Win32::OLECreateObject( $class, $object ) ) {
        return $object;
    } else {
        return undef;
    }
}

sub copy {
    my( $object );
    my( $class ) = shift;
    if($class eq 'OLE')
    {
        $class = shift;
    }
    if ( main::Win32::OLEGetObject( $class, $object ) ) {
        return $object;
    } else {
        return undef;
    }
}

sub DESTROY {
    my( $self ) = shift;
    main::Win32::OLEDestroyObject( $self );
    return undef;
}

*CreateObject = \&new;
*GetObject = \&copy;

1;
