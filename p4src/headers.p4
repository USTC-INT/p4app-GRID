#ifndef HEADERS_P4
#define HEADERS_P4

#include "types.p4"

header ethernet_h {
    mac_addr_t dst_addr;
    mac_addr_t src_addr;
    bit<16>   ether_type;
}

header ipv4_h {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   total_len;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   frag_offset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdr_checksum;
    ipv4_addr_t src_addr;
    ipv4_addr_t dst_addr;
}

header resubmit_t{
    PortId_t port_id;
    bit<48> _pad2;
}

header ina_h {
    bit<32> worker_bitmap;
    bit<8>  count;
    bit<1>  overflow;           
    bit<1>  is_ack;               
    bit<1>  is_collision;                
    bit<1>  is_resend;            
    bit<4>  timestamp;         
    bit<8>  switch_id;
    bit<32> register_index;
    bit<32> frag_id;
}

header payload_h {
    data_t value00;
    data_t value01;
    data_t value02;
    data_t value03;
    data_t value04;
    data_t value05;
    data_t value06;
    data_t value07;
    data_t value08;
    data_t value09;
    data_t value10;
    data_t value11;
    data_t value12;
    data_t value13;
    data_t value14;
    data_t value15;
    data_t value16;
    data_t value17;
    data_t value18;
    data_t value19;
    data_t value20;
    data_t value21;
    data_t value22;
    data_t value23;
    data_t value24;
    data_t value25;
    data_t value26;
    data_t value27;
    data_t value28;
    data_t value29;
    data_t value30;
    data_t value31;
}

struct header_t {
    ethernet_h      ethernet;
    ipv4_h          ipv4;
    ina_h           ina;
    payload_h       gradient;
}


@flexible
struct ingress_metadata_t {
    bit<1> is_aggregation;
    bit<8> first_last_flag; // 0 if first packet, 1 if last packet
    bit<1> is_collision;
    bit<1> is_ack;
    
    bit<32> register_index; // index of used register
    
    bit<8> count; // total no. of workers
    bit<32> frag_id;
    bit<32> read_frag_id; 

    resubmit_t resubmit_data;
}

struct egress_metadata_t {

}

#endif /* HEADERS_P4 */