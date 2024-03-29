#ifndef _TYPES_
#define _TYPES_

#include "config.p4"

typedef bit<9>  egress_spec_t;
typedef bit<48> mac_addr_t;
typedef bit<32> ipv4_addr_t;

typedef bit<32> data_t; // 16bit float -> 32bit integer -> int(signed)

#endif /* _TYPES_ */